# We can add 'if' statement to avoid running java cookbook if java is installed already. It's applictable for all resources below
include_recipe 'java'

# Install git client
windows_package node['git']['display_name'] do
  action :install
  source node['git']['url']
  checksum node['git']['checksum']
  installer_type :inno
end

# install maven
windows_zipfile 'Install Maven' do 
  path 'C:\Program Files\\'
  source node['maven']['url'] 
  action :unzip 
  not_if {::File.exists?('C:\Program Files\apache-maven-3.3.9\bin\mvn')} 
end

# Install firefox
include_recipe 'firefox'
