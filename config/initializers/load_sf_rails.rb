require 'salesforce_rails'
SF_API_CONFIG = YAML.load_file(Rails.root.join('config', 'sf_api.yml'))[Rails.env]