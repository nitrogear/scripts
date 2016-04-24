actions :wait

attribute :validation_url, :kind_of => String, :required => true
attribute :max_attempts, :kind_of => Integer, :required => true
attribute :wait_between_attempts, :kind_of => Integer, :required => true
attribute :sleep_before, :kind_of => Integer, :required => true
attribute :aem_username, :kind_of => String, :required => false, :default => 'admin'
attribute :aem_password, :kind_of => String, :required => false, :default => 'admin'
attribute :match_string, :kind_of => String, :required => false
