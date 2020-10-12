# dsv_sdk-ruby

![Tests](https://github.com/thycotic/dsv-sdk-ruby/workflows/Tests/badge.svg)
![Documentation](https://github.com/thycotic/dsv-sdk-ruby/workflows/Documentation/badge.svg)
![RubyGems](https://github.com/thycotic/dsv-sdk-ruby/workflows/RubyGems/badge.svg)
![GitHub](https://github.com/thycotic/dsv-sdk-ruby/workflows/GitHub/badge.svg)

# Installation

# Usage

## Initialize via env variables (best practice)

Vault will initialize easily if the following environment variables are defined:

* `DSV_CLIENT_ID`
* `DSV_CLIENT_SECRET`
* `DSV_TENANT`
* `DSV_TLD` - optional

```ruby
require 'dsv_sdk'
# initialize from ENV variables automatically
vault = DsvSdk::Vault.new

begin
    secret = DsvSdk::Secret.fetch(vault, "/test/secret")
rescue
    puts "Oh no, we had a problem accessing the vault"
end

puts "The password is: #{secret["data"]["password"]}"
```

## Initialize manually

If you want to manually initialze Vault you will need to pass a `Hash` to the Vault initialization with the following params:
"
* `client_id`
* `client_secret`
* `tenant`
* `tld` - optional (default's to `.com`)

```ruby
require 'vault'

configuration = {
  client_id: 'test_client_id',
  client_secret: 'test_client_secret'
  tenant: 'test_tenant'
}

v = Vault.new(configuration)

begin
    secret = DsvSdk::Secret.fetch(vault, "/test/secret")
rescue
    puts "Oh no, we had a problem accessing the vault"
end

puts "The password is: #{secret["data"]["password"]}"
```
