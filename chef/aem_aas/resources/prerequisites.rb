actions :install, :delete
default_action :install

attribute :java_url, kind_of: String, default: node['aem']['java_url'] 
attribute :java_package, kind_of: String, default: node['aem']['java_package'] 
attribute :java_package_sha256, kind_of: String, default: node['aem']['java_package_sha256'] 