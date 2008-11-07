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
          write_attribute(:#{name}, value.to_s)
        end

        def #{name}
          read_attribute(:#{name}).constantize
        end

      end_eval
    end
  end

  alias constantize_attributes constantize_attribute

end
