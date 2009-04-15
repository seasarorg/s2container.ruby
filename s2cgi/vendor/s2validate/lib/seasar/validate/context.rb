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
    class Context

      #
      # - args
      #   - none
      def initialize
        self.init
      end

      #
      # - args
      #   -none
      # - return
      #   - nil
      #
      def init; @entries = [] end

      #
      # - args
      #   1. Symbol <em>name</em>
      #   2. Symbol <em>type</em>
      #   3. Object <em>value</em>
      #   4. Hash <em>options</em>
      # - return
      #   - Array status, headers, body
      #
      def register(name, type, value, options = nil)
        @entries << Seasar::Validate::Entry.new(name, type, value, options)
      end

      #
      # - args
      #   1. Seasar::Validate::Entry <em>entry</em>
      # - return
      #   - nil
      #
      def << (entry)
        @entries << entry
      end

      #
      # - args
      #   1. Symbol <em>name</em>
      #   2. Symbol <em>type</em>
      # - return
      #   - Array
      #
      def find(name = nil, type = nil)
        if name.nil?
          result = @entries
        else
          result = @entries.select {|entry| entry.name == name}
        end

        if type.nil?
          return result
        else
          return @entries.select {|entry| entry.type == type}
        end
      end

      #
      # - args
      #   1. Symbol <em>name</em>
      #   2. Symbol <em>type</em>
      # - return
      #   - Array
      #
      def validate(name = nil, type = nil)
        entries = self.find(name, type)
        entries.each {|entry| entry.validate if entry.result.nil? }
        return entries
      end

      #
      # - args
      #   1. Symbol <em>name</em>
      #   2. Symbol <em>type</em>
      # - return
      #   - Boolean
      #
      def valid?(name = nil, type = nil)
        return valids(name, type).size == find(name, type).size
      end

      #
      # - args
      #   1. Symbol <em>name</em>
      #   2. Symbol <em>type</em>
      # - return
      #   - Boolean
      #
      def error?(name = nil, type = nil)
        return 0 < errors(name, type).size
      end

      #
      # - args
      #   1. Symbol <em>name</em>
      #   2. Symbol <em>type</em>
      # - return
      #   - Array
      #
      def valids(name = nil, type = nil)
        entries = self.find(name, type)
        return entries.select {|entry| entry.valid? }
      end

      #
      # - args
      #   1. Symbol <em>name</em>
      #   2. Symbol <em>type</em>
      # - return
      #   - Array
      #
      def errors(name = nil, type = nil)
        entries = self.find(name, type)
        return entries.select {|entry| entry.error? }
      end
    end
  end
end
