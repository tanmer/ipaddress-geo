module Ipaddress
  module Geo
    class IpRanges

      def initialize
        @array = []
      end

      def search(ip)
        ip_u32 = ip.is_a?(Numeric) ? ip : Ipaddress::Geo.ip_to_u32(ip)
        low = 0
        high = @array.count
        while low < high do
          mid = low + ((high - low) / 2)
          value_from, value_to, v_loc = v = @array[mid]
          if ip_u32 < value_from
            high = mid
            next
          elsif ip_u32 >= value_from && ip_u32 <= value_to
            return { index: mid, value: v }
          else
            low = mid + 1
            next
          end
        end
        return nil if low == @array.count
      end

      def push(from, to, loc)
        raise "from should be integer"  unless from.is_a?(Numeric)
        raise "to should be integer"    unless to.is_a?(Numeric)
        last = @array[-1]
        if last
          raise "from(#{from}) should be grater than last record #{last[1]}" if from <= last[1]
        end
        raise "from(#{from}) should be less than to(#{to})" if from > to
        @array << [from, to, loc]
      end

      def to_s
        "#{self.class.name}: #{@array.count} records"
      end

      def inspect
        to_s
      end
    end
  end
end
