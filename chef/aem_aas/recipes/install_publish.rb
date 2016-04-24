include_recipe "aem_aas::preinstall"

aem_aas_install 'aem-install' do
  service_name 'publish'
  port node['aem']['publish']['port']
  java_opts node['aem']['publish']['java_opts'] unless node['aem']['publish']['java_opts'].nil?
  action :install
end

node['aem']['publish']['validation_urls'].each do |url, word|
  aem_aas_url_watcher url do
    validation_url url
    match_string word
    sleep_before node['aem']['url_wather']['sleep_before_start']
    max_attempts node['aem']['url_wather']['max_attempts']
    wait_between_attempts node['aem']['url_wather']['wait_between_attempts']
    action :wait
  end
end

aem_aas_packages 'aem-install-packages' do
  port node['aem']['publish']['port']
  base_packages node['aem']['publish']['additional']['install_packages']
  current_version_packages node['aem']['publish']['6.1.0']['install_packages']
  action :install
end

aem_aas_dispatcher 'dispatcher' do
  action :install
end

if node['aem']['modules']['hybris']['enabled'] == true
  include_recipe 'aem_aas::hybris_modules'

  aem_aas_hybris_connector 'hybris_integration' do
    aem_username node['aem']['publish']['admin_user']
    aem_password node['aem']['publish']['admin_password']
    hybris_username node['aem']['modules']['hybris']['hybris_username']
    hybris_password node['aem']['modules']['hybris']['hybris_password']
    hybris_role node['aem']['modules']['hybris']['type']
    port node['aem']['publish']['port']
    action :add
  end
end

aem_aas_modify_page 'Disable cart' do
  aem_username node['aem']['author']['admin_user']
  aem_password node['aem']['author']['admin_password']
  page node['aem']['crx']['page']
  page_attribute node['aem']['crx']['page_attribute']
  page_attribute_value node['aem']['crx']['page_attribute_value']
  port node['aem']['author']['port']
  action :add
end