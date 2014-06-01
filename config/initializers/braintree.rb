BRAINTREE_CONFIG = YAML.load(File.read(File.expand_path('../../braintree.yml', __FILE__)))
BRAINTREE_CONFIG.symbolize_keys!
Braintree::Configuration.environment = BRAINTREE_CONFIG[:environment].to_sym unless Rails.env.test?
Braintree::Configuration.merchant_id = BRAINTREE_CONFIG[:merchant_id]
Braintree::Configuration.public_key = BRAINTREE_CONFIG[:public_key]
Braintree::Configuration.private_key = BRAINTREE_CONFIG[:private_key]