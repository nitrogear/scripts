def whyrun_supported?
  true
end

use_inline_resources

action :install do
  aem_user = new_resource.aem_user
  user aem_user do
    comment "aem role user"
    system true
    shell "/bin/bash"
    home "/home/#{aem_user}"
    supports :manage_home => true
    action :create
  end
  unless node['aem']['license_url']
    Chef::Application.fatal! 'aem.license_url attribute cannot be nil. Please populate that attribute.'
  end
  unless node['aem']['aem_url']
    Chef::Application.fatal! 'aem.aem_url attribute cannot be nil. Please populate that attribute.'
  end

  service_name = new_resource.service_name
  aem_package = new_resource.aem_package
  aem_package_sha256 = new_resource.aem_package_sha256
  version = new_resource.version
  aem_url = new_resource.aem_url
  license_url = new_resource.license_url
  port = new_resource.port
  prefix = new_resource.prefix
  java_opts = new_resource.java_opts

  install_path = "#{prefix}/#{service_name}"
  directory install_path do
    owner aem_user
    group aem_user
    mode '0755'
    recursive true
  end

  remote_file "#{Chef::Config[:file_cache_path]}/aem-quickstart-#{version}.jar" do
    source aem_url
    checksum aem_package_sha256
    mode '0755'
    action :create_if_missing
    backup false
  end
  
  install_jar = "#{install_path}/aem-#{service_name}-p#{port}.jar"
  remote_file install_jar do
    source "file://#{Chef::Config[:file_cache_path]}/aem-quickstart-#{version}.jar"
    mode '0755'
    checksum aem_package_sha256
    owner aem_user
    group aem_user
    action :create_if_missing
  end

  bash "unpack jar" do
    user aem_user
    group aem_user
    cwd install_path
    code "java -jar #{install_jar} -unpack"
  end unless Object::File.exists?("#{install_path}/crx-quickstart")

  remote_file "#{install_path}/license.properties" do
    source node['aem']['license_url']
    owner aem_user
    group aem_user
    mode 0644
  end

  template "/etc/init.d/aem-#{service_name}" do
    source 'init.erb'
    mode '0755'
    variables(install_path: install_path, aem_user: aem_user,
      java_opts: java_opts, cq_port: port, cq_runmode: service_name
    )
  end

  service "aem-#{service_name}" do
    supports :status => true, :stop => true, :start => true, :restart => true
    action [ :enable, :start ]
  end 

end

action :delete do
end