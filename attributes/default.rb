default[:cakephp][:app_name]     = 'lampapp'

default[:cakephp][:www_root]     = "/var/www"
default[:cakephp][:app_root]     = "#{node[:cakephp][:www_root]}/#{node[:cakephp][:app_name]}"

default[:cakephp][:cake_source]  = "/vagrant/src/#{node[:cakephp][:app_name]}"

default[:cakephp][:shell_base]  = '/usr/local/bin'

# The path to the data_bag_key on the virtualbox server
default[:cakephp][:secretpath] = "/vagrant/src/secrets/data_bag_key"

# look for secret in file pointed to with cakephp attribute :secretpath
data_bag_secret = Chef::EncryptedDataBagItem.load_secret("#{node[:cakephp][:secretpath]}")

# Set security info from data_bag
security_creds = Chef::EncryptedDataBagItem.load("passwords", "security", data_bag_secret)
if data_bag_secret && security_passwords = security_creds[node.chef_environment]
  default[:cakephp][:salt] = security_passwords['salt']
end

# Set MySQL info from data_bag
mysqlinfo_creds = Chef::EncryptedDataBagItem.load("envs", "mysql", data_bag_secret)
if data_bag_secret && mysql_envs = mysqlinfo_creds[node.chef_environment]
  default[:cakephp][:db_name]      = mysql_envs['db_name']
  default[:cakephp][:db_user]      = mysql_envs['db_user']
  default[:cakephp][:testdb_name]  = mysql_envs['testdb_name']
  default[:cakephp][:testdb_user]  = mysql_envs['testdb_user']
end
# Set MySQL passwords from data_bag
mysql_creds = Chef::EncryptedDataBagItem.load("passwords", "mysql", data_bag_secret)
if data_bag_secret && mysql_passwords = mysql_creds[node.chef_environment]
  default[:cakephp][:db_password_root] = mysql_passwords['root']
  default[:cakephp][:db_password] = mysql_passwords['app']
end
