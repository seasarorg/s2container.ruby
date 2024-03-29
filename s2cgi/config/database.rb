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

require 'rubygems'
require 'dbi'
require 'seasar/dbi/dbi-interceptor'
require 'seasar/dbi/paginate'

dsn_info = s2comp(:class => DBI::DatabaseHandle, :namespace => "dbi", :autobinding => :none) {
  DBI.connect("dbi:SQLite3:#{VAR_DIR}/db/example.db")
}

dsn_info.destructor {|dbh|
  s2logger.info(File.basename(__FILE__)){"Database handle disconnected."}
  dbh.disconnect
}

