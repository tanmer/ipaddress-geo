require "ipaddress/geo/version"
module Ipaddress
  module Geo
    autoload :InvalidIp, 'ipaddress/geo/invalid_ip'
    autoload :IpRanges, 'ipaddress/geo/ip_ranges'

    # return [省, 市] or [全球, 国家]
    def self.resolve(ip)
      warm_up
      result = ip_ranges.search(ip)
      if result
        location_table[result[:value][2]]
      end
    end

    def self.ip_to_u32(ip)
      parts = ip_parts(ip)
      ip_value = 0
      parts.each_with_index do |part, i|
        ip_value += part.to_i << (4 - i - 1) * 8
      end
      ip_value
    end

    def self.ip_parts(ip)
      parts = []
      if ip =~ /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\z/
        parts = [$1, $2, $3, $4].map(&:to_i)
        parts = [] if parts.any?{ |x| x > 255 || x < 0 }
      end
      raise InvalidIp, "Invalid IPv4 format: #{ip}" if parts.empty?
      parts
    end

    def self.data_dir
      @data_dir ||= File.expand_path('../../../data', __FILE__)
    end

    def self.ip_ranges
      @ip_u32_ranges
    end

    def self.location_table
      @location_table
    end

    def self.warm_up
      return if @warmed_up
      print "warming up ... "
      start = Time.now

      load_ip_ranges
      load_location_table

      puts "estmated #{Time.now - start} seconds."
      @warmed_up = true
    end

    def self.load_ip_ranges
      @ip_u32_ranges = IpRanges.new
      ip_ranges_path = File.join(data_dir, 'ip_ranges.csv')
      File.readlines(ip_ranges_path).each do |line|
        line = line.strip
        next if line.empty?
        parts = line.split(',')
        @ip_u32_ranges.push ip_to_u32(parts[0]), ip_to_u32(parts[1]), parts[2].strip
      end
    end

    def self.load_location_table
      @location_table = {}
      locations_path = File.join(data_dir, 'locations.csv')
      File.readlines(locations_path).each do |line|
        line = line.strip
        next if line.empty?
        parts = line.split(',')
        @location_table[parts[2].strip] = [parts[0].strip, parts[1].strip]
      end
    end
  end
end
