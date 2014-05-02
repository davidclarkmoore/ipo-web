module SFRails
  attr_accessor :client

  # Database connection module. Used to instantiate new connections to salesforce.
  # -- TODO: Handle connection authentication errors.
  # -- TODO: Extract connector values to YML file.
  def self.connection
    return @client if @client.present?
    #TODO: Add exception handling
    options = { host: SF_API_CONFIG["host"],
                                         client_id: SF_API_CONFIG["client_id"],
                                         client_secret: SF_API_CONFIG["client_secret"],
                                         verify_mode: OpenSSL::SSL::VERIFY_NONE  }
    @client = Databasedotcom::Client.new options

    @client.authenticate username: SF_API_CONFIG["username"],
                         password: SF_API_CONFIG["password"] + SF_API_CONFIG["security_token"]
    @client
  end

  module ActiveRecord
    extend ActiveSupport::Concern

    def sf
      return nil if self.sf_object_id.nil?
      sf_class.find(self.sf_object_id)
    end

    def sf_class; self.class.sf; end
    def sf_model_name; self.class.sf_model_name; end
    def sf_mapping; self.class.sf_mapping; end
    def sf_mapping_hash; self.class.sf_mapping_hash; end

    def create_to_sf
      sf_object = sf_class.create(sf_values)
      self.sf_object_id = sf_object.Id
      self.save
    end
    
    def sf_values
      values = sf_mapping.inject({}) { |hash, key|
        hash[sf_key(key)] = sf_value(key)
        hash
      }
      sf_mapping_hash.each { |key, value|
        values[value] = sf_value(key)
      }
      values
    end

    def coerced_json 
      SFRails.connection.send(:coerced_json, sf_values, sf_class)
    end

    def sf_json( name = self.class.name.underscore )
      "\"#{name}\" : #{coerced_json}"
    end

    included do
      class_eval do
        attr_accessible :sf_object_id
      end
    end

    module ClassMethods
      attr_accessor :sf_model_name, :sf_mapping, :sf_mapping_hash

      def salesforce(model_name, mapping = [], mapping_hash = {})
        self.sf_model_name = model_name;
        self.sf_mapping = mapping
        self.sf_mapping_hash = mapping_hash
      end

      def sf
        return @materialized if @materialized.present?
        @materialized = SFRails.connection.materialize(sf_model_name)
        @materialized.send(:include, Adapter)
        @materialized.rails_class = self
        @materialized
      end

    end

    private

    def sf_key(key)
      sf_key = key.to_s.titleize.gsub(' ', '_')
      index = sf_class.attributes.index(sf_key) || sf_class.attributes.index(sf_key + "__c")
      if index
        return sf_class.attributes[ index ]
      else
        return nil
      end
    end

    def sf_value(key)
      value = self.send(key)
      value.class.include?(Enumerable) ? value.map(&:titleize) : value
    end

  end

  module Adapter
    extend ActiveSupport::Concern

    module ClassMethods
      attr_accessor :rails_class
    end

    def save_to_rails
      rails_record ? update_to_rails : create_to_rails
    end

    #TODO: Implement!
    def update_to_rails
    end

    def create_to_rails
      values =  rails_class.sf_mapping.inject({}) { |hash, key|
                  hash[key] = sf_field(key)
                  hash
                }
      values[:sf_object_id] = self.Id
      rails_class.create(values)
    end

    def rails_record
      @rails_record ||= rails_class.find_by_sf_object_id(self.Id)
    end

    def rails_class; self.class.rails_class; end

    private

    # Fetch the right salesforce field based on the rails field key passed in.
    def sf_field(key)
      self.attributes[translate_rails_key(key)] || self.attributes[translate_rails_key(key) + "__c"]
    end

    # Translates rails convention (underscore) into Salesforce convention (camelcase).
    # -- TODO: Not sure if this is the proper place for this function.
    def translate_rails_key(key)
      key.to_s.camelize
    end

  end
end