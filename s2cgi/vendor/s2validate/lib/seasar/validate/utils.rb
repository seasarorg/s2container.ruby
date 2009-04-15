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
    module Utils
      Validators = {}

      module_function

      #
      # - args
      #   1. Symbol <em>type</em>
      # - return
      #   - Proc
      #
      def get_validator(type)
        return Validators[type] if Validators.key?(type)
        method_name = type.to_s << '?'
        return self.method(method_name)
      end


      #
      # - args
      #   1. Integer <em>a</em>
      #   2. Integer <em>b</em>
      #   3. Boolean <em>include</em>
      # - return
      #   - Boolean
      #
      def gt(a, b, include)
        include = true if include.nil?
        if include
          return a <= b
        else
          return a < b
        end
      end

      #
      # - args
      #   1. Hash <em>options</em>
      # - return
      #   - Boolean
      #
      def required(options)
        default = true
        return default unless options.is_a?(Hash)
        return default unless options.key?(:required)
        return options[:required]
      end

      #
      # - args
      #   1. Object <em>value</em>
      #   2. Hash <em>options</em>
      # - return
      #   - Boolean
      #
      def int?(value, options = nil)
        return true if value.nil? and not required(options) 

        return false unless value.is_a?(Integer)
        return true unless options.is_a?(Hash)

        if options.key?(:min)
          return false unless gt(options[:min], value, options[:include])
        end

        if options.key?(:max)
          return false unless gt(value, options[:max], options[:include])
        end

        return true
      end

      #
      # - args
      #   1. Object <em>value</em>
      #   2. Hash <em>options</em>
      # - return
      #   - Boolean
      #
      def numeric?(value, options = nil)
        return true if value.nil? and not required(options) 
        return false unless value.is_a?(String)
        return false unless value.to_i.to_s == value
        return int?(value.to_i, options)
      end

      #
      # - args
      #   1. Object <em>value</em>
      #   2. Hash <em>options</em>
      # - return
      #   - Boolean
      #
      def string?(value, options = nil)
        return true if value.nil? and not required(options) 
        return false unless value.is_a?(String)
        return true unless options.is_a?(Hash)
        if options.key?(:min)
          return false unless gt(options[:min], value.split("").size, options[:include])
        end

        if options.key?(:max)
          return false unless gt(value.split("").size, options[:max], options[:include])
        end

        return true
      end

      #
      # - args
      #   1. Object <em>value</em>
      #   2. Hash <em>options</em>
      # - return
      #   - Boolean
      #
      def array?(value, options = nil)
        return true if value.nil? and not required(options) 
        return false unless value.is_a?(Array)
        return int?(value.size, options)
      end

      #
      # - args
      #   1. Object <em>value</em>
      #   2. Hash <em>option</em>
      # - return
      #   - Boolean
      #
      def member?(value, option)
        if option.is_a?(Array)
          options = {:items => option}
        else
          options = option
        end 
        return true if value.nil? and not required(options) 
        return options[:items].member?(value)
      end
      alias in? member?

      #
      # - args
      #   1. Object <em>value</em>
      #   2. Hash <em>option</em>
      # - return
      #   - Boolean
      #
      def regexp?(value, option = nil)
        if option.is_a?(Regexp)
          options = {:regexp => option}
        else
          options = option
        end 
        return true if value.nil? and not required(options) 
        return false unless value.is_a?(String)
        raise TypeError.new("option :regexp is not Regexp.") unless options[:regexp].is_a?(Regexp)
        return options[:regexp].match(value)
      end

      #
      # - args
      #   1. Object <em>value</em>
      #   2. Hash <em>option</em>
      # - return
      #   - Boolean
      #
      def alpha?(value, option = nil)
        if option.is_a?(Symbol)
          options = {:case => option}
        else
          options = option
        end 

        return true if value.nil? and not required(options) 
        return false unless value.is_a?(String)
        return value.match(/^[a-zA-Z]+$/) unless options.is_a?(Hash)

        case 
        when options[:case] == :down
          return value.match(/^[a-z]+$/)
        when options[:case] == :up || options[:case] == :upper
          return value.match(/^[A-Z]+$/)
        else
          raise ArgumentError.new("options must be :down or :up.")
        end
      end

    end
  end
end
