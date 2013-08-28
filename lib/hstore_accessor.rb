# include from an initializer

module HstoreAccessor
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def hstore_accessor(hstore_attribute, *keys)
      Array(keys).flatten.each do |key|
        scope "has_#{key}", lambda { |value| where("#{hstore_attribute} @> (? => ?)", key, value) }
        define_method("#{key}=") do |value|
          send("#{hstore_attribute}_will_change!")
          send("#{hstore_attribute}=", (send(hstore_attribute) || {}).merge(key.to_s => value))
        end
        define_method(key) do
          send(hstore_attribute) && send(hstore_attribute)[key.to_s]
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, HstoreAccessor)
