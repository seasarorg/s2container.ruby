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
require File.dirname(__FILE__) + '/../../config/database.rb'
require 'example/prefecture-dao'

class Prefecture < Seasar::Rack::CGI::Page
  s2comp
  attr_accessor :prefecture_dao
  attr_accessor :database_handle
  def get
    session = get_session
    if session.nil?
      session = start_session
    end
    @paginate_dto = session[:paginate_dto]

    if @paginate_dto.nil?
      @paginate_dto = session[:paginate_dto] = Seasar::DBI::Paginate.new
      session[:paginate_dto].total = @prefecture_dao.find_total_by_dto(session[:paginate_dto])[0]['total']
    end
    session[:paginate_dto].move(param(:act), param(:idx).to_i)
    @prefectures = @prefecture_dao.find_by_dto(@paginate_dto)
  end
end

Seasar::Rack::CGI.run
