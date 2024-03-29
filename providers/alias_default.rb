#
# Cookbook Name:: nvm
# Provider:: nvm_alias_default
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
	script "Alias default node.js version to #{new_resource.version}..." do
    interpreter 'bash'
    flags '-l'
    user user
    group group
    environment Hash[ 'HOME' => node['nvm']['home'] ]
		code <<-EOH
			#{node['nvm']['source']}
			nvm alias default #{new_resource.version}
		EOH
	end
	new_resource.updated_by_last_action(true)
end
