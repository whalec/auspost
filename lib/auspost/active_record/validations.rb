module Auspost
  module Postie

    module ActiveRecord
      module Validations
        
        @@valid_attributes = {
          :state    => :state,
          :postcode => :postcode,
          :suburb   => :suburb
        }
        
        def self.included(base)
          base.extend ClassMethods
        end
        
        
        def validate_location(*args)
          result = location?(map_attributes)
          if !result
            errors.add(:state, "Does not match postcode")
          end
        end
        
        def valid_attributes
          @@valid_attributes
        end

        protected

        def map_attributes
          { 
            :state    => self.send(@@valid_attributes[:state]),
            :postcode => self.send(@@valid_attributes[:postcode]),
            :suburb   => self.send(@@valid_attributes[:suburb])
          }
        end


        module ClassMethods
          
          include Validations

          # I'll add some validations here...
          def validate_location(*args)
            valid_attributes.update(args.extract_options!)
            validate :validate_location, valid_attributes
          end


        end
      end
    end #ActiveRecord

  end
end