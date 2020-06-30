require 'to_64_html'

class MysqlRunner
  attr_accessor :mysql_bin, :container_name, :schema_output, :queries_output, :schema_output_error, :queries_output_error, :timeout, :docker_image, :mysql_password, :schemacrawler_container, :schemacrawler_image, :schema_png, :schema_html

  PASSWORD_WARNING = "mysql: [Warning] Using a password on the command line interface can be insecure."

  def initialize(mysql_bin)
    self.mysql_bin = mysql_bin
    self.container_name = "mybin-sql-runner"
    self.docker_image = "mysql:5.7.30"
    self.mysql_password = 'mysecretpassword'
    self.schemacrawler_container = 'schemacrawler_container'
    self.schemacrawler_image = 'schemacrawler/schemacrawler:latest'
    self.timeout = 15
  end

  def execute
    return "Docker container not running" unless ensure_container_running
    create_sql_schema_file
    create_sql_query_file

    self.schema_output = execute_schema_file
    self.queries_output = execute_queries_file
    self.schema_output_error = File.read(mysql_bin_db_schema_output_file).gsub(PASSWORD_WARNING, '')
    self.queries_output_error = File.read(mysql_bin_db_queries_output_file).gsub(PASSWORD_WARNING, '')

    delete_mysql_bin_file
    # ensure_container_stopped
  end


  def generate_schema_png
    return "Docker container not running" unless ensure_container_running
    return "Docker container schemacrawler not running" unless ensure_schemacrawler_container_running
    create_sql_schema_file
    create_sql_query_file
    execute_schema_file
    export_schema_as_png
    execute_queries_file
    self.schema_png = To64Html.img64(mysql_bin_db_schema_png_file)
    delete_mysql_bin_file
  end

  def generate_schema_html
    return "Docker container not running" unless ensure_container_running
    return "Docker container schemacrawler not running" unless ensure_schemacrawler_container_running
    create_sql_schema_file
    create_sql_query_file
    execute_schema_file
    export_schema_as_html
    execute_queries_file
    self.schema_html = File.read(mysql_bin_db_schema_html_file)
    delete_mysql_bin_file
  end


  private

  def get_mysql_contaner_ip_address
    ip_address = `docker inspect -f {{.NetworkSettings.Networks.#{DOCKER_CONTAINER_NETWORK_NAME}.IPAddress}} #{container_name}`
    ip_address.strip
  end

  def ensure_schemacrawler_container_running
    Rails.logger.info "#"*80
    Rails.logger.info "Stopping and removing container #{schemacrawler_container}"

    `docker rm -f #{schemacrawler_container}`
    Rails.logger.info "Removed container #{schemacrawler_container}"

    `docker run -it --network #{DOCKER_CONTAINER_NETWORK_NAME} --name #{schemacrawler_container} -d -v /tmp:/tmp  --entrypoint=/bin/bash #{schemacrawler_image}`

    container_status = `docker inspect -f {{.State.Running}} #{schemacrawler_container}`

    Rails.logger.info "Container #{schemacrawler_container} running status:  #{container_status}"

    Rails.logger.info "#"*80
  end

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
    container_run_cmd  = "run -it --network #{DOCKER_CONTAINER_NETWORK_NAME} --name #{container_name} -e MYSQL_ROOT_PASSWORD=#{mysql_password} -d -v /tmp:/tmp #{docker_image}"
    `docker network create #{DOCKER_CONTAINER_NETWORK_NAME}`
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

  def mysql_bin_db_schema_png_file
    "/tmp/mysqlbin_#{mysql_bin.id}_schema.png"
  end

  def mysql_bin_db_schema_html_file
    "/tmp/mysqlbin_#{mysql_bin.id}_schema.html"
  end

  def mysql_bin_db_schema_file
    "/tmp/mysqlbin_#{mysql_bin.id}_schema.sql"
  end

  def mysql_bin_db_schema_output_file
    "/tmp/mysqlbin_#{mysql_bin.id}_schema.sql.output"
  end

  def mysql_bin_db_queries_file
    "/tmp/mysqlbin_#{mysql_bin.id}_queries.sql"
  end

  def mysql_bin_db_queries_output_file
    "/tmp/mysqlbin_#{mysql_bin.id}_queries.sql.output"
  end

  def execute_schema_file
    `docker exec  #{container_name} timeout #{timeout} bash -c "mysql -u root -p#{mysql_password} -t -v -v -v < #{mysql_bin_db_schema_file}" 2> #{mysql_bin_db_schema_output_file}`
  end

  def execute_queries_file
    `docker exec  #{container_name} timeout #{timeout} bash -c "mysql -u root -p#{mysql_password} -t -v -v -v < #{mysql_bin_db_queries_file}   2> #{mysql_bin_db_queries_output_file}" `
  end

  def export_schema_as_png
    `docker exec #{schemacrawler_container}   bash -c "/opt/schemacrawler/schemacrawler.sh --server=mysql --host=#{get_mysql_contaner_ip_address} --port=3306 --database=#{mysql_bin.db_name} --schemas=#{mysql_bin.db_name} --user=root --password=#{mysql_password} --info-level=maximum --command=schema -F png -o #{mysql_bin_db_schema_png_file} "`
  end

  def export_schema_as_html
    `docker exec #{schemacrawler_container}  bash -c "/opt/schemacrawler/schemacrawler.sh --server=mysql --host=#{get_mysql_contaner_ip_address} --port=3306 --database=#{mysql_bin.db_name} --schemas=#{mysql_bin.db_name} --user=root --password=#{mysql_password} --info-level=maximum --command=schema -F html -o #{mysql_bin_db_schema_html_file} "`
  end

  def delete_mysql_bin_file
    # begin
      File.delete(mysql_bin_db_schema_file) rescue nil
      File.delete(mysql_bin_db_schema_output_file) rescue nil
      File.delete(mysql_bin_db_queries_file) rescue nil
      File.delete(mysql_bin_db_queries_output_file) rescue nil
      File.delete(mysql_bin_db_schema_png_file) rescue nil
      File.delete(mysql_bin_db_schema_html_file) rescue nil
    # rescue Exception => e

    # end
  end
end
