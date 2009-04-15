module Seasar
  module Validate
    class TC_Utils < Test::Unit::TestCase
      include Seasar::Validate::Utils
      def setup
      end

      def teardown
      end

      def test_int?
        assert(int?(100))
        assert(!int?('100'))

        assert(int?(100, :min => 100))
        assert(!int?(100, :min => 100 , :include => false))

        assert(int?(100, :max => 100))
        assert(!int?(100, :max => 100 , :include => false))

        assert(int?(100, :min => 99, :max => 101))
        assert(int?(100, :min => 100, :max => 100))

        assert(!int?(nil))
        assert(!int?(nil, :required => true))
        assert(int?(nil, :required => false))
      end

      def test_string?
        assert(!string?(nil))
        assert(!string?(nil, :required => true))
        assert(string?(nil, :required => false))

        assert(string?("abc"))
        assert(!string?(100))

        assert(string?("abc", :min => 3))
        assert(!string?("abc", :min => 3 , :include => false))

        assert(string?("abc", :max => 3))
        assert(!string?("abc", :max => 3 , :include => false))

        assert(string?("abc", :min => 2, :max => 4))
        assert(string?("abc", :min => 3, :max => 3))

        assert(string?("あああ", :min => 2, :max => 4))
        assert(string?("あああ", :min => 3, :max => 3))
      end

      def test_numeric?
        assert(!numeric?(nil))
        assert(!numeric?(nil, :required => true))
        assert(numeric?(nil, :required => false))

        assert(numeric?("100"))
        assert(!numeric?(100))
        assert(!numeric?("abc"))
        assert(!numeric?("あああ"))

        assert(numeric?("100", :min => 100))
        assert(!numeric?("100", :min => 100 , :include => false))

        assert(numeric?("100", :max => 100))
        assert(!numeric?("100", :max => 100 , :include => false))

        assert(numeric?("100", :min => 99, :max => 100))
        assert(numeric?("100", :min => 100, :max => 100))
      end

      def test_array?
        assert(!array?(nil))
        assert(!array?(nil, :required => true))
        assert(array?(nil, :required => false))

        assert(array?([100]))
        assert(!array?(100))

        assert(array?([100, 200, 300], :min => 3))
        assert(!array?([100, 200, 300], :min => 3, :include => false))

        assert(array?([100, 200, 300], :max => 3))
        assert(!array?([100, 200, 300], :max => 3 , :include => false))

        assert(array?([100, 200, 300], :min => 2, :max => 4, :include => false))
        assert(array?([100, 200, 300], :min => 3, :max => 3))
      end

      def test_member?
        assert(!member?(nil, ["a", "b"]))
        assert(!member?(nil, :items => ["a", "b"], :required => true))
        assert(member?(nil, :required => false))

        assert(member?("a", ["a", "b"]))
        assert(in?("b", ["a", "b"]))
        assert(!member?("c", ["a", "b"]))
      end

      def test_regexp?
        assert(!regexp?(nil, /^a/))
        assert(!regexp?(nil, :regexp => /^a/, :required => true))
        assert(regexp?(nil, :required => false))

        assert(regexp?("abc", /^a/))
        assert(!regexp?("abc", /z$/))
        assert(regexp?("abc", {:regexp => /^a/}))
        assert_raise(TypeError) {
          regexp?("abc", {:regex => /z$/})
        }
      end

      def test_alpha?
        assert(!alpha?(nil))
        assert(!alpha?(nil, :required => true))
        assert(alpha?(nil, :required => false))

        assert(alpha?("aA"))
        assert(!alpha?("a:A"))

        assert(alpha?("aa", :down))
        assert(alpha?("aa", :case => :down))
        assert(!alpha?("aA", :case => :down))
        assert(!alpha?("A", :case => :down))

        assert(alpha?("AA", :up))
        assert(alpha?("AA", :case => :up))
        assert(!alpha?("aA", :case => :upper))
        assert(!alpha?("a", :case => :upper))

        assert_raise(ArgumentError) {
          alpha?("a", :case => :xx)
        }
      end

      def test_get_validator
        assert_raise(NameError) {
          Seasar::Validate::Utils.get_validator(:xx)
        }
      end

    end
  end
end
