require 'cgi'
module Auspost

  module Postie
    
    class Cache
      
      # Over ride these two class variables to change your memcache settings
      @@memcache_host = "localhost"
      @@memcache_port = "11211"
      
      def initialize
        if Object.const_defined? :Rails
          Rails.cache
        else
          @cache = MemCache.new "#{@@memcache_host}:#{@@memcache_port}", :namespace => 'auspost'
        end
      end
      
      def write(key, object)
        if @cache
          @cache.add(key, object) if @cache.servers.map{|s| s.alive?}.include?(true)
        else
          Rails.cache.write(key, object)
        end
      end
      
      def read(key)
        if @cache
          @cache.get(key) if @cache.servers.map{|s| s.alive?}.include?(true)
        else
          Rails.cache.read(key)
        end
      end
    end
    
    class Suburb
      def initialize(attrs)
        @suburb   = attrs[:suburb].downcase
        @postcode = attrs[:postcode].to_i
        @state    = attrs[:state].downcase
      end
      
      def suburb?(attrs)
        attrs[:suburb].downcase == @suburb
      end
      
      def state?(attrs)
        attrs[:state].downcase == @state
      end
      
      def postcode?(attrs)
        attrs[:postcode].to_i == @postcode
      end
      
      def eql?(attrs)
        suburb?(attrs) && postcode?(attrs) && state?(attrs)
      end
      
      def to_i(attrs)
        (suburb?(attrs) ? 1 : 0) + 
          (state?(attrs) ? 1 : 0) +
            (postcode?(attrs) ? 1 : 0)
      end
    end
    
    class Result
      
      attr_reader :status, :errors
      
      def initialize(status)
        @status = status
        @errors = [] if !@status
      end
      
    end
    
    class Error
      
      attr_reader :accessor, :message
      
      def initialize(accessor, message)
        @accessor = accessor
        @message  = message
      end
      
    end


    # This is the method that returns whether a location is correct or not.
    # It requires three attributes
    # :postcode, :suburb & :state such as
    # location?(:postcode => 2038, :suburb => "Annandale", :state => "NSW") #=> Result#status => true
    # location?(:postcode => 2010, :suburb => "Annandale", :state => "NSW") #=> Result#status => false 
    # Result#errors => Error#accessor => :suburb && Error#message => "Annandale does not match 2010 postcode"
    # The results of a request to a given postcode is cached in memcached if available or in
    # your Rails.cache store if you're in a Rails project.
    def location?(attrs = {})
      map_attributes!(attrs)
      url       = "http://www1.auspost.com.au/postcodes/index.asp?Locality=&sub=1&State=&Postcode=#{CGI::escape(@postcode)}&submit1=Search"
      @content  = get(url)
      check_results(attrs)
    end
    

    private

    def cache
      @cache ||= set_cache 
    end
    
    def set_cache
      @cache = Cache.new
    end
    
    def get(url)
      @results = check_cache || get_and_cache(url)
    end
    
    def check_cache
      cache.read(@postcode)
    end
    
    def get_and_cache(url)
      object    = open(url)
      @table    = Nokogiri::HTML(object).xpath('//table[3]/tr/td[2]/table/tr/td/font/table/tr[2]/td/table/tr')
      content   = map_results
      content.delete_if{|x| x.nil?}
      cache.write(@postcode, content)
      content
    end
    
    def map_attributes!(attrs)
      raise ArgumentError, "You must supply a suburb" if attrs[:suburb].nil?
      raise ArgumentError, "You must supply a state" if attrs[:state].nil?
      raise ArgumentError, "You must supply a postcode" if attrs[:postcode].nil?
      attrs.values.map!{|value| value.to_s.downcase! }
      @postcode = attrs[:postcode].to_s
    end
    
    def map_results
      @table.map do |row|
        content = row.content.strip if row.content.include?("LOCATION:")
        if content
          s = content.index("LOCATION: ")
          e = content.index(",")
          suburb = content[s..e-1].split(" ").last
          state  = content[e+2..e+4]
          final = Suburb.new(:suburb => suburb, :state => state, :postcode => @postcode)
        end
      end
    end
    
    def check_results(attrs)
      if @results.map{|suburb| suburb.eql?(attrs)}.include?(true)
        Result.new(true)
      else
        result = Result.new(false)
        error_count = @results.map{|r| r.to_i(attrs) } #.sort.reverse.first # Get the first one with the least number of errors
        main_error = @results[error_count.index(error_count.sort.first)]
        result.errors << Error.new(:suburb, "Does not match postcode") if !main_error.suburb?(attrs)
        result.errors << Error.new(:state, "Does not match postcode") if !main_error.state?(attrs)
        result
      end
    end

  end

end
