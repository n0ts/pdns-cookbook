#
# Cookbook Name:: pdns
# Recipe:: package
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

#
# PowerDNS 3rd party package is only support RHEL
#
download_url = 'https://www.monshouwer.eu/download/3rd_party'
wget_cmd = 'wget -e robots=off --cut-dirs=3 --reject="index.html*" --no-parent --recursive --relative --level=1 --no-directories'
case node['platform_version'].to_i.to_s
when '5'
  el = 'el5'
when '6'
  el = 'el6'
end

file "#{node['pdns']['package']['download_dir']}/fetch.sh" do
  content <<-EOH
cd #{node['pdns']['package']['download_dir']}
#{wget_cmd} #{download_url}/pdns-server/#{el}/#{node['kernel']['machine']}/
#{wget_cmd} #{download_url}/boost/#{el}/#{node['kernel']['machine']}/
#{wget_cmd} #{download_url}/luna/#{el}/#{node['kernel']['machine']}/
#{wget_cmd} #{download_url}/pdns-recursor/#{el}/#{node['kernel']['machine']}/
EOH
  mode 0755
  action :create
end
