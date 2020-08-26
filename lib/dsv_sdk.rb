require 'json'
require 'faraday'
require 'logger'

##
# If we're in the +test+ environment just dump logs to Null
# Otherwise, use stdout
if ENV['test']
  $logger = Logger.new(IO::NULL)
else
  $logger = Logger.new(STDOUT)
end

##
# Invoked when the API returns an +API_AccessDenied+ error
class AccessDeniedException < StandardError; end;
class ResourceNotFoundException < StandardError; end;
class InvalidConfigurationException < StandardError; end;
class InvalidCredentialsException < StandardError; end;
class InvalidMethodTypeException < StandardError; end;
class UnrecognizedResourceException < StandardError; end;


module DsvSdk
  require_relative 'dsv_sdk/client'
  require_relative 'dsv_sdk/secret'
  require_relative 'dsv_sdk/role'

  class Vault
    DEFAULT_URL_TEMPLATE = "https://%s.secretsvaultcloud.%s/v1/%s%s"
    DEFAULT_TLD = "com"
  
    # Initialize a +Vault+ object with provided configuration.
    #
    # @param config [Hash]
    #   - client_id: ''
    #   - client_secret: ''
    #   - tld: 'com'
    #   - tenant: ''
    def initialize(config = nil)
  
      unless config.nil?
        @configuration = config.collect{|k,v| [k.to_s, v]}.to_h
      else
        @configuration = {}
  
        @configuration['client_id'] = ENV['DSV_CLIENT_ID']
        @configuration['client_secret'] = ENV['DSV_CLIENT_SECRET']
        @configuration['tenant'] = ENV['DSV_TENANT']
        @configuration['tld'] = ENV['DSV_TLD']
      end
  
      if @configuration['client_id'].nil? || @configuration['client_secret'].nil?
        $logger.error("Must provide client_id and client_secret")
        raise InvalidConfigurationException
      end
  
      $logger.debug("Vault is configured for client_id: #{@configuration['client_id']}")
    end
  
    # Helper method to access a resource via API
    #
    # @param method [String] HTTP Request Method
    # @param resource [String] The resource type to invoke
    # @param path [String] The API Path to request
    # @param input [String] Input to send via POST/PUT body
    #
    # @return [Hash] - return Hash of JSON contents
    #
    # - +AccessDeniedException+ is raised if the server responds with an +API_AccessDenied+ error
    # - +InvalidMethodTypeException+ is raised if a method other than +["GET", "POST", "PUT", "DELETE"]+ is provided
    # - +UnrecognizedResourceException+ is raised if a resource other than +["clients", "roles", "secrets"]+ is requested
    def accessResource(method, resource, path, input, parse_json=true)
      unless ["GET", "POST", "PUT", "DELETE"].include?(method.upcase)
        $logger.error "Invalid request method: #{method}"
        raise InvalidMethodTypeException
      end
  
      unless ["clients", "roles", "secrets"].include? resource
        message = "unrecognized resource"
        $logger.debug "#{message}, #{resource}"
  
        raise UnrecognizedResourceException
      end
  
      body = ""
  
      unless input.nil?
        body = input.to_json
      end
  
      accessToken = getAccessToken
  
      # Yikes, normally not a fan of metaprogramming
      # We first ensured that `method` is legit to prevent
      # arbitrary method invocation
      url = urlFor(resource, path)
      $logger.debug "Sending request to: #{url}"
      resp = Faraday.send(method.downcase, url) do | req |
        req.headers['Authorization'] = "Bearer #{accessToken}"
        req.body = body unless body.empty?
  
        if ["POST", "PUT"].include?(method.upcase)
          req.headers['Content-Type'] = 'application/json'
        end
      end
  
      data = resp.body
  
      return data unless parse_json
  
      begin
        hash = JSON.parse(data)
  
        if hash['errorCode'] == "API_AccessDenied"
          raise AccessDeniedException
        end
  
        if hash['message'] == "Invalid permissions"
          raise AccessDeniedException
        end
  
        if hash['code'] == 404
          raise ResourceNotFoundException
        end
        
      rescue JSON::ParserError => e
        $logger.error "Error parsing JSON: #{e.to_s}"
        raise e
      end
  
      return hash
    end
  
    # Query API for OAuth token
    #
    # - +InvalidCredentialsException+ is returned if the provided credentials are not valid
    # 
    # @return [String]
    def getAccessToken
      grantRequest = {
        grant_type: "client_credentials",
        client_id: @configuration['client_id'],
        client_secret: @configuration['client_secret']
      }.to_json
  
      url = urlFor("token")
  
      $logger.debug "calling #{url} with client_id #{@configuration['client_id']}"
  
      response = Faraday.post(
        url, 
        grantRequest,
        "Content-Type" => "application/json"
      )
  
      unless response.status == 200
        $logger.debug "grant response error: #{response.body}"
        raise InvalidCredentialsException
      end
  
      begin
        grant = JSON.parse(response.body)
        return grant['accessToken']
      rescue JSON::ParserError => e
        $logger.error "Error parsing JSON: #{e.to_s}"
        raise e
      end
    end
  
    # Generate the URL for a specific request.
    # This factors in several configuration options including:
    # - +tenant+
    # - +tld+
    #
    # @param resource [String] The specific API resource to request
    # @param path [String] The path to the resource
    #
    # @return [String] The generated URL for the request
    def urlFor(resource, path=nil)
  
      if path != nil
        path = "/#{path.delete_prefix("/")}"
      end
  
      sprintf(DEFAULT_URL_TEMPLATE, @configuration['tenant'], @configuration['tld'] || DEFAULT_TLD, resource, path)
    end
  end
end