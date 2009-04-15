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

class Page < Seasar::CGI::Page
  s2comp

  def validate_post
    @session = get_session
    return true if @session[:s2cgi_page_id] == param(:s2cgi_page_id)
    
    puts 'invalid access. <br>'
    puts "parameter id: #{param(:s2cgi_page_id)} <br>"
    puts "session id: #{@session[:s2cgi_page_id]} <br>"
    puts "current id: #{@s2cgi_page_id} <br>"
    return false
  end

  def get
    @session = start_session
  end

  def post
    puts 'success access. <br>'
    puts "parameter id: #{param(:s2cgi_page_id)} <br>"
    puts "session id: #{@session[:s2cgi_page_id]} <br>"
    puts "current id: #{@s2cgi_page_id} <br>"
  end

  def out
    tag = '<input type="hidden" name="s2cgi_page_id" value="' << @s2cgi_page_id << '"/></form>'
    @contents.sub!(%r|</form>|, tag)
    @session[:s2cgi_page_id] = @s2cgi_page_id
    super
  end
end

Seasar::CGI.run

