module Formatter
    def self.format_parameters(parameters = {})
      output = "{ "
      parameters.each do |key,value|
        val = format_json(value)
        output += "#{key.to_json} : #{val}, "
      end
      output[0..-3] + " }"
    end

    def self.format_json(value)
      case value
        when ::SFRails::ActiveRecord
          "#{value.convert_to_json}"
        when ::Array
          "[ #{value.map(&:convert_to_json).join(", ")} ]"
        else
          "#{value.to_json}"
      end
    end

    # Translates rails convention (underscore) into Salesforce convention (camelcase).
    def translate_rails_key(key)
      key.to_s.camelize
    end
end