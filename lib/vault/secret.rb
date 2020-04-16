
# Utilized to fetch secrets from an initialzed +Vault+
class Vault::Secret
    SECRETS_RESOURCE = "secrets".freeze
  
    # Fetch secrets from the server
    #
    # @param vault [Server]
    # @param path [String] path to the secret
    #
    # @return [Hash] of the secret
    def self.fetch(vault, path)
        @vault = vault
  
        @secret = @vault.accessResource("GET", SECRETS_RESOURCE, path, nil)
    end
  end