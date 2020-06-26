class MysqlRunner
  attr_accessor :mysql_bin, :container_name,  :schema_output, :queries_output, :timeout, :docker_image, :mysql_password

  def initialize(mysql_bin)
    self.mysql_bin = mysql_bin
    self.container_name = "mybin-sql-runner"
    self.docker_image = "mysql:5.7.30"
    self.mysql_password = 'mysecretpassword'
    self.timeout = 15
  end

  def execute
    return "Docker container not running" unless ensure_container_running
    create_sql_schema_file
    create_sql_query_file
    # debugger

    self.schema_output = execute_schema_file
    self.queries_output = execute_queries_file

    delete_mysql_bin_file
    # debugger
    # ensure_container_stopped
  end


  private

  def ensure_container_stopped
    Rails.logger.info "#"*80
    Rails.logger.info "Stopping and removing container #{container_name}"
    # stop_container
    # Rails.logger.info "Stopped container #{container_name}"
    remove_container
    Rails.logger.info "Removed container #{container_name}"

    container_status = `docker inspect -f {{.State.Running}} #{container_name}`

    Rails.logger.info "Container #{container_name} running status:  #{container_status}"

    Rails.logger.info "#"*80
  end

  def stop_container
    container_stop_cmd = "stop #{container_name}"
    `docker #{container_stop_cmd}`
  end

  def remove_container
    container_rm_cmd   = "rm -f #{container_name}"
    `docker #{container_rm_cmd}`
  end

  def run_container
    container_run_cmd  = "run -it --name #{container_name} -e MYSQL_ROOT_PASSWORD=#{mysql_password} -d -v /tmp:/tmp #{docker_image}"
    `docker #{container_run_cmd}`
  end

  def ensure_container_running
    Rails.logger.info "#"*80
    Rails.logger.debug "Checking if container '#{container_name}' is running"
    container_status = `docker inspect -f {{.State.Running}} #{container_name}`

    if container_status.strip == 'true'
      Rails.logger.debug "Container '#{container_name}' is running.."
    else
      Rails.logger.debug "Container '#{container_name}' is not running... Trying to run"

      stop_container
      remove_container
      run_container

      container_status = `docker inspect -f {{.State.Running}} #{container_name}`

    end
    Rails.logger.info "#"*80
    container_status.strip == 'true'
  end

  def create_sql_schema_file
    Rails.logger.info "#"*80
    Rails.logger.debug "creating db schema file for mysql_bin##{mysql_bin.id}"
    File.open(mysql_bin_db_schema_file, "w") do |io|
      io.puts "CREATE DATABASE IF NOT EXISTS #{mysql_bin.db_name};"
      io.puts "use #{mysql_bin.db_name};"
      io.puts mysql_bin.schema
    end
  end

  def create_sql_query_file
    Rails.logger.info "#"*80
    Rails.logger.debug "creating db query file for mysql_bin##{mysql_bin.id}"
    File.open(mysql_bin_db_queries_file, "w") do |io|
      io.puts "use #{mysql_bin.db_name};"
      io.puts mysql_bin.queries
      io.puts "DROP DATABASE IF EXISTS #{mysql_bin.db_name};"
    end
  end

  def mysql_bin_db_schema_file
    "/tmp/mysqlbin_#{mysql_bin.id}_schema.sql"
  end

  def mysql_bin_db_queries_file
    "/tmp/mysqlbin_#{mysql_bin.id}_queries.sql"
  end

  def execute_schema_file
    `docker exec  #{container_name} timeout #{timeout} bash -c "mysql -u root -p#{mysql_password} -t -v -v -v < #{mysql_bin_db_schema_file}" `
  end

  def execute_queries_file
    `docker exec  #{container_name} timeout #{timeout} bash -c "mysql -u root -p#{mysql_password} -t -v -v -v < #{mysql_bin_db_queries_file}" `
  end

  def delete_mysql_bin_file
    File.delete(mysql_bin_db_schema_file)
    File.delete(mysql_bin_db_queries_file)
  end
end
