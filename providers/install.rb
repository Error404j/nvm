#
# Cookbook Name:: nvm
# Provider:: nvm_install
#
# Copyright 2013, HipSnip Limited
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

action :create do
	from_source_message = new_resource.from_source ? ' from source' : ''
	from_source_arg = new_resource.from_source ? '-s' : ''
  nvm_user =  node['nvm']['user'] ||= 'root' #new_resource.user ||= 'root'
  nvm_group = node['nvm']['group'] ||= 'root' #new_resource.group ||= 'root'
	script "Installing node.js #{new_resource.version}#{from_source_message}, as as #{nvm_user}:#{nvm_group}" do
    interpreter 'bash'
    flags '-l'
    user nvm_user
    group nvm_group
    environment Hash[ 'HOME' => node['nvm']['home'], 'NVM_DIR' => "#{node['nvm']['home']}.nvm", 'USER' => nvm_user ]
		code <<-EOH
      echo $HOME - $NVM_DIR - `whoami` > /tmp/chef-vars.out
      echo `env` > /tmp/chef-env.out
      source /etc/profile.d/nvm.sh
			nvm install #{from_source_arg} #{new_resource.version}
		EOH
	end
	# break FC021: Resource condition in provider may not behave as expected
	# silly thing because new_resource.version is dynamic not fixed
	nvm_alias_default new_resource.version do
    user nvm_user
    group nvm_group
		action :create
		only_if { new_resource.alias_as_default }
	end
	new_resource.updated_by_last_action(true)
end
