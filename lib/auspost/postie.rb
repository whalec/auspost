require 'cgi'
module Auspost

  module Postie
    
    class Cache
      def initialize
        if Object.const_defined? :Rails
          Rails.cache
        else
          @cache = MemCache.new 'localhost:11211', :namespace => 'auspost'
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

    def check_location_exists(attrs = {})
      map_attributes!(attrs)
      url       = "http://www1.auspost.com.au/postcodes/index.asp?Locality=&sub=1&State=&Postcode=#{CGI::escape(attrs[:postcode])}&submit1=Search"
      @content  = get(url)
      check_results?(attrs)
    end
    

    private
    
    def cache
      @cache || set_cache 
    end
    
    def set_cache
      @cache = Cache.new
    end
    
    def get(url)
      @content = check_cache || get_and_cache(url)
    end
    
    def check_cache
      cache.read(@postcode)
    end
    
    def get_and_cache(url)
      object  = open(url)
      @table  = Nokogiri::HTML(object).xpath('//table[3]/tr/td[2]/table/tr/td/font/table/tr[2]/td/table/tr')
      content = stringify_results
      cache.write(@postcode, content)
      content
    end
    
    def map_attributes!(attrs)
      attrs.values.map{|value| value.downcase! }
      attrs[:suburb] = "" if attrs[:suburb].nil?
      attrs[:state]  = "" if attrs[:state].nil?
      attrs[:postcode] = "" if attrs[:postcode].nil?
      @postcode = attrs[:postcode]
    end
    
    def stringify_results
      @table.map{|row| row.content.downcase }.join(" ")
    end
    
    def check_results?(attrs)
      if @content.include?(attrs[:suburb]) && @content.include?(attrs[:state]) && @content.include?(attrs[:postcode])
        true
      else
        false
      end
    end

  end

end
