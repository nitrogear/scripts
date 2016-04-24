actions :install, :delete
default_action :install

attribute :aem_user, kind_of: String, default: 'aem'
attribute :license_url, kind_of: String, default: node['aem']['license_url']
attribute :aem_package, kind_of: String, default: node['aem']['aem_package']
attribute :aem_package_sha256, kind_of: String, default: node['aem']['aem_package_sha256']
attribute :version, kind_of: String, default: node['aem']['version']
attribute :aem_url, kind_of: String, default: node['aem']['aem_url']
attribute :prefix, kind_of: String, default: '/opt/aem'
attribute :service_name, kind_of: String, default: nil
attribute :port, kind_of: String, default: nil
attribute :java_opts, kind_of: String, default: nil