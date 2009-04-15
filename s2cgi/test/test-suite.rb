require 'test/unit'
require File::dirname(__FILE__) + '/../config/cgi.rb'
#require File::dirname(__FILE__) + '/../config/rack.rb'
#require File::dirname(__FILE__) + '/../config/database.rb'

Test::Unit::AutoRunner.run(true, File::expand_path(File::dirname(__FILE__)))

