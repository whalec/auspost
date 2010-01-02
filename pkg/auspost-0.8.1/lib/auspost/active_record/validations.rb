module Auspost
  module Postie

    module ActiveRecord
      module Validations
        
        @@valid_attributes = {
          :state    => {:accessor => :state, :message => ["%s is not found in the %s postcode", :state, :postcode] },
          :postcode => {:accessor => :postcode, :message => ["%s cannot be found", :postcode] },
          :suburb   => {:accessor => :suburb, :message => ["%s is not found in the %s postcode", :suburb, :postcode] },
        }
        
        def self.included(base)
          base.extend ClassMethods
        end
        
        
        def validate_location
          result = location?(map_attributes)
          if result && !result.status
            result.errors.each do |error|
              message = @@valid_attributes[error.accessor][:message]
              if message.is_a?(String)
                errors.add(error.accessor, message)
              else
                mappings = message[1..-1].map do |x|
                  if x.to_s.include?(".")
                    methods = x.split(".")
                    send(methods.first).send(methods.last).to_s.upcase
                  else
                    send(x).to_s.upcase
                  end
                end
                errors.add(error.accessor, message.first % mappings)
              end
            end
          end
        end
        
        def valid_attributes
          @@valid_attributes
        end

        protected

        def map_attributes
          { 
            :state    => get_column(:state),
            :postcode => get_column(:postcode),
            :suburb   => get_column(:suburb)
          }
        end
        
        def get_column(column)
          if @@valid_attributes[column][:accessor].nil?
            column
          elsif @@valid_attributes[column][:accessor].is_a?(String) && @@valid_attributes[column][:accessor].include?(".")
            association = @@valid_attributes[column][:accessor].split(".")
            self.send(association.first.to_sym).send(association.last.to_sym)
          else
            self.send(@@valid_attributes[column][:accessor]) || column
          end
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