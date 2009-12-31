require 'rubygems'
require 'spec'
gem 'sqlite3-ruby'
require 'sqlite3'
require 'active_record'
require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib auspost]))

ActiveRecord::Base.establish_connection(
   :adapter => "sqlite3",
   :database  => ":memory:"
 )
 ActiveRecord::Base.connection.create_table(:postal_workers) do |t|
   t.string :address
   t.string :postcode
   t.string :suburb
   t.string :state
 end


class PostalWorker < ActiveRecord::Base
  include Auspost::Postie::ActiveRecord::Validations
end


Spec::Runner.configure do |config|
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

