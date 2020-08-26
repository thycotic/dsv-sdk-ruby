Gem::Specification.new do |s|
  s.name        = 'dsv_sdk'
  s.version     = '0.0.5-dev'
  s.date        = '2020-04-08'
  s.summary     = "dsv_sdk"
  s.description = "The Thycotic DevOps Secrets Vault SDK for Ruby"
  s.authors     = ["John Poulin"]
  s.email       = 'john.m.poulin@gmail.com'
  s.files       = [
    "lib/dsv_sdk.rb",
    "lib/dsv_sdk/client.rb",
    "lib/dsv_sdk/secret.rb",
    "lib/dsv_sdk/role.rb"
  ]
  s.homepage    =
    'https://github.com/thycotic/dsv-sdk-ruby'
  s.license       = 'Apache-2.0'


  s.add_dependency 'faraday'
  s.add_dependency 'logger'
  s.add_dependency 'json'

  s.add_development_dependency 'rspec', '~> 3.7'
  s.metadata = { "github_repo" => "ssh://github.com/thycotic/dsv-sdk-ruby" }
end
