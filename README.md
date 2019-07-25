# Hibp

[![Build Status](https://travis-ci.com/Warshavski/hibp.svg?branch=master)](https://travis-ci.com/Warshavski/hibp)

A simple Ruby client for interacting with [Have I Been Pwned](https://haveibeenpwned.com/) REST API.

This gem based on [API v3](https://haveibeenpwned.com/API/v3)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hibp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hibp

## Usage

This gem incapsulates all API requests and data transformation. 

The top-level object needed for gem functionality is the `Hibp::Client` object. 
A client may require your API key in case if you want to use services such as:

 - Getting all breaches for an account.
 - Getting all pastes for an account.

The API of the SDK is manipulated using `Hibp::Query` queries return different entities, but the mapping is not one to one.

Some of the methods support adding filters to them. The filters are created using the `Hibp::Query` class. After instantiating the class, you can invoke methods in the form of comparison(field, value).


### Authorization

An authorization is required for all APIs that enable searching HIBP by email address, namely retrieving all breaches for an account and retrieving all pastes for an account.
 
An HIBP subscription key is required to make an authorized call and can be obtained on the API [key page](https://haveibeenpwned.com/API/Key). 
The key is then passed as a client constructor argument:

```ruby
client = Hibp::Client.new('api-key')
```

### Breaches

#### Getting all breached sites in the system

```ruby
client = Hibp::Client.new
 
# Return the details of each breach in the system.
#
# => Array<Hibp::Breach> 
# 
client.breaches.fetch

# Return the details of each breach associated with a specific domain.
# 
# => Array<Hibp::Breach> 
client.breaches.where(domain: 'adobe.com').fetch
```

#### Getting a single breached site

```ruby
client = Hibp::Client.new

# Return the details of a single breach, by breach name.
#
# => Hibp::Breach
# 
client.breach('000webhost') 
```

#### Getting all data classes in the system

```ruby
client = Hibp::Client.new

# Return the different types of data classes that are associated with a record in a breach. E.G, Email addresses and passwords
#
# => Array<String>
#
client.data_classes.fetch
```

#### Getting all breaches for an account

NOTE : 
 - By default, only the name of the breach is returned rather than the complete breach data.
 - By default, both verified and unverified breaches are returned when performing a search.

```ruby
# API Key is required
client = Hibp::Client.new('api-key')

# Get all breaches for an account across all domains. 
#
# => Array<Hibp::Breach>
# 
client.account_breaches('example@email.com').fetch

# Get all breaches for an account across a specific domain. 
#
# => Array<Hibp::Breach> 
# 
client.account_breaches('example@email.com').where(domain: 'adobe.com').fetch

# Get all breaches info for an account with detailed information. 
#
# => Array<Hibp::Breach> 
# 
client.account_breaches('example@email.com').where(truncate: false).fetch

# Returns breaches that have been flagged as "unverified"
#
# => Array<Hibp::Breach> 
#
client.account_breaches('example@email.com').where(unverified: true).fetch
```

### Pastes

#### Getting all pastes for an account

```ruby
# API Key is required
client = Hibp::Client.new('api-key')

# Return any pastes that contain the given email address
#
# => Array<Hibp::Paste>
# 
client.pastes('example@email.com').fetch
```

### Passwords

#### Getting passwords suffixes by range

```ruby
client = Hibp::Client.new

# Get all suffixes of every hash beginning with the specified prefix, and a count of how many times it appears in the data set.
#
# => Array<Hibp::Password>
# 
client.passwords('password').fetch

```

### Errors

This gem will throw custom exception if an API error occurred.

All service errors are wrapped in `Hibp::ServiceError`

| Code |                   Description                                                                   |
|------|-------------------------------------------------------------------------------------------------|
| 400  | Bad request — The account does not comply with an acceptable format (i.e. it's an empty string) |
| 401  | Unauthorized - Access denied due to missing hibp-api-key.                                       |
| 403  | Forbidden — No user agent has been specified in the request                                     |
| 404  | Not found — The account could not be found and has therefore not been pwned                     |
| 429  | Too many requests — The rate limit has been exceeded                                            |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/warshavski/hibp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Hibp project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/hibp/blob/master/CODE_OF_CONDUCT.md).
