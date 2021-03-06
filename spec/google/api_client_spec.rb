# Copyright 2010 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'

require 'signet/oauth_1/client'
require 'httpadapter/adapters/net_http'
require 'httpadapter/adapters/mock'

require 'google/api_client'
require 'google/api_client/version'
require 'google/api_client/parsers/json_parser'

shared_examples_for 'configurable user agent' do
  it 'should allow the user agent to be modified' do
    @client.user_agent = 'Custom User Agent/1.2.3'
    @client.user_agent.should == 'Custom User Agent/1.2.3'
  end

  it 'should allow the user agent to be set to nil' do
    @client.user_agent = nil
    @client.user_agent.should == nil
  end

  it 'should not allow the user agent to be used with bogus values' do
    (lambda do
      @client.user_agent = 42
      @client.transmit(
        ['GET', 'http://www.google.com/', [], []]
      )
    end).should raise_error(TypeError)
  end

  it 'should transmit a User-Agent header when sending requests' do
    @client.user_agent = 'Custom User Agent/1.2.3'
    request = ['GET', 'http://www.google.com/', [], []]
    adapter = HTTPAdapter::MockAdapter.create do |request_ary, connection|
      method, uri, headers, body = request_ary
      headers.should be_any { |k, v| k.downcase == 'user-agent' }
      headers.each do |k, v|
        v.should == @client.user_agent if k.downcase == 'user-agent'
      end
      [200, [], ['']]
    end
    @client.transmit(request, adapter)
  end
end

describe Google::APIClient do
  before do
    @client = Google::APIClient.new
  end

  it 'should make its version number available' do
    Google::APIClient::VERSION::STRING.should be_instance_of(String)
  end

  it 'should default to OAuth 2' do
    Signet::OAuth2::Client.should === @client.authorization
  end

  it_should_behave_like 'configurable user agent'

  describe 'configured for OAuth 1' do
    before do
      @client.authorization = :oauth_1
    end

    it 'should use the default OAuth1 client configuration' do
      @client.authorization.temporary_credential_uri.to_s.should ==
        'https://www.google.com/accounts/OAuthGetRequestToken'
      @client.authorization.authorization_uri.to_s.should include(
        'https://www.google.com/accounts/OAuthAuthorizeToken'
      )
      @client.authorization.token_credential_uri.to_s.should ==
        'https://www.google.com/accounts/OAuthGetAccessToken'
      @client.authorization.client_credential_key.should == 'anonymous'
      @client.authorization.client_credential_secret.should == 'anonymous'
    end

    it_should_behave_like 'configurable user agent'
  end

  describe 'configured for OAuth 2' do
    before do
      @client.authorization = :oauth_2
    end

    # TODO
    it_should_behave_like 'configurable user agent'
  end
end
