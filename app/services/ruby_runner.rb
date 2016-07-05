class RubyRunner
  attr_accessor :ruby_bin, :container_name, :output, :lint_errors, :rubocop_errors, :test_runs, :timeout

  def initialize(ruby_bin)
    self.ruby_bin = ruby_bin
    self.container_name = "ruby-2-3-1"
    self.test_runs = []
    self.timeout = 10
  end

  #Note: execute method executes ruby code by dumping ruby code in a file in /tmp/ directory with filename id.rb
  # Ensure that a docker instance running with ruby 2.3.1. container's name must be ruby-2-3-1 and /tmp/ is mounted in
  # docker container's /tmp/
  def execute
    return "Docker container not running" unless ensure_container_running
    create_ruby_file
    output = execute_rubybin_file
    lint_errors = check_lint
    rubocop_errors = check_rubocop
    run_tests
    delete_ruby_file
    self.output = output
    self.lint_errors = lint_errors
    self.rubocop_errors = rubocop_errors
  end


  private

  def ensure_container_running
    Rails.logger.info "#"*80
    Rails.logger.debug "Checking if container '#{container_name}' is running"
    container_status = `docker inspect -f {{.State.Running}} #{container_name}`

    if container_status.strip == 'true'
      Rails.logger.debug "Container '#{container_name}' is running.."
    else
      Rails.logger.debug "Container '#{container_name}' is not running... Trying to run"
      container_run_cmd  = "run -it --name #{container_name} -d -v /tmp:/tmp bansalakhil/akhil-ruby:2.3.1"
      container_stop_cmd = "stop #{container_name}"
      container_rm_cmd   = "rm -f #{container_name}"

      `docker #{container_stop_cmd}`
      `docker #{container_rm_cmd}`
      `docker #{container_run_cmd}`

      container_status = `docker inspect -f {{.State.Running}} #{container_name}`

      # install required gems
      # `docker exec #{container_name} gem install rubocop ruby-lint --no-ri --no-rdoc`
    end
    Rails.logger.info "#"*80
    container_status.strip == 'true'
  end

  def create_ruby_file
    Rails.logger.info "#"*80
    Rails.logger.debug "creating ruby file for ruby_bin##{ruby_bin.id}"
    File.open(ruby_bin_file, "w") { |io|  io.puts ruby_bin.code}
  end

  def check_lint
    Rails.logger.info "#"*80
    Rails.logger.debug "creating lint for ruby_bin##{ruby_bin.id}"
    `docker exec #{container_name} timeout #{timeout} ruby-lint #{ruby_bin_file}`
  end

  def run_tests
    return if ruby_bin.tests.blank?
    Rails.logger.info "#"*80
    Rails.logger.debug "Running tests"
    tests = ruby_bin.tests.split("===")
    if tests.present?
      tests.each do |test|
        name = test.scan(/\[name\](.*)\[\/name\]/mi).flatten.first.strip rescue ""
        input = test.scan(/\[input\](.*)\[\/input\]/mi).flatten.first.strip rescue ""
        output = test.scan(/\[output\](.*)\[\/output\]/mi).flatten.first.strip rescue ""
        output = output.gsub(/\r\n/, "\n")
        actual_output = (`docker exec #{container_name} timeout #{timeout} ruby #{ruby_bin_file} #{input}`).strip rescue ""
        
        Rails.logger.info "#"*80
        Rails.logger.info "#"*80
        Rails.logger.info "Expected Output:\n#{output.inspect}"
        Rails.logger.info "Actual Output:\n#{actual_output.inspect}"
        Rails.logger.info "#"*80
        Rails.logger.info "#"*80

        self.test_runs<< {name: name, input: input, output: output, actual_output: actual_output, passed: (output == actual_output)}
      end
    end
  end

  def check_rubocop
    Rails.logger.info "#"*80
    Rails.logger.debug "creating rubocop for ruby_bin##{ruby_bin.id}"
    `docker exec #{container_name} timeout #{timeout} rubocop --format json #{ruby_bin_file}`
  end

  def ruby_bin_file
    "/tmp/rubybin_#{ruby_bin.id}.rb"
  end

  def execute_rubybin_file
    `docker exec  #{container_name} timeout #{timeout} ruby #{ruby_bin_file} #{ruby_bin.input}`
  end

  def delete_ruby_file
    File.delete(ruby_bin_file)
  end
end
