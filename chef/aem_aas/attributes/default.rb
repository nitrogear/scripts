default['aem']['download_url'] = 'https://localhost2/storage'

default['aem']['java_package'] = 'jdk-8u65-linux-x64.rpm'
default['aem']['java_package_sha256'] = 'f6a9046c700e020e3f34e9aefb795f134e225f3242eda420fb99aa62bedbeabd'
default['aem']['java_url'] = node['aem']['download_url'] + '/jdk/' + node['aem']['java_package']

default['aem']['aem_package'] = 'aem-author-4502.jar'
default['aem']['aem_package_sha256'] = '8f68a804a9271e3dcf13778b86c3fbc02fa890093f24422cad3e8de8e451252a'
default['aem']['version'] = '6.1.0'
default['aem']['aem_url'] = node['aem']['download_url'] + '/aem/' + node['aem']['version'] + '/' + node['aem']['aem_package']
default['aem']['license_url'] = node['aem']['download_url'] + '/aem/6.1.0/license.properties'

default['aem']['author']['port'] = '4502'
default['aem']['publish']['port'] = '4503'
default['aem']['author']['java_opts'] = '-server -Xmx1024m -XX:MaxPermSize=256M -Djava.awt.headless=true'
default['aem']['publish']['java_opts'] = '-server -Xmx1024m -XX:MaxPermSize=256M -Djava.awt.headless=true'

default['aem']['author']['admin_user'] = 'admin'
default['aem']['author']['admin_password'] = 'admin'
default['aem']['publish']['admin_user'] = 'admin'
default['aem']['publish']['admin_password'] = 'admin'

default['apache']['user'] = 'apache'
default['apache']['root_group'] = 'root'
default['apache']['prefix'] = '/opt/rh/httpd24/root'
default['apache']['dir'] = node['apache']['prefix'] + '/etc/httpd'

default['aem']['dispatcher']['dispatcher_url'] = node['aem']['download_url'] + '/aem/6.1.0/dispatcher/mod_dispatcher.so'
default['aem']['dispatcher']['checksum'] = '02df6ff7fce0a5c25e4e55446a0478513a99d4bd6b0953362ce00919df9a2a21'
default['aem']['dispatcher']['farm_dir'] = node['apache']['dir'] + '/conf/aem-farms'
default['aem']['dispatcher']['farm_name'] = 'default'
default['aem']['dispatcher']['farm_files'] = [ 'farm_*.any' ]
default['aem']['dispatcher']['log_level'] = 2
default['aem']['dispatcher']['conf_file'] = 'conf/dispatcher.any'

default['aem']['packages']['dir'] = '/opt/aem/packages'
default['aem']['author']['additional']['install_packages'] = [ ]
default['aem']['author']['6.1.0']['install_packages'] = [
  'https://localhost/storage/aem/6.1.0/AEM-6.1-Service-Pack-1-6.1.SP1.zip'
  ]

default['aem']['publish']['additional']['install_packages'] = [ ]
default['aem']['publish']['6.1.0']['install_packages'] = [
  'https://localhost/storage/aem/6.1.0/AEM-6.1-Service-Pack-1-6.1.SP1.zip'
  ]

default['aem']['dispatcher']['root_dir']  = '/opt/communique/dispatcher'
default['aem']['dispatcher']['client_headers'] = [ "*" ]
default['aem']['dispatcher']['virtual_hosts'] = [ "*" ]
default['aem']['dispatcher']['renders'] = [ { :name => "0000", :hostname => "localhost",
                  :port => "4503", :timeout => "0" } ]
default['aem']['dispatcher']['render_files'] = [ "render_*" ]
default['aem']['dispatcher']['cache_root'] = '/opt/communique/dispatcher/cache'
default['aem']['dispatcher']['invalidation_rules'] = {
    "0000" => { :glob => "*", :type => "deny" },
    "0001" => { :glob => "*.html", :type => "allow" }
  }
default['aem']['dispatcher']['allowed_clients'] = {}
default['aem']['dispatcher']['statistics'] = [
    { :name => "html", :glob => "*.html" },
    { :name => "others", :glob => "*" },
  ]
default['aem']['dispatcher']['cache_opts'] = []
default['aem']['dispatcher']['session_mgmt'] = {
    "directory" => "#{node['apache']['dir']}/dispatcher/sessions",
    "header" => "Cookie:login-token"
  }
default['aem']['dispatcher']['enable_session_mgmt'] = false
default['aem']['dispatcher']['dynamic_cluster'] = false

default['aem']['url_wather']['max_attempts'] = 20
default['aem']['url_wather']['wait_between_attempts'] = 30
default['aem']['url_wather']['sleep_before_start'] = 0

default['aem']['author']['validation_urls'] = { 
  "http://localhost:#{node['aem']['author']['port']}/damadmin" => 'Assets',
  "http://localhost:#{node['aem']['author']['port']}/miscadmin" => 'Tools',
  "http://localhost:#{node['aem']['author']['port']}/system/console/bundles" => 'Experience'
}

default['aem']['publish']['validation_urls'] = { 
  "http://localhost:#{node['aem']['publish']['port']}/damadmin" => 'Assets',
  "http://localhost:#{node['aem']['publish']['port']}/miscadmin" => 'Tools',
  "http://localhost:#{node['aem']['publish']['port']}/system/console/bundles" => 'Experience'
}

default['aem']['modules']['hybris']['enabled'] = true
default['aem']['modules']['hybris']['hybris_username'] = 'admin'
default['aem']['modules']['hybris']['hybris_password'] = 'unmodified'
default['aem']['modules']['hybris']['type'] = 'hybris'

default['aem']['module']['url']['geometrixx-hybris-content'] = node['aem']['download_url'] + '/aem/6.1.0/modules/cq-geometrixx-hybris-content-6.0.58.zip'
default['aem']['module']['md5']['geometrixx-hybris-content'] = '11fd9c7b7edc5f0cecf41622e86bd9c7'
default['aem']['module']['url']['hybris-content'] = node['aem']['download_url'] + '/aem/6.1.0/modules/cq-hybris-content-6.0.58.zip'
default['aem']['module']['md5']['hybris-content'] = '11fd9c7b7edc5f0cecf41622e86bd9c7'

default['aem']['crx']['page'] = '/etc/cloudsettings/default/contexthub/cart.json'
default['aem']['crx']['page_attribute'] = 'enabled'
default['aem']['crx']['page_attribute_value'] = 'false'
