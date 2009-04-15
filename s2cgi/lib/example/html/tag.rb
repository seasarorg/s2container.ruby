# -*- coding: utf-8 -*-
# サンプル
module Example
  module Html
    module Tag
      module_function

      def input(options)
        out ='<input'

        error_msg = options[:msg]
        options.delete(:msg)

        status = options[:status]
        options.delete(:status)
        status = true if status.nil?

        options.each {|key, val|
          out << ' ' << h(key.to_s) << '="' << h(val.to_s) << '"'
        }
        out << '/>'
        if status == false
          out << ' <span class="err_msg">' << h(error_msg.to_s) << '</span>'
        end
        return out
      end

      def select(options)
        out ='<select'

        data = options[:data]
        options.delete(:data)

        error_msg = options[:msg]
        options.delete(:msg)

        status = options[:status]
        options.delete(:status)
        status = true if status.nil?

        options.each {|key, val|
          out << ' ' << h(key.to_s) << '="' << h(val.to_s) << '"'
        }
        out << ' >'

        if data.is_a?(Hash)
          data.each {|key, val|
            out << '<option name="' << h(key.to_s) << '">' << h(val.to_s) << '</option>'
          }
        elsif data.is_a?(Array)
          data.each_index {|i|
            out << '<option name="' << h(i.to_s) << '">' << h(data[i].to_s) << '</option>'
          }
        else
          raise TypeError.new('must be Hash or Array.')
        end

        out << '</select>'
        if status == false
          out << ' <span class="err_msg">' << h(error_msg.to_s) << '</span>'
        end
        return out
      end
    end
  end
end
