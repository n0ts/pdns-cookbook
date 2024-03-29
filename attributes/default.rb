#
# Cookbook Name:: pdns
# Attributes:: default
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

default["pdns"]["user"] = "pdns"
default["pdns"]["group"] = "pdns"

case node['platform_family']
when "rhel","fedora"
  default["pdns"]["server"]["config_dir"] = "/etc/pdns"
  default["pdns"]["recursor"]["config_dir"] = "/etc/pdns-recursor"
  default["pdns"]["user"] = "pdns-recursor"
  default["pdns"]["group"] = "pdns-recursor"
else
  default["pdns"]["server"]["config_dir"] = "/etc/powerdns"
  default["pdns"]["recursor"]["config_dir"] = "/etc/powerdns"
end

default["pdns"]["server_backend"] = "sqlite3"

default["pdns"]["recursor"]["allow_from"] = [
  "127.0.0.0/8",
  "10.0.0.0/8",
  "192.168.0.0/16",
  "172.16.0.0/12",
  "::1/128",
  "e80::/10"
]

default["pdns"]["recursor"]["auth_zones"] = []
default["pdns"]["recursor"]["forward_zones"] = []
default["pdns"]["recursor"]["forward_zones_recurse"] = []
default["pdns"]["recursor"]["local_address"] = [ipaddress]
default["pdns"]["recursor"]["local_port"] = "53"

default["pdns"]["mysql"] = {
  "host"     => "localhost",
  "port"     => "",
  "database" => "pdns",
  "read_user"       => "pdns_read",
  "read_user_pass"  => "pdns",
  "write_user"      => "pdns_write",
  "write_user_pass" => "pdns",
  "socket"   => "",
}
