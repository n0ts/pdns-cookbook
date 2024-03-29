#
# Cookbook Name:: pdns
# Recipe:: server
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "pdns::#{node['pdns']['server_backend']}"

package "pdns" do
  package_name value_for_platform(
    ["debian","ubuntu"] => { "default" => "pdns-server" },
    "default" => "pdns"
  )
end

service "pdns" do
  action [:enable, :start]
end

case node["platform"]
when "arch"
  user "pdns" do
    shell "/bin/false"
    home "/var/spool/powerdns"
    supports :manage_home => true
    system true
  end
end

template "#{node['pdns']['server']['config_dir']}/pdns.conf" do
  source "pdns.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[pdns]", :immediately
end

resolvconf "custom" do
  nameserver "127.0.0.1"
  search "chillibean.net chilli.internal"
  head       "# Don't touch this configuration file!"
  base       "# Will be added after nameserver, search, options config items"
  tail       "# This goes to the end of the file."

  # do not touch my interface configuration plz!
  clear_dns_from_interfaces false

  only_if { ["debian","ubuntu"].include? node['platform_family'] }
end
