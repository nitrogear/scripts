require 'json'

# Converts Boolean value to string
def to_sb(var)
  return 'false' if [FalseClass, NilClass].include?(var.class) 
  return 'true' if var.class == TrueClass
  return var
end   

action :add do
  page = new_resource.page
  page_attribute = new_resource.page_attribute
  page_attribute_value = new_resource.page_attribute_value
  aem_username = new_resource.aem_username
  aem_password = new_resource.aem_password
  port = new_resource.port
  
  test = `curl -u #{aem_username}:#{aem_password} http://localhost:#{port}/#{page} 2>/dev/null`
  val = ''
  begin
    test=JSON.parse(test)
  rescue
     Chef::Log.warn("!!! Page '#{page}' not found")
  else
    test.each do |t1,t2|
      if t1 == page_attribute
        val = to_sb(t2)
        if page_attribute_value == val
          Chef::Log.info("!!! Attribute '#{page_attribute}' on '#{page}' is already '#{page_attribute_value}'. Skip. ")
        else
          Chef::Log.info("!!! Changing attribute '#{page_attribute}' on '#{page}' from '#{val}' to '#{page_attribute_value}'.")
          res = `curl -w "%{http_code}" -u #{aem_username}:#{aem_password} -XPOST -F ./#{page_attribute}="#{page_attribute_value}" http://localhost:#{port}/#{page} 2>/dev/null`.split('>').last
          if res == '200'
            Chef::Log.info("!!! Attribute was set succesfuly.")
          else
            Chef::Log.warn("!!! Attribute was not set. HTTP code: #{res}.")
          end
        end
      end
    end
  end
end
