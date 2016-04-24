def whyrun_supported?
  true
end

use_inline_resources

action :install do
  java_package = new_resource.java_package
  java_package_sha256 = new_resource.java_package_sha256
  java_url = new_resource.java_url

  if !::File.exist? '/vagrant/' + java_package
    java_path = java_url
  else
    java_path = 'file:///vagrant/' + java_package
  end
  remote_file "#{Chef::Config[:file_cache_path]}/#{java_package}" do
    source java_path
    checksum java_package_sha256
    retries 2
    action :create
  end
  package "#{Chef::Config[:file_cache_path]}/#{java_package}" do
    action :install
  end
  package 'unzip' do
    action :install
  end
end

action :delete do
end