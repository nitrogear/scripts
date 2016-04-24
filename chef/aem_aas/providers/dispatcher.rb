def whyrun_supported?
  true
end

use_inline_resources

action :install do
  dispatcher_url = new_resource.dispatcher_url
  dispatcher_checksum = new_resource.dispatcher_checksum
  apache_prefix = new_resource.apache_prefix
  apache_dir = new_resource.apache_dir
  dispatcher_root_dir = new_resource.dispatcher_root_dir
  farm_name = new_resource.farm_name
  farm_dir = new_resource.farm_dir
  apache_user = new_resource.apache_user
  root_group = new_resource.root_group
  farm_files = new_resource.farm_files
  dispatcher_log_level = new_resource.dispatcher_log_level
  dispatcher_conf_file = new_resource.dispatcher_conf_file
  cache_root = new_resource.cache_root

  package 'centos-release-scl'
  package 'httpd24'
  package 'httpd24-mod_ssl'

  remote_file "#{Chef::Config[:file_cache_path]}/mod_dispatcher.so" do
    source dispatcher_url
    checksum dispatcher_checksum
    retries 2
    mode '0644'
    action :create
    not_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/mod_dispatcher.so") }
  end

  remote_file "#{apache_dir}/modules/mod_dispatcher.so" do
    source "file://#{Chef::Config[:file_cache_path]}/mod_dispatcher.so"
    checksum dispatcher_checksum
    mode '0644'
    not_if { ::File.exists?("#{apache_dir}/modules/mod_dispatcher.so") }
  end

  %W[ #{farm_dir} #{apache_dir}/dispatcher/sessions #{cache_root} ].each do |path|
    directory path do
      mode '0755'
      owner apache_user
      group root_group
      recursive true
      action :create
    end
  end

  # we need to prevent dispatcher remove cache directory
  directory dispatcher_root_dir do
    mode '0555'
    owner apache_user
    group root_group
    action :create
  end

  template "#{apache_dir}/conf.d/dispatcher.conf" do
    source 'dispatcher.conf.erb'
    owner apache_user
    group root_group
    mode '0664'
    variables(apache_prefix: apache_prefix,
      dispatcher_log_level: dispatcher_log_level,
      dispatcher_conf_file: dispatcher_conf_file,
      dispatcher_cache: "#{dispatcher_root_dir}/cache"
    )
    notifies :restart, 'service[httpd24-httpd]'
  end

  template "#{apache_dir}/conf.modules.d/00-dispatcher.conf" do
    source '00-dispatcher.conf.erb'
    owner apache_user
    group root_group
    mode '0664'
    notifies :restart, 'service[httpd24-httpd]'
  end

  template "#{apache_dir}/#{dispatcher_conf_file}" do
    source 'dispatcher.any.erb'
    owner apache_user
    group root_group
    mode '0664'
    variables(farm_dir: farm_dir,
          farm_files: farm_files
    )
    notifies :restart, 'service[httpd24-httpd]'
  end

  aem_aas_farm farm_name do
    action :add
  end if farm_name

  service 'httpd24-httpd' do
    action [:enable, :start]
  end

end