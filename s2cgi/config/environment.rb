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

$KCODE      = 'UTF-8'
Encoding.default_external = 'utf-8'
BASE_URL    = '/s2cgi'
ROOT_DIR    = File.dirname(File.dirname(__FILE__))
CONFIG_DIR  = "#{ROOT_DIR}/config"
LIB_DIR     = "#{ROOT_DIR}/lib"
PUBLIC_DIR  = "#{ROOT_DIR}/public"
TEST_DIR    = "#{ROOT_DIR}/test"
TPL_DIR     = "#{ROOT_DIR}/tpl"
VENDOR_DIR  = "#{ROOT_DIR}/vendor"
VAR_DIR     = "#{ROOT_DIR}/var"
LOG_DIR     = "#{VAR_DIR}/logs"
SESSION_DIR = "#{VAR_DIR}/session"
TPL_EXT     = 'html'

$LOAD_PATH.unshift(LIB_DIR)

require 's2container'
Seasar::Log::S2Logger.logdev = "#{LOG_DIR}/s2.log"
s2logger.level = Logger::WARN



