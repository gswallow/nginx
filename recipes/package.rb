#
# Cookbook Name:: nginx
# Recipe:: package
# Author:: AJ Christensen <aj@junglist.gen.nz>
#
# Copyright 2008-2013, Opscode, Inc.
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

include_recipe 'nginx::ohai_plugin'

if platform_family?('rhel')
  if node['nginx']['repo_source'] == 'epel'
    include_recipe 'yum::epel'
  elsif node['nginx']['repo_source'] == 'nginx'
    include_recipe 'nginx::repo'
  elsif node['nginx']['repo_source'].nil?
    log "node['nginx']['repo_source'] was not set, no additional yum repositories will be installed." do
      level :debug
    end
  else
    raise ArgumentError, "Unknown value '#{node['nginx']['repo_source']}' was passed to the nginx cookbook."
  end
elsif platform_family?('debian')
  if node['nginx']['repo_source'] == 'nginx'
    include_recipe 'nginx::repo'
  end
end

package node['nginx']['package_name'] do
  notifies :reload, 'ohai[reload_nginx]', :immediately
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action   :enable
end

include_recipe 'nginx::commons'
