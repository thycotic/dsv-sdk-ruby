module Dsv
  class Client
      CLIENTS_RESOURCE = "clients".freeze
    
      # Fetch desired client information from the specified Vault
      #
      # @param vault [Vault] The initialized Vault
      # @param id [String] The ID of the client
      #
      # @return client [Hash]
      def self.fetch(vault, id)
        @vault = vault
        client = @vault.accessResource("GET", CLIENTS_RESOURCE, id, nil)
      end
    
      # Mark the client as ready to be removed
      #
      # @param vault [Vault] The initialized Vault
      # @param id [String] The ID of the client
      def self.delete(vault, id)
        vault.accessResource("DELETE", CLIENTS_RESOURCE, id, nil, nil)
      end

      # Create the client for the desired Vault
      #
      # @param vault [Vault] The initialized Vault
      # @param role_Name [String] Name of the role to create
      def self.create(vault, role_name)
        client_data = {
          role: role_name
        }
        vault.accessResource("POST", CLIENTS_RESOURCE, "/", client_data)
      end
    end
  end