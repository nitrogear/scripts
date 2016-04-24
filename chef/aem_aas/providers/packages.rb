require 'net/http'
require 'uri'

def whyrun_supported?
  true
end

use_inline_resources

action :install do

  base_packages = new_resource.base_packages
  current_version_packages = new_resource.current_version_packages
  install_packages = base_packages + current_version_packages

  directory node['aem']['packages']['dir']

  install_packages.each do |package_url|
    file_name = package_url.split("/").last

    r = remote_file 'Download package' do
      source package_url
      path "#{Chef::Config[:file_cache_path]}/#{file_name}"
      action :nothing
    end
    r.run_action(:create)

    if !::File.exists?("#{node['aem']['packages']['dir']}/#{file_name}")
      install_package(new_resource.aem_username, new_resource.aem_password, new_resource.port, file_name)
    end

    file "#{node['aem']['packages']['dir']}/#{file_name}"
  end
end

action :uninstall do
  package_name = new_resource.package_name

  uninstall_package(new_resource.aem_username, new_resource.aem_password, new_resource.port, new_resource.group_name, package_name)

  directory node['aem']['packages']['dir']

  file "#{node['aem']['packages']['dir']}/#{package_name}.uninstalled"
end


def install_package (aem_username, aem_password, port, file_name)
  aem_url = 'http://localhost:' + port + '/crx/packmgr/service.jsp'
  url = URI.parse(aem_url)
  file = ::File.open("#{Chef::Config[:file_cache_path]}/#{file_name}")
  form_data = {'file' => file, 'force' => "true", 'install' => "true" }

  begin
    connection = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Post.new(url.request_uri)
    proto = aem_url.split(':', 2)
    if proto[0] == 'https'
        connection.use_ssl = true
        connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    request.basic_auth(aem_username, aem_password)
    request.set_form form_data, 'multipart/form-data'
    response = connection.request request

  rescue Exception => e
    Chef::Log.warn('Couldn\'t upload package : ' + file_name )
    puts e
    exit 1
  end
end

def uninstall_package (aem_username, aem_password, port, group_name, package_name)
  aem_url = 'http://localhost:' + port + "/crx/packmgr/service/.json/etc/packages/#{group_name}/#{package_name}?cmd=delete"
  url = URI.parse(aem_url)

  begin
    connection = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Post.new(url.request_uri)
    proto = aem_url.split(':', 2)
    if proto[0] == 'https'
      connection.use_ssl = true
      connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
     request.basic_auth(aem_username, aem_password)
     response = connection.request request

  rescue Exception => e
    Chef::Log.warn('Couldn\'t delete package : ' + file_name )
    puts e
    exit 1
  end
end
