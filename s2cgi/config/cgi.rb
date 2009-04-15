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
require File.join(File.dirname(__FILE__), 'environment.rb')

$LOAD_PATH.unshift(File.join(VENDOR_DIR, 's2cgi/lib'))
$LOAD_PATH.unshift(File.join(VENDOR_DIR, 's2validate/lib'))

require 'cgi'
require 'cgi/session'
require 'cgi/session/pstore'
require 'erb'
include ERB::Util

require 'seasar/cgi'
require 'seasar/validate'
require 'base-page'


Seasar::CGI::Session.options = {'tmpdir' => SESSION_DIR, 'database_manager' => CGI::Session::PStore}

Seasar::CGI::Page.fatal {|e, page|
  s2logger.fatal() {"#{e.message} #{e.backtrace}"}
  print "Location: #{BASE_URL}/fatal.html\n\n";
}

Seasar::CGI::Page.tpl_dir = TPL_DIR


