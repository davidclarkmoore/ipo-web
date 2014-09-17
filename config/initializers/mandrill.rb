require 'mandrill'
mandrill = Mandrill::API.new MANDRILL_CONFIG[:api_key]