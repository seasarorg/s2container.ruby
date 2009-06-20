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
require 'thread'
module Seasar
  module GAE
    class S2Application
      @@mutex = Mutex.new
      @@include_namespaces = %w[services daos models interceptors]
    
      def call(env)
        raise "invalid BASE_URL. [#{BASE_URL}]" if !BASE_URL.is_a?(String) || BASE_URL[0, 1] != '/'
        env['SCRIPT_NAME'] << '/index' if env['SCRIPT_NAME'] == BASE_URL
        env['SCRIPT_NAME'] << 'index' if env['SCRIPT_NAME'][-1, 1] == '/'
        key = env['SCRIPT_NAME'].sub(%r|^#{BASE_URL}/|, '').downcase
        raise "invalid script_name. [#{env['SCRIPT_NAME']}]" if key.delete('/-').match(/\W/)
        raise "invalid PAGE_MODULE_PATH. [#{PAGE_MODULE_PATH}]" if !PAGE_MODULE_PATH.is_a?(String) || PAGE_MODULE_PATH.size == 0

        page_path = File.join(PAGE_MODULE_PATH, key)
        page_file = page_path + '.rb'
        page_class_name = Seasar::GAE.get_class_name_with_path(page_path)
        s2logger.info(self.class.name) {"script name     : #{env['SCRIPT_NAME']}"}
        s2logger.info(self.class.name) {"namespace       : #{key}"}
        s2logger.info(self.class.name) {"page file path  : #{page_file}"}
        s2logger.info(self.class.name) {"page class name : #{page_class_name}"}

        s2app_instance = nil
        if Seasar::GAE.reload?
          @@mutex.synchronize {
            s2logger.warn(self.class.name){"sync : " + Time.now.to_s}
            sleep(15)
            s2app.init(:force => true)
            s2gae_require(page_file)
            s2app_instance = s2app.snapshot
          }
        else
          s2gae_require(page_file)
          s2app_instance = s2app
        end
    
        container = s2app.create([key] + @@include_namespaces)
        page = container.get(eval(page_class_name))
        return page.call(env)
      end
    end
  end
end
