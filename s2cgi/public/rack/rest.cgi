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
require File.dirname(__FILE__) + '/../../config/rack.rb'

class Page < Seasar::Rack::CGI::Page
  s2comp

  def validate
    s2logger.info(script_name){"validate called."}
  end

  def validate_get
    s2logger.info(script_name){"validte_get called."}
  end

  def get
    s2logger.info(script_name){"get called."}
  end

  def validate_post
    s2logger.info(script_name){"validte_post called."}
  end

  def post
    s2logger.info(script_name){"post called."}
  end

  def validate_put
    s2logger.info(script_name){"validte_put called."}
  end

  def put
    s2logger.info(script_name){"put called."}
  end

  def validate_delete
    s2logger.info(script_name){"validte_delete called."}
  end

  def delete
    s2logger.info(script_name){"delete called."}
  end

  def validate_options
    s2logger.info(script_name){"validte_options called."}
  end

  def options
    s2logger.info(script_name){"options called."}
  end
end

Seasar::Rack::CGI.run
