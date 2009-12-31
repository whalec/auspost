gem 'sqlite3-ruby'
require 'sqlite3'
require 'active_record'

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


class PostalWorker < ActiveRecord::Base;end
