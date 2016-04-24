actions :add
default_action :add

attribute :page, :kind_of => String, :required => true
attribute :page_attribute, :kind_of => String, :required => true
attribute :page_attribute_value, :kind_of => String, :required => true
attribute :aem_username, :kind_of => String, :required => false, :default => 'admin'
attribute :aem_password, :kind_of => String, :required => false, :default => 'admin'
attribute :port, :kind_of => String, :required => true
