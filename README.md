# Ipaddress::Geo

通过IP地址获取所在城市

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ipaddress-geo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ipaddress-geo

## Usage

    Ipaddress::Geo.resolve('10.0.0.1')
    => ["", "本地局域网"]

## IP location Databases

- https://db-ip.com/db/download/city
- http://lite.ip2location.com/

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xiaohui-zhangxh/ipaddress-geo.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
