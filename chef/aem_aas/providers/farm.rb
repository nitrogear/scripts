#This provider creates or removes a farm_*.any file for AEM dispatcher

action :add do
  farm_name = new_resource.farm_name
  apache_user = new_resource.apache_user
  root_group = new_resource.root_group
  farm_dir = new_resource.farm_dir
  dynamic_cluster = new_resource.dynamic_cluster
  vars = {}
  #need the right kind of "empty"
  var_list = { :client_headers => :array, :virtual_hosts => :array,
               :renders => :array, :statistics => :array,
               :render_files => :array,
               :filter_rules => :hash, :cache_rules=> :hash,
               :invalidation_rules => :hash, :allowed_clients => :hash,
               :cache_root => :scalar, :farm_dir => :scalar, :farm_dir => :scalar,
               :farm_name => :scalar, :cache_opts => :array,
               :session_mgmt => :hash, :enable_session_mgmt => :scalar }
  empty = { :array => [], :hash => {}, :scalar => nil }

  #take value passed to provider, or node attribute, or empty
  var_list.keys.each do |var|
    type = var_list[var]
    nothing = empty[type]
    vars[var] = new_resource.send(var) || node['aem']['dispatcher'][var] || nothing
  end

  raise "farm_dir attribute is required to create a farm." unless farm_dir

  template "#{farm_dir}/farm_#{farm_name}.any" do
    source 'farm.any.erb'
    user apache_user
    group root_group
    mode '0664'
    action :create_if_missing
    variables(vars)
    notifies :restart, 'service[httpd24-httpd]'
  end

  if dynamic_cluster then
    if node.role?('aem-publish-epc') then
      port = node['aem']['publish']['port']

      search_query = "aem*aem_options*cluster_id:#{node['aem']['aem_options']['cluster_id']}"

      str = ""
   
    # Get ip addresses of all instances 
      partial_search(:node, search_query, :keys => { 'ipaddress' => ['fqdn'] }) do |n|
        str = str + n['ipaddress'] + "\n"
      end

      ips = str.split()
      ips.sort_by! {|ip| ip.split('.').map{ |octet| octet.to_i}}

      vars[:renders] = []
      #Don't ever return an empty renders list, or apache won't start and
      i=0
      ips.each do |n|
        vars[:renders].push({:name => "000#{i}", :hostname => n, :port => port, :timeout => "0"})
        i=i.next
      end
    else 
      if node.role?('aem-author-epc') then
        vars[:renders] = [] 
        port = node['aem']['author']['port']
        hostname = node['fqdn']
        vars[:renders].push({:name => "0000", :hostname => hostname, :port => port, :timeout => "0"})  
      end
    end
  end
  
  template "#{farm_dir}/render_host.any" do
      source 'render.any.erb'
      user apache_user 
      group root_group
      mode '0664'
      variables(vars) 
      notifies :restart, 'service[httpd24-httpd]'
  end
end

action :remove do
  farm_name = new_resource.farm_name
  farm_dir = new_resource.farm_dir
  file "#{farm_dir}/farm_#{farm_name}.any" do
    action :delete
    notifies :restart, 'service[httpd24-httpd]'
  end
end
