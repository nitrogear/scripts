default['storage']='https://localhost/storage/'

default['java']['install_flavor'] = 'windows'
default['java']['jdk_version'] = '8'
default['java']['windows']['url'] = "#{node['storage']}/jdk/jdk-8u65-windows-x64.exe"
default['java']['windows']['checksum'] = '589633b8688ef7331a861a6d87487a82ed40bc6c287c4c567c4f91737c5011d5'
default['java']['windows']['package_name'] = 'Java SE Development Kit 8 Update 65 (64-bit)'

default['git']['url'] = "#{node['storage']}/git/Git-2.7.1-64-bit.exe"
default['git']['checksum'] = 'ab3eee9558f5bedffbe5518edcd84dbade813a013470d7640285a9c9c263be5a'
default['git']['display_name'] = 'Git version 2.7.1'

default['firefox']['version'] = '44.0.1'

default['maven']['url'] = 'http://apache.ip-connect.vn.ua/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.zip'
