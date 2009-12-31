module Auspost
  module Postie

    module ActiveRecord
      module Validations
        
        def self.included(base)
          base.extend ClassMethods
        end
        
        module ClassMethods

          @@valid_attributes = {
            :state    => :st,
            :postcode => :postcode,
            :suburb   => :suburb
          }

          # I'll add some validations here...
          def validate_location(*args)
            @@valid_attributes.merge!(args.extract_options!)
          end
          
          
          private
          
          def set_attributes
            
          end


        end
      end
    end #ActiveRecord

  end
end