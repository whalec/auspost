require File.join(File.dirname(__FILE__), 'active_record/validations')
ActiveRecord::Base.class_eval do 
  include Auspost::Postie::ActiveRecord::Validations
  include Auspost::Postie  
end