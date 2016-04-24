def whyrun_supported?
  true
end

use_inline_resources

action :add do

  hybris_server_fqdn = search_for_hybris(@new_resource.hybris_role)

  if !hybris_server_fqdn.nil?
    Chef::Log.info('Hybris server url is: ' + hybris_server_fqdn)
    if get_hybris_server(@new_resource.aem_username,@new_resource.aem_password,@new_resource.port) != hybris_server_fqdn.downcase
      Chef::Log.info('Trying to configure new server.')
      set_hybris_server(@new_resource.aem_username,@new_resource.aem_password,hybris_server_fqdn.downcase,@new_resource.hybris_username,@new_resource.hybris_password,@new_resource.port) 
    end
  else
    Chef::Log.info('Please set clustername to hybris instance')
  end
end

def get_hybris_server (aem_username,aem_password,port)
  aem_url = 'http://localhost:' + port + '/system/console/configMgr/com.adobe.cq.commerce.hybris.common.DefaultHybrisConnection'
  aem_url_ref = 'http://localhost:' + port + '/system/console/configMgr'
  data = {'post' => 'true',
          'ts' => '123' }

  begin
    auth_string =  Base64.encode64(aem_username + ':' + aem_password)
    basic_string = 'Basic ' + auth_string

    uri = URI.parse(aem_url)
    http = Net::HTTP.new(uri.host, uri.port)
    proto = aem_url.split(':', 2)

    if proto[0] == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    http.open_timeout = 25
    http.read_timeout = 25

    headers = {
        'Authorization' => basic_string,
        'Referer' => aem_url_ref
    }

    request = Net::HTTP::Get.new(uri.path)
    request.set_form_data(data)
    request = Net::HTTP::Get.new(uri.path + '?' + request.body , headers)

    resp = http.request(request)
    Chef::Log.info('Get request to AEM hybrys condig status: ' + resp.code)

    hybris_config =  JSON.parse(resp.body)
    Chef::Log.info('Server address: ' + hybris_config['properties']['hybris.server.url']['value'])
    
    current_hybris_server = URI.parse(hybris_config['properties']['hybris.server.url']['value'])
    return current_hybris_server.host.downcase

  rescue Exception => e
    Chef::Log.info('Couldn\'t get Hybris servername by URL: ' + aem_url )
    puts '>>>>>>>>>>>>>>>>>>>> <<<<<<<<<<<<<<<<<<<<<<<'
    puts e
  end
end

def set_hybris_server (aem_username,aem_password,hybris_server,hybris_username,hybris_password,port)
  aem_url = 'http://localhost:' + port + '/system/console/configMgr/com.adobe.cq.commerce.hybris.common.DefaultHybrisConnection'
  aem_url_ref = 'http://localhost:' + port + '/system/console/configMgr'
  data = 'apply=true&action=ajaxConfigManager&$location=jcrinstall:/libs/commerce/install/cq-commerce-hybris-impl-5.8.14.jar&hybris.server.url=' +
      'https://' + hybris_server.downcase + ':9002&' + 
      'hybris.server.username=' + hybris_username + 
      '&hybris.server.password=' + hybris_password + 
      '&hybris.server.ssl.trust_all_certs=true&propertylist=hybris.server.url,hybris.server.username,hybris.server.password,hybris.server.ssl.trust_all_certs'

  begin
    auth_string =  Base64.encode64(aem_username + ':' + aem_password)
    basic_string = 'Basic ' + auth_string

    uri = URI.parse(aem_url)
    http = Net::HTTP.new(uri.host, uri.port)
    proto = aem_url.split(':', 2)

    if proto[0] == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    http.open_timeout = 25
    http.read_timeout = 25

    headers = {
        'Authorization' => basic_string,
        'Referer' => aem_url_ref
    }

    resp = http.post(uri.path, data, headers)
    Chef::Log.info('Hybris server successfully configured.')
    Chef::Log.info('New hybris server endpoint: ' + hybris_server)

    # if [301, 302, 307].include? resp.code.to_i
    #   puts resp['location']
    # end

  rescue Exception => e
    Chef::Log.info('Failed to configure Hybris endpoint.')
    Chef::Log.info('>>>>>>>>> ' + e)
  end
end

def search_for_hybris (role)

  begin
    partial_search(:node, "role:#{role} AND cluster_name:#{node['cluster_name']}",
                :keys => {
                  'fqdn' => [ 'fqdn' ]
                } ).each do |n|

      if !n['fqdn'].nil? 
        Chef::Log.info("Found hybris server: #{n['fqdn'].downcase}")
        return n['fqdn']
      end
      return nil
    end
  rescue Exception => e
    Chef::Log.error('Prtial search is broken')
    return nil
    puts e
  end

end
