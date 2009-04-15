module Seasar
  module Validate
    class TC_Context < Test::Unit::TestCase
      def setup
      end

      def teardown
      end

      def test_find
        @validate = Context.new
        entry1 = Validate::Entry.new(:year, :int, 1, :min => 2000)
        entry2 = Validate::Entry.new(:name, :string, 2)
        entry3 = Validate::Entry.new(:age, :int, 3)
        @validate << entry1
        @validate << entry2
        @validate << entry3
        assert_equal([entry1, entry2, entry3], @validate.find)

        assert_equal([entry1], @validate.find(:year))
        assert_equal([entry2], @validate.find(nil, :string))
        assert_equal([entry1, entry3], @validate.find(nil, :int))
      end

      def test_entry_validate
        entry1 = Entry.new(:year, :int, 2000)
        assert(entry1.validate)
        entry1 = Entry.new(:year, :int, "2000")
        assert(!entry1.validate)
      end

      def test_entry_validators
        Seasar::Validate::Utils::Validators[:valid_a] = proc {|value, options| return value == 'a'}
        entry1 = Entry.new(:year, :valid_a, 'a')
        assert(entry1.validate)
        entry1 = Entry.new(:year, :valid_a, 'b')
        assert(!entry1.validate)
      end

      def test_valid?
        params = {'year' => 2000, 'name' => 'huga', 'age' => 20}
        @validate = Context.new
        @validate.register(:year, :int, 2000, :min => 2000)
        @validate.register(:name, :string, 'huga')
        @validate.register(:age, :int, 20, :msg => 'over age')
        assert(@validate.valid?)
        assert(!@validate.error?)
        assert(@validate.valids.size == 3)
        assert(@validate.errors.size == 0)
      end

      def test_error?
        params = {'year' => 2000, 'name' => 'huga', 'age' => '20'}
        @validate = Context.new
        @validate.register(:year, :int, 2000, :min => 2000)
        @validate.register(:name, :string, 'huga')
        @validate.register(:age, :int, '20', :msg => 'over age')
        assert(@validate.error?)
        assert(!@validate.valid?)

        assert(@validate.errors.size == 1)
        assert(@validate.valids.size == 2)
        assert_equal((@validate.errors(:age))[0].type, :int)
        assert_equal((@validate.errors(:age))[0][:msg], 'over age')
      end
    end
  end
end
