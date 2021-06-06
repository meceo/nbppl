# Nbppl

Simple API client to fetch exchange rate to PLN for selected currency and date from http://api.nbp.pl

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nbppl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nbppl

## Usage

```ruby
# fetch mid rate for specific currency and date
Nbppl::Client.new.fetch_mid_rate("EUR", Date.parse("2021-06-01"))

# fetch mid rate from closest date in the past
Nbppl::Client.new.closest_mid_rate("USD", Date.parse("2021-06-06"))
=> [3.6931, #<Date: 2021-06-04 ((2459370j,0s,0n),+0s,2299161j)>]

# use caching by making multiple calls with same class instance
client = Nbppl::Client.new
client.fetch_mid_rate(a)
client.fetch_mid_rate(a) # no unnecessary api call
# or by using Nbppl::Client.current
Nbppl::Client.current.fetch_mid_rate(a)
Nbppl::Client.current.fetch_mid_rate(a) # no unnecessary api call
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/meceo/nbppl.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
