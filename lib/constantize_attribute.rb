unless Object.const_defined? :ActiveRecord
  require 'rubygems'
  gem 'activerecord'
  require 'activerecord'
end

module ConstantizeAttribute

  def constantize_attribute *attribute_names
    attribute_names.each do |name|
      module_eval <<-end_eval, __FILE__, __LINE__

        def #{name}= value
          value = (value.nil? || "" == value) ? nil : value.to_s
          write_attribute(:#{name}, value)
        end

        def #{name}
          value = read_attribute(:#{name})
          value.nil? ? nil : value.constantize
        end

      end_eval
    end
  end

  alias constantize_attributes constantize_attribute

end
