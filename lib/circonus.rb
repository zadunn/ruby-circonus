#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2010 Opscode, Inc.
# License:: Apache License, Version 2.0
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

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'json'
require 'rest_client'

class Circonus
  VERSION = "0.0.2"

  attr_writer :auth_token, :app_name, :account
  attr_reader :rest

  def initialize(auth_token, app_name, account=nil)
    @auth_token = auth_token
    @app_name = app_name
    @account = account
    @format = "json"
    @rest = RestClient::Resource.new("http://circonus.com/api/#{@format}")
  end

  def options(args={})
    response = {
      :x_circonus_auth_token => @auth_token,
      :x_circonus_app_name => @app_name
    }
    
    response[:account] = @account if @account

    args.each do |key, value|
      response[key] = value
    end

    response
  end

  def deserialize(&block)
    value = block.call
    JSON.parse(value)
  end

  def call(values={}, opts={})
    # if no method is defined assume 'get'
    if values[:method].nil?
        values[:method] = 'get'
    end

    uri = values[:endpoint] + '?'
    
    # append the opt param's it to uri
    values.each do | param, value | 
        if param.to_s != "method" and param.to_s != "endpoint" then 
            uri << param.to_s + '=' + CGI::escape(value.to_s) + '&'
        end
    end 

   # make the request
    if values[:method] == 'get' then
        deserialize do
            @rest[uri].get(options(opts))
        end
    elsif values[:method] == 'post' then
        deserialize do
            @rest[uri].post(options(opts)) 
        end
    end 
  end
end
