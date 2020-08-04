# Hibp-client

[![Build Status](https://travis-ci.com/Warshavski/hibp-client.svg?branch=master)](https://travis-ci.com/Warshavski/hibp-client)

A simple Ruby client for interacting with [Have I Been Pwned](https://haveibeenpwned.com/) REST API.

This gem based on [API v3](https://haveibeenpwned.com/API/v3)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hibp-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hibp-client

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

#### Breach model

```ruby
Hibp::Models::Breach
```

A "breach" is an instance of a system having been compromised by an attacker and the data disclosed.   
For example, Adobe was a breach, Gawker was a breach etc.

A "breach" is an incident where data is inadvertently exposed in a vulnerable system, usually due to insufficient access controls or security weaknesses in the software.

- `name [String]` - A name representing the breach which is unique across all other breaches. 
                    This value never changes and may be used to name dependent assets (such as images) but should not be shown directly to end users(see the "title" attribute instead).

- `title [String]` - A descriptive title for the breach suitable for displaying to end users.
                     It's unique across all breaches but individual values may change in the future
                     (i.e. if another breach occurs against an organisation already in the system).
                     If a stable value is required to reference the breach, refer to the "Name" attribute instead.

- `domain [String]` - The domain of the primary website the breach occurred on.
                      This may be used for identifying other assets external systems may have for the site. 

- `breach_data [Date]` - The date (with no time) the breach originally occurred on in ISO 8601 format.
                         This is not always accurate — frequently breaches are discovered and reported long after the original incident.
                         Use this attribute as a guide only. 

- `added_date [DateTime]` - The date and time (precision to the minute) the breach was added to the system in ISO 8601 format. 

- `modified_date [DateTime]` - The date and time (precision to the minute) the breach was modified in ISO 8601 format.
                               This will only differ from the AddedDate attribute if other attributes
                               represented here are changed or data in the breach itself is changed
                               (i.e. additional data is identified and loaded).
                               It is always either equal to or greater then the AddedDate attribute, never less than.   

- `pwn_count [Integer]` - The total number of accounts loaded into the system.
                This is usually less than the total number reported by the media due to
                duplication or other data integrity issues in the source data.

- `description [String]` - Contains an overview of the breach represented in HTML markup.
                           The description may include markup such as emphasis and strong tags as well as hyperlinks. 

- `data_classes [Array<String>]` - This attribute describes the nature of the data compromised in the breach and
                                   contains an alphabetically ordered string array of impacted data classes.

- `is_verified [Boolean]` - Indicates that the breach is considered unverified.
                            An unverified breach may not have been hacked from the indicated website.
                            An unverified breach is still loaded into HIBP when there's
                            sufficient confidence that a significant portion of the data is legitimate.
                            (<b>alias</b> `verified?`)

- `is_fabricated [Boolean]` - Indicates that the breach is considered fabricated.
                              A fabricated breach is unlikely to have been hacked from the
                              indicated website and usually contains a large amount of manufactured data.
                              However, it still contains legitimate email addresses and asserts that
                              the account owners were compromised in the alleged breach.
                              (<b>alias</b> `fabricated?`)

- `is_sensitive [Boolean]` - Indicates if the breach is considered sensitive.
                             The public API will not return any accounts for a breach flagged as sensitive.
                             (<b>alias</b> `sensitive?`)

- `is_retired [Boolean]` - Indicates if the breach has been retired.
                           This data has been permanently removed and will not be returned by the API.
                           (<b>alias</b> `retired?`)

- `is_spam_list [Boolean]` - Indicates if the breach is considered a spam list.
                             This flag has no impact on any other attributes but
                             it means that the data has not come as a result of a security compromise.
                             (<b>alias</b> `spam_list?`) 

- `logo_path [String]` - A URI that specifies where a logo for the breached service can be found.
                         Logos are always in PNG format.

#### Getting all breached sites in the system

```ruby
client = Hibp::Client.new
 
# Return the details of each breach in the system.
#
# => Array<Hibp::Models::Breach> 
# 
client.breaches.fetch

# Return the details of each breach associated with a specific domain.
# 
# => Array<Hibp::Models::Breach> 
#
client.breaches.where(domain: 'adobe.com').fetch
```

#### Getting a single breached site

```ruby
client = Hibp::Client.new

# Return the details of a single breach, by breach name.
#
# => Hibp::Models::Breach
# 
client.breach('000webhost').fetch
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
# => Array<Hibp::Models::Breach>
# 
client.account_breaches('example@email.com').fetch

# Get all breaches for an account across a specific domain. 
#
# => Array<Hibp::Models::Breach> 
# 
client.account_breaches('example@email.com').where(domain: 'adobe.com').fetch

# Get all breaches info for an account with detailed information. 
#
# => Array<Hibp::Models::Breach> 
# 
client.account_breaches('example@email.com').where(truncate: false).fetch

# Returns breaches that have been flagged as "unverified"
#
# => Array<Hibp::Models::Breach> 
#
client.account_breaches('example@email.com').where(unverified: true).fetch
```

### Pastes

#### Paste model

A "paste" is information that has been "pasted" to a publicly facing
website designed to share content such as Pastebin.

These services are favoured by hackers due to the ease of anonymously
sharing information and they're frequently the first place a breach appears.

<b>NOTE</b> : In the future, these attributes may expand without the API being versioned.

```ruby
Hibp::Models::Paste
```

- `source [String]` - The paste service the record was retrieved from.
                      Current values are:
    - Pastebin
    - Pastie
    - Slexy
    - Ghostbin
    - QuickLeak
    - JustPaste
    - AdHocUrl
    - PermanentOptOut
    - OptOut
   
- `id [String]` - The ID of the paste as it was given at the source service.
                  Combined with the "Source" attribute, this can be used to resolve the URL of the paste. 

- `title [String]` - The title of the paste as observed on the source site.
                    This may be null. 

- `date [String]` -  The date and time (precision to the second) that the paste was posted.
                     This is taken directly from the paste site when this information is
                     available but may be null if no date is published.

- `email_count [Integer]` - The number of emails that were found when processing the paste.
                            Emails are extracted by using the regular expression:
                            \b+(?!^.{256})[a-zA-Z0-9\.\-_\+]+@[a-zA-Z0-9\.\-_]+\.[a-zA-Z]+\b

#### Getting all pastes for an account

```ruby
# API Key is required
client = Hibp::Client.new('api-key')

# Return any pastes that contain the given email address
#
# => Array<Hibp::Models::Paste>
# 
client.pastes('example@email.com').fetch
```

### Passwords

#### Password model

Represents password by the suffix of and a count of how many times it appears in the data set

```ruby
Hibp::Models::Password
```

- `suffix [String]` - Password suffix(password hash without first five symbols)

- `occurrences [Integer]` - Count of how many times suffix appears in the data set

#### Getting passwords suffixes by range

```ruby
client = Hibp::Client.new

# Get all suffixes of every hash beginning with the specified prefix, and a count of how many times it appears in the data set.
#
# => Array<Hibp::Models::Password>
# 
client.passwords('password').fetch

```

You can optionally pass in a second boolean parameter to the `passwords` command, to enable response padding. This will add a random number of fake password hashes to the response, preventing anyone analysing the encrypted response from guessing the password. The fake data is removed prior to returning the array of password models so there is no additional filtering you need to do.
```ruby
client = Hibp::Client.new
client.passwords('password', true).fetch
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

Bug reports and pull requests are welcome on GitHub at https://github.com/warshavski/hibp-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Hibp project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/hibp/blob/master/CODE_OF_CONDUCT.md).
