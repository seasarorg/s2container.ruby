#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#--
# +----------------------------------------------------------------------+
# | Copyright 2005-2008 the Seasar Foundation and the Others.            |
# +----------------------------------------------------------------------+
# | Licensed under the Apache License, Version 2.0 (the "License");      |
# | you may not use this file except in compliance with the License.     |
# | You may obtain a copy of the License at                              |
# |                                                                      |
# |     http://www.apache.org/licenses/LICENSE-2.0                       |
# |                                                                      |
# | Unless required by applicable law or agreed to in writing, software  |
# | distributed under the License is distributed on an "AS IS" BASIS,    |
# | WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,                        |
# | either express or implied. See the License for the specific language |
# | governing permissions and limitations under the License.             |
# +----------------------------------------------------------------------+
#++
require File.dirname(__FILE__) + '/../../config/cgi.rb'
require 'example/html/tag'

class Page < Seasar::CGI::Page
  include Example::Html::Tag
  s2comp

  validate(:post) {
    param :username, :string, :min => 4, :max => 8
    param :password, :string, :min => 4, :max => 8
    valid?
  }

  def validate_post
    param :username, :string, :min => 4, :max => 8
    param :password, :string, :min => 4, :max => 8
    return valid?
  end

  def post
    session = start_session
    session[:username] = @cgi['username']
    s2logger.info(script_name){"login : #{session[:username]}"}
    redirect('admin.cgi')
  end
end

Seasar::CGI.run

