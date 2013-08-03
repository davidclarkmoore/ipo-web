module SFRails
  attr_accessor :client

  CLIENT_ID      = "3MVG98XJQQAccJQfOIfYKJq5IT9AZVYCZj_xsH4X6lEDy5iaO66XDey0VlRVILVTw3egQ.TAfI0xIwBGZickm"
  SECRET         = "2727504907817902269"
  SECURITY_TOKEN = "69eMZLjUu7oNpILujNU1AwVu"

  # Database connection module. Used to instantiate new connections to salesforce.
  # -- TODO: Handle connection authentication errors.
  # -- TODO: Extract connector values to YML file.
  def self.connection
    return @client if @client.present?
    @client = Databasedotcom::Client.new client_id: CLIENT_ID,
                                         client_secret: SECRET,
                                         verify_mode: OpenSSL::SSL::VERIFY_NONE

    @client.authenticate username: "james.strong@etherpros.com",
                         password: "!#QE24wr#{SECURITY_TOKEN}"
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

    included do
      class_eval do
        attr_accessible :sf_object_id
      end
    end

    module ClassMethods
      attr_accessor :sf_model_name, :sf_mapping

      def salesforce(model_name, mapping)
        self.sf_model_name = model_name;
        self.sf_mapping = mapping
      end

      def sf
        return @materialized if @materialized.present?
        @materialized = SFRails.connection.materialize(sf_model_name)
        @materialized.send(:include, Adapter)
        @materialized.rails_class = self
        @materialized
      end

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