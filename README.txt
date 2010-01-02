auspost
    by Cameron Barrie
    http://wiki.github.com/whalec/auspost

== DESCRIPTION:

Give you the ability to search the Australia Post Web site with either Suburb or Postcode, and return an array of Locations.
Also add's validation methods to ActiveRecord Objects to allow you to validate that A Postcode + State + Suburb is correct

== FEATURES/PROBLEMS:

ActiveRecord Validations - validates_location


== SYNOPSIS:

  class Foo < ActiveRecord::Base
    include Auspost::Postie
    
    before_save :check_address
    
    def check_address
      location?(:postcode => 2038, :suburb => "Annandale", :state => "NSW")
    end
  end
  
  or 
  
  require 'auspost/active_record'
  class Foo < ActiveRecord::Base
  
    validate_location
  
  end

== REQUIREMENTS:

Nokogiri - For teh XML parsing.

== INSTALL:

sudo gem install auspost

== TODO:

Validations for Active Record should take more options, including mapping the suburb, postcode and state to other columns

validate_location :suburb => :home, :state => "state.name", :on => [:create, :change], :if => lambda { !home.blank? && !postcode.blank? }

== LICENSE:

(The MIT License)

Copyright (c) 2009

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
