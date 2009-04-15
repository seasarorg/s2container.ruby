require 'example/some-service'

module Example
  class TC_SomeService < Test::Unit::TestCase
    def setup
      @container = s2app.create
    end

    def teardown
    end
    
    def test_add
      assert_equal(5, @container.get(:some_service).add(2, 3))
    end
  end
end
