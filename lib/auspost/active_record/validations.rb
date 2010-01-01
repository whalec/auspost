module Auspost
  module Postie

    module ActiveRecord
      module Validations
        
        def self.included(base)
          base.extend ClassMethods
        end
        
        
        def validate_location
          # @@valid_attributes.merge!(args.extract_options!)
          result = location?(map_attributes)
          if !result
            errors.add_to_base("Not a valid address")
          end
        end

        protected

        def map_attributes
          { 
            :state    => self.send(:state),
            :postcode => self.send(:postcode),
            :suburb   => self.send(:suburb)
          }
        end


        module ClassMethods
          

          # I'll add some validations here...
          def validate_location(*args)
            @@valid_attributes = {
              :state    => :state,
              :postcode => :postcode,
              :suburb   => :suburb
            }
            validate :validate_location
          end


        end
      end
    end #ActiveRecord

  end
end