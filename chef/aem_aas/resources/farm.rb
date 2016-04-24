actions :add, :remove
default_action :add

attribute :farm_name, :kind_of => String, :default => node['aem']['dispatcher']['farm_name']
attribute :farm_dir, :kind_of => String, :default => node['aem']['dispatcher']['farm_dir']
attribute :client_headers, :kind_of => Array, :default => nil
attribute :virtual_hosts, :kind_of => Array, :default => nil
attribute :renders, :kind_of => Array, :default => nil
attribute :render_files, :kind_of => Array, :default => nil
attribute :filter_rules, :kind_of => Hash, :default => nil
attribute :cache_root, :kind_of => String, :default => nil
attribute :cache_rules, :kind_of => Hash, :default => nil
attribute :invalidation_rules, :kind_of => Hash, :default => nil
attribute :allowed_clients, :kind_of => Hash, :default => nil
attribute :statistics, :kind_of => Array, :default => nil
attribute :cache_opts, :kind_of => Array, :default => nil
attribute :session_mgmt, :kind_of => Hash, :default => nil
attribute :enable_session_mgmt, :kind_of => [ TrueClass, FalseClass ], :default => false
attribute :dynamic_cluster, :kind_of => [ TrueClass, FalseClass ], :default => node['aem']['dispatcher']['dynamic_cluster']
attribute :cluster_name, :kind_of => String, :default => nil
attribute :cluster_role, :kind_of => String, :default => nil
attribute :cluster_type, :kind_of => String, :default => nil
attribute :render_timeout, :kind_of => Integer, :default => 0
attribute :apache_user, :kind_of => String, :default => node['apache']['user']
attribute :root_group, :kind_of => String, :default => node['apache']['root_group']