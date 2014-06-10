module SFRails
  attr_accessor :client

  # Database connection module. Used to instantiate new connections to salesforce.
  # -- TODO: Handle connection authentication errors.
  def self.connection
    return @client if @client.present?
    #TODO: Add exception handling
    options = { host: SF_API_CONFIG["host"],
                client_id: SF_API_CONFIG["client_id"],
                client_secret: SF_API_CONFIG["client_secret"],
                verify_mode: OpenSSL::SSL::VERIFY_NONE }
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
      sf_object = sf_class.create(sf_object_values)
      self.sf_object_id = sf_object.Id
      self.save
    end

    def update_to_sf
      sf.Id = self.sf_object_id
      sf.attributes = sf_object_values
      sf.save
    end

    def upsert_to_sf; sf ? update_to_sf : create_to_sf; end
    
    def sf_object_values
      sf_object = {}
      sf_mapping_hash.each { |local_key, sf_key|
        sf_object[sf_key] = sf_value(local_key, sf_key)
      }
      sf_object["Id"] = self.sf_object_id if self.sf_object_id
      sf_object
    end

    def convert_to_json
      SFRails.connection.send(:coerced_json, sf_object_values, sf_class)
    end
    
    included do
      class_eval do
        attr_accessible :sf_object_id
      end
    end

    module ClassMethods
      attr_accessor :sf_model_name, :sf_mapping_hash

      def salesforce(model_name, mapping = [], mapping_hash = {})
        self.sf_model_name = model_name;
        mapping.each_with_index { |item, index| mapping_hash[item] = sf_key(item) }
        self.sf_mapping_hash = mapping_hash
      end

      def sf
        return @materialized if @materialized.present?
        @materialized = SFRails.connection.materialize(sf_model_name)
        @materialized.send(:include, Adapter)
        @materialized.rails_class = self
        @materialized
      end

      def sf_key(local_key)
        sf_key = local_key.to_s.titleize.gsub(' ', '_')
        index = sf.attributes.index(sf_key) || sf.attributes.index(sf_key + "__c")
        if index
          return sf.attributes[ index ]
        else
          return nil
        end
      end

    end

    private

    def sf_value(local_key, sf_key)
      value = self.send(local_key)
      case sf_class.field_type(sf_key)
        when "picklist" 
          t(local_key, value) if value.present? 
        when "multipicklist" 
          value.map { |val| t(local_key, val) } if value.present? 
        else
          value
      end    
    end

    def t(key, value)
      I18n.t "enumerize.#{self.class.name.underscore}.#{key}.#{value}", locale: :en
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

    def save_to_rails!
      rails_record ? update_to_rails! : create_to_rails!
    end

    def update_to_rails!
      rails_record.update_attributes!(rails_object_values)
    end
    
    def update_to_rails
      rails_record.update_attributes(rails_object_values)
    end

    def create_to_rails!
      rails_class.create!(rails_object_values_with_id)
    end

    def create_to_rails
      rails_class.create(rails_object_values_with_id)
    end

    def rails_record
      @rails_record ||= rails_class.find_by_sf_object_id(self.Id)
    end

    def rails_class; self.class.rails_class; end

    def rails_object_values 
      rails_object = {}
      rails_class.sf_mapping_hash.each { |rails_key, sf_key|
        rails_object[rails_key] = rails_value(rails_key, sf_key)
      }
      #sf_object["Id"] = self.sf_object_id if self.sf_object_id
      rails_object
    end

    def rails_value(rails_key, sf_key)
      value = self.send(sf_key)
      case self.class.field_type(sf_key)
        when "picklist" 
          t(rails_key, value) if value.present? 
        when "multipicklist" 
          value.map { |val| t(rails_key, val) } if value.present? 
        when "boolean"
          value ? "1" : "0"
        else
          value
      end    
    end

    private

    def rails_object_values_with_id
      values = rails_object_values
      values[:sf_object_id] = self.Id
      values
    end

    def t(key, value)
      hash = I18n.backend.send(:translations)[:en][:enumerize][rails_class.name.underscore.to_sym][key].key(value).to_s
    end

    # Fetch the right salesforce field based on the rails field key passed in.
    def sf_field(key)
      translated_key = Formatter.translate_rails_key(key)
      self.attributes.find { |a|  a == translated_key || a == translated_key + "__c" }
    end

  end
end