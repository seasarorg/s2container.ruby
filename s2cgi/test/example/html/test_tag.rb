require 'example/html/tag'

module Example
  module Html
    class TC_Tag < Test::Unit::TestCase
      include Example::Html::Tag
      def setup
      end

      def teardown
      end

      def test_input
        expect = '<input type="text" value="2000" name="year"/>'
        ret = input :type => "text", :name => "year", :value => "2000", :msg => "input integer", :status => true
        assert_equal(expect, ret)

        expect = '<input type="text" value="2000" name="year"/>'
        ret = input :type => "text", :name => "year", :value => "2000", :msg => "input integer", :status => true
        assert_equal(expect, ret)

        expect = '<input type="text" value="2000" name="year"/> <span class="err_msg">abc</span>'
        ret = input :msg => "abc", :status => false, :type => "text", :name => "year", :value => "2000"
        assert_equal(expect, ret)
      end

      def test_select
        expect = '<select name="year" ><option name="aa">AA</option></select>'
        ret = select :name => "year", :data => {"aa" => "AA"}, :msg => "input integer", :status => true
        assert_equal(expect, ret)

        expect = '<select name="year" ><option name="0">AA</option></select>'
        ret = select :name => "year", :data => ["AA"], :msg => "input integer", :status => true
        assert_equal(expect, ret)

        expect = '<select name="year" ><option name="1">AA</option></select>'
        ret = select :name => "year", :data => ["AA"].inject({}) {|x, v| x[x.size+1] = v; x}, :msg => "input integer", :status => true
        assert_equal(expect, ret)

        expect = '<select name="year" ><option name="aa">AA</option></select> <span class="err_msg">abc</span>'
        ret = select :name => "year", :data => {"aa" => "AA"}, :msg => "abc", :status => false
        assert_equal(expect, ret)
      end
    end
  end
end
