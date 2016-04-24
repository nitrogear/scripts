actions :install
default_action :install

attribute :dispatcher_url, :kind_of => String, :default => node['aem']['dispatcher']['dispatcher_url']
attribute :dispatcher_checksum, :kind_of => String, :default => node['aem']['dispatcher']['checksum']
attribute :apache_prefix, :kind_of => String, :default => node['apache']['prefix']
attribute :apache_dir, :kind_of => String, :default => node['apache']['dir']
attribute :farm_dir, :kind_of => String, :default => node['aem']['dispatcher']['farm_dir']
attribute :farm_name, :kind_of => String, :default => node['aem']['dispatcher']['farm_name']
attribute :farm_files, :kind_of => Array, :default => node['aem']['dispatcher']['farm_files']
attribute :apache_user, :kind_of => String, :default => node['apache']['user']
attribute :root_group, :kind_of => String, :default => node['apache']['root_group']
attribute :dispatcher_log_level, :kind_of => Integer, :default => node['aem']['dispatcher']['log_level']
attribute :dispatcher_conf_file, :kind_of => String, :default => node['aem']['dispatcher']['conf_file']
attribute :dispatcher_root_dir, :kind_of => String, :default => node['aem']['dispatcher']['root_dir']
attribute :cache_root, :kind_of => String, :default => node['aem']['dispatcher']['cache_root']