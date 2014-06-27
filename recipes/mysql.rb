#
# Cookbook Name:: pdns
# Recipe:: mysql
#

package "pdns-backend-mysql" do
  package_name value_for_platform(
    "arch" => { "default" => "pdns" },
    ["debian","ubuntu"] => { "default" => "pdns-backend-mysql" },
    ["redhat","centos","fedora"] => { "default" => "pdns-backend-mysql" },
    "default" => "pdns-backend-mysql"
  )
end

directory "/usr/share/pdns" do
  mode 0755
  action :create
end

template "/usr/share/pdns/init_schema.sql" do
  source "init_schema.sql.erb"
  mode 0640
  owner node["pdns"]["user"]
  group node["pdns"]["group"]
  action :create
end

mysql_connection_info = {
  :host     => "localhost",
  :username => "root",
  :password => node["mysql"]["server_root_password"],
}

execute "pdns-mysql-import" do
  command "mysql -u root -p#{node['mysql']['server_root_password']} #{node['pdns']['mysql']['database']} < /usr/share/pdns/init_schema.sql"
  action :nothing
end

mysql_database node["pdns"]["mysql"]["database"] do
  connection mysql_connection_info
  action :nothing
  action :create
  notifies :run, "execute[pdns-mysql-import]"
end

mysql_database_user node["pdns"]["mysql"]["read_user"] do
  connection mysql_connection_info
  password node["pdns"]["mysql"]["read_user_pass"]
  database_name node["pdns"]["mysql"]["database"]
  host "localhost"
  privileges [:select]
  action :grant
end

mysql_database_user node["pdns"]["mysql"]["write_user"] do
  connection mysql_connection_info
  password node["pdns"]["mysql"]["write_user_pass"]
  database_name node["pdns"]["mysql"]["database"]
  host "localhost"
  privileges [:select, :insert, :update, :delete, :create, :drop, :index, "lock tables", :alter ]
  action :grant
end
