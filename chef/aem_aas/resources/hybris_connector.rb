actions :add
default_action :add

attribute :awesomeString, :kind_of => String, :required => true
attribute :aem_username, :kind_of => String, :required => false, :default => 'admin'
attribute :aem_password, :kind_of => String, :required => false, :default => 'admin'
attribute :hybris_role, :kind_of => String, :required => false, :default => 'hybris'
attribute :hybris_username, :kind_of => String, :required => false, :default => 'admin'
attribute :hybris_password, :kind_of => String, :required => false, :default => 'unmodified'
attribute :port, :kind_of => String, :required => true
