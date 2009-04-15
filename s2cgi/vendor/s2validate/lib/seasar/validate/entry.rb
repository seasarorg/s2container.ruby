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

module Seasar
  module Validate
    class Entry

      #
      # - args
      #   1. Symbol <em>name</em>
      #   2. Symbol <em>type</em>
      #   3. Object <em>value</em>
      #   4. Hash <em>options</em>
      def initialize(name, type, value, options = nil)
        @name = name
        @type = type
        @validator = Seasar::Validate::Utils.get_validator(@type)
        @value = value
        @options = options
        @result = nil
      end
      attr_accessor :name, :type, :options, :value, :result
      
      #
      # - args
      #   - none
      # - return
      #   - Boolean
      #
      def valid?
        self.validate if @result.nil?
        return @result == true
      end

      #
      # - args
      #   - none
      # - return
      #   - Boolean
      #
      def error?
        self.validate if @result.nil?
        return @result == false
      end

      #
      # - args
      #   - none
      # - return
      #   - Boolean
      #
      def validate
        @result = @validator.call(@value, @options)
        return @result
      end

      #
      # - args
      #   1. Symbol <em>key</em>
      # - return
      #   - Object
      #
      def [](key)
        return @options[key]
      end
    end
  end
end
