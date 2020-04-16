require './lib/vault.rb'
class Vault::Role
    ROLES_RESOURCE = "roles".freeze
  
    # Return the specified role
    #
    # @param vault [Vault] The initialized Vault
    # @param name [String] Name of the role
    #
    # @return role [Hash]
    def self.fetch(vault, name)
      @vault = vault
  
      role = @vault.accessResource("GET", ROLES_RESOURCE, name, nil)
    end
  end