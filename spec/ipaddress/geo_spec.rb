RSpec.describe Ipaddress::Geo do
  it "has a version number" do
    expect(Ipaddress::Geo::VERSION).not_to be nil
  end

  describe "function ip_parts" do
    it "127.0.0.1 is valid ip format" do
      expect(Ipaddress::Geo.ip_parts('127.0.0.1')).to eq([127, 0, 0, 1])
    end

    it "100.a.b.1 is invalid ip format" do
      expect{Ipaddress::Geo.ip_parts('100.a.b.1')}.to raise_error Ipaddress::Geo::InvalidIp
    end

    it "100.10.1.300 is invalid ip format" do
      expect{Ipaddress::Geo.ip_parts('100.10.1.300')}.to raise_error Ipaddress::Geo::InvalidIp
    end
  end

  describe "function ip_to_u32" do
    it "127.0.0.1 to 32 bits is 2130706433" do
      expect(Ipaddress::Geo.ip_to_u32('127.0.0.1')).to eq(2130706433)
    end
    it "1.181.192.0 to 32 bits is 28688384" do
      expect(Ipaddress::Geo.ip_to_u32('1.181.192.0')).to eq(28688384)
    end
  end

  describe 'function resolve' do
    %w[127.0.0.0 127.255.255.255 10.0.0.0 10.255.255.255 172.16.0.0 172.16.255.255 192.168.0.0 192.168.255.255].each do |ip|
      it "#{ip} is 本地局域网" do
        expect(Ipaddress::Geo.resolve(ip)).to eq(['', '本地局域网'])
      end
    end

    {
      '125.71.251.6' => ['四川省', '成都市'],
      '17.56.152.18' => ['全球', '美国'],
      '123.125.71.38' => ['北京市', '北京市'],
    }.each_pair do |ip, addr|
      it "#{ip} is #{addr.uniq.join}" do
        expect(Ipaddress::Geo.resolve(ip)).to eq(addr)
      end
    end

  end
end
