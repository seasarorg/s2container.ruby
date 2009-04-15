module Seasar
  module CGI
    class TC_Page < Test::Unit::TestCase
      def setup
      end

      def teardown
      end

      def test_normalize_tpl
        page = Seasar::CGI::Page.new

        assert_equal('index', page.normalize_tpl('index.html/'))
        assert_equal('index', page.normalize_tpl('..i.n.d.e.x../'))
        assert_equal('index', page.normalize_tpl('\index'))
        assert_equal('index', page.normalize_tpl('//index'))
        assert_equal('index', page.normalize_tpl('/\index'))
        assert_equal('index', page.normalize_tpl('index//'))
        assert_equal('index', page.normalize_tpl('index\/'))

        assert_equal('admin/index', page.normalize_tpl('admin/index.html/'))
        assert_equal('admin/index', page.normalize_tpl('..admin/i.n.d.e.x../'))
        assert_equal('admin/index', page.normalize_tpl('\admin/index'))
        assert_equal('admin/index', page.normalize_tpl('//admin/index'))
        assert_equal('admin/index', page.normalize_tpl('/\admin/index'))
        assert_equal('admin/index', page.normalize_tpl('admin/index//'))
        assert_equal('admin/index', page.normalize_tpl('admin/index\/'))
      end

      def test_render
        default_tpl_dir = Seasar::CGI::Page.tpl_dir
        Seasar::CGI::Page.tpl_dir = File.join(File.dirname(__FILE__), 'tpl')

        page = Seasar::CGI::Page.new
        page.instance_variable_set(:@tpl_stack, [])
        page.instance_variable_set(:@contents, '')
        page.render('a/main')
        assert_equal('a main a', page.instance_variable_get(:@contents))

        page = Seasar::CGI::Page.new
        page.instance_variable_set(:@tpl_stack, [])
        page.instance_variable_set(:@contents, '')
        page.render('b/main')
        assert_equal('B main B', page.instance_variable_get(:@contents))

        page = Seasar::CGI::Page.new
        page.instance_variable_set(:@tpl_stack, [])
        page.instance_variable_set(:@contents, '')
        page.render('c/main')
        assert_equal('c C contents C c', page.instance_variable_get(:@contents))

        page = Seasar::CGI::Page.new
        page.instance_variable_set(:@tpl_stack, [])
        page.instance_variable_set(:@contents, '')
        page.instance_variable_set(:@d, 'abc')
        page.render('d/main')
        assert_equal('d abc  D contents abc xyz D d', page.instance_variable_get(:@contents))

        Seasar::CGI::Page.tpl_dir = default_tpl_dir 
      end

    end
  end
end
