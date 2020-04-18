Gem::Specification.new do |s|
  s.name        = 'dsv-sdk'
  s.version     = '0.0.4'
  s.date        = '2020-04-08'
  s.summary     = "dsv-sdk"
  s.description = "The Thycotic DevOps Secrets Vault SDK for Ruby"
  s.authors     = ["John Poulin", "Adam Migus"]
  s.email       = ['john.m.poulin@gmail.com', 'adam@migus.org']
  s.files       = [
    "lib/vault.rb",
    "lib/vault/vault.rb",
    "lib/vault/client.rb",
    "lib/vault/secret.rb",
    "lib/vault/role.rb"
  ]
  s.homepage    =
    'https://rubygems.org/gems/hola'
  s.license       = 'Apache-2.0'

  s.add_development_dependency 'rspec', '~> 3.7'
  s.metadata = { "github_repo" => "ssh://github.com/thycotic/dsv-sdk-ruby" }
end
