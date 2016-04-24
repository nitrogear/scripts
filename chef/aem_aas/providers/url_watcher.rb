require 'net/https'
require 'uri'

def whyrun_supported?
  true
end

use_inline_resources

action :wait do

  wait_between_attempts = new_resource.wait_between_attempts
  validation_url = new_resource.validation_url
  max_attempts = new_resource.max_attempts
  match_string = new_resource.match_string
  aem_username = new_resource.aem_username
  aem_password = new_resource.aem_password
  sleep_before = new_resource.sleep_before

sleep sleep_before

  def get_status_code(aem_username, aem_password, validation_url, wait_between_attempts, max_attempt)
    begin
      url = URI.parse(validation_url)
      connection = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Get.new(url.request_uri)
      proto = validation_url.split(':', 2)
      if proto[0] == 'https'
        connection.use_ssl = true
        connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request.basic_auth(aem_username, aem_password)
      response = connection.request(request)
      if response.code != '200'
        raise 'Wrong status code'
      end

    rescue
      if (max_attempts -= 1) >= 0
        puts "Waiting for URL..."
        sleep wait_between_attempts
        retry
      else
        Chef::Log.fatal('Max attempts reached...')
        exit 1
      end

    else
      puts
      puts "AEM is UP"
    end
  end

  def get_status_string(aem_username, aem_password, validation_url, match_string, wait_between_attempts, max_attempts)
    
    begin
      url = URI.parse(validation_url)
      connection = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Get.new(url.request_uri)
      proto = validation_url.split(':', 2)
      if proto[0] == 'https'
        connection.use_ssl = true
        connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request.basic_auth(aem_username, aem_password)
      response = connection.request(request)
      unless response.body.include?(match_string)
        raise 'AEM unavailable'
      end

    rescue
      if (max_attempts -= 1) >= 0
        puts "Waiting for URL..."
        sleep wait_between_attempts
        retry
      else
        Chef::Log.fatal('Max attempts reached...')
        exit 1
      end

    else
      puts
      puts "AEM is UP"
    end
  end

  if match_string
    get_status_string(aem_username, aem_password, validation_url, match_string, wait_between_attempts, max_attempts)
  else
    get_status_code(aem_username, aem_password, validation_url, wait_between_attempts, max_attempts)
  end
end
