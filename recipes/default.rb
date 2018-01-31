#
# Cookbook Name:: cakephp
# Recipe:: default
#
# Copyright (C) 2018 euonymus
#
# All rights reserved - Do Not Redistribute
#
link "/var/opt/host.php" do
  to node[:cakephp][:app_root] + "/config/host.php." + node.chef_environment
end


# delete a tmp directory
directory node[:cakephp][:cake_source] + "/tmp" do
  recursive true
  action :delete
end

# create a tmp directory
directory node[:cakephp][:cake_source] + '/tmp' do
  owner "www-data"
  group "www-data"
  mode "0775"
  action :create
end

# delete a logs directory
directory node[:cakephp][:cake_source] + "/logs" do
  recursive true
  action :delete
end

# create a logs directory
directory node[:cakephp][:cake_source] + '/logs' do
  owner "www-data"
  group "www-data"
  mode "0775"
  action :create
end


# Build app.php files
template node[:cakephp][:cake_source] + '/config/app.php' do
  source 'app.php.erb'
  owner "www-data"
  group "www-data"
  mode "755"
  variables({
     :app_name      => node[:cakephp][:app_name],
     :login         => node[:cakephp][:db_user],
     :database      => node[:cakephp][:db_name],
     :password      => node[:cakephp][:db_password],
  })
end

# Database Table creation
execute "create_tables" do
  command 'cd ' + node[:cakephp][:cake_source] + " && bin/cake migrations migrate"
end
