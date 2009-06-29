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
require 'seasar/rack'

alias s2component_dist s2component
def s2component(option = {}, &procedure)
  if self.class == Class && self.ancestors.member?(Seasar::GAE::Page)
    option[:namespace] = Seasar::GAE.get_path_with_class_name(self.name).sub(%r|^#{PAGE_MODULE_PATH}/|, '')
  end
  s2component_dist(option, &procedure)
end
alias s2comp s2component

def s2gae_require(*args)
  if Seasar::GAE.reload?
    args.each {|arg| load arg}
  else
    args.each {|arg| require arg}
  end
end

module Seasar
  module GAE
    @@reload = false;
    autoload :Page, 'seasar/gae/page'
    autoload :RackReloadMiddleware, 'seasar/gae/rack-reload-middleware'
    autoload :S2Application, 'seasar/gae/s2application'

    module_function

    def reload?
      return @@reload
    end

    def reload=(val)
      @@reload = val
    end

    def get_path_with_class_name(class_name)
      class_name[0, 1] = class_name[0, 1].downcase unless class_name[0, 1] == ':'
      path = class_name.gsub(%r|::([A-Z])|) {"/#{$1.downcase}"}
      path = path.gsub(/([A-Z])/) {"-#{$1.downcase}"}
      return path
    end

    def get_class_name_with_path(path)
      class_name = path.gsub(/-([a-z])/) {$1.upcase}
      class_name = class_name.gsub(%r|/([a-z])|) {"::#{$1.upcase}"}
      class_name[0, 1] = class_name[0, 1].upcase unless class_name[0, 1] == ':'
      return class_name
    end
  end
end