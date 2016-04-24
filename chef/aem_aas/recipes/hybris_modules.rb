if node['roles'].include? 'aem-author'
  %w[ /opt/aem /opt/aem/author/crx-quickstart /opt/aem/author/crx-quickstart/install ].each do |path|
    directory path do
      owner 'crx'
      action :create
    end
  end

  remote_file '/opt/aem/author/crx-quickstart/install/cq-geometrixx-hybris-content-6.0.58.zip' do
    source node['aem']['module']['url']['geometrixx-hybris-content']
    mode 00644
    owner 'crx'
    checksum node['aem']['module']['md5']['geometrixx-hybris-content']
    action :create
  end

  remote_file '/opt/aem/author/crx-quickstart/install/cq-hybris-content-6.0.58.zip' do
    source node['aem']['module']['url']['hybris-content']
    mode 00644
    owner 'crx'
    checksum node['aem']['module']['md5']['hybris-content']
    action :create
  end
end

if node['roles'].include? 'aem-publish'

  %w[ /opt/aem /opt/aem/publish /opt/aem/publish/crx-quickstart /opt/aem/publish/crx-quickstart/install ].each do |path|
    directory path do
      owner 'crx'
    end
  end

  remote_file '/opt/aem/publish/crx-quickstart/install/cq-geometrixx-hybris-content-6.0.58.zip' do
    source node['aem']['module']['url']['geometrixx-hybris-content']
    mode 00644
    owner 'crx'
    checksum node['aem']['module']['md5']['geometrixx-hybris-content']
    action :create
  end

  remote_file '/opt/aem/publish/crx-quickstart/install/cq-hybris-content-6.0.58.zip' do
    source node['aem']['module']['url']['hybris-content']
    mode 00644
    owner 'crx'
    checksum node['aem']['module']['md5']['hybris-content']
    action :create
  end
end
