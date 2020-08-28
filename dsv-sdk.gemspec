Gem::Specification.new do |s|
  s.name        = 'dsv-sdk'
  s.version     = '0.0.6-dev'
  s.date        = '2020-04-08'
  s.summary     = "dsv_sdk"
  s.description = "The Thycotic DevOps Secrets Vault SDK for Ruby"
  s.authors     = ["John Poulin"]
  s.email       = 'john.m.poulin@gmail.com'
  s.files       = [
    "lib/dsv.rb",
    "lib/dsv/client.rb",
    "lib/dsv/secret.rb",
    "lib/dsv/role.rb"
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
