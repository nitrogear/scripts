actions :install,:uninstall
default_action :install

attribute :aem_username, :kind_of => String, :required => false, :default => 'admin'
attribute :aem_password, :kind_of => String, :required => false, :default => 'admin'
attribute :port, :kind_of => String, :required => true
attribute :group_name, :kind_of => String, :required => false, :default => nil
attribute :package_name, :kind_of => String, :required => false, :default => nil
attribute :base_packages, :kind_of => Array, :required => false, :default => []
attribute :current_version_packages, :kind_of => Array, :required => false, :default => []
