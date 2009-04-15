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
$KCODE = 'UTF-8'
#Encoding.default_external = 'utf-8'

require 'test/unit'
require File.dirname(__FILE__) + '/../../../config/rack.rb'

#ROOT_DIR    = File.expand_path(File.dirname(__FILE__) + '/../')
#S2CGI_DIR = File.join(File.dirname(ROOT_DIR), 's2cgi')
#$LOAD_PATH.unshift(File.join(ROOT_DIR, 'lib'))
#$LOAD_PATH.unshift(File.join(S2CGI_DIR, 'lib'))
#require 'seasar/rack'

Test::Unit::AutoRunner.run(true, File::expand_path(File::dirname(__FILE__)))

