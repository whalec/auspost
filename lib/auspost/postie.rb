require 'cgi'
module Auspost

  module Postie
    
    class Cache
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

    def location?(attrs = {})
      map_attributes!(attrs)
      url       = "http://www1.auspost.com.au/postcodes/index.asp?Locality=&sub=1&State=&Postcode=#{CGI::escape(@postcode)}&submit1=Search"
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
      raise ArgumentError, "You must supply a suburb" if attrs[:suburb].nil?
      raise ArgumentError, "You must supply a state" if attrs[:state].nil?
      raise ArgumentError, "You must supply a postcode" if attrs[:postcode].nil?
      attrs.values.map!{|value| value.to_s.downcase! }
      @postcode = attrs[:postcode].to_s
    end
    
    def stringify_results
      @table.map{|row| row.content.downcase }.join(" ")
    end
    
    def check_results?(attrs)
      @content.include?(attrs[:suburb]) && @content.include?(attrs[:state]) && @content.include?(@postcode)
    end

  end

end
