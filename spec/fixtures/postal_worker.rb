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


ActiveRecord::Base.connection.create_table(:mashed_postal_workers) do |t|
  t.string :addr
  t.string :zipcode
  t.string :city
  t.integer :state_id
end

ActiveRecord::Base.connection.create_table(:states) do |t|
  t.string :name
end


class PostalWorker < ActiveRecord::Base;end

class MashedPostalWorker < ActiveRecord::Base
  
  belongs_to :state
  
end

class State < ActiveRecord::Base
  has_many :mashed_postal_workers
end