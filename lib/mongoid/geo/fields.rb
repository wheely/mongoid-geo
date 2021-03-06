module Mongoid #:nodoc
  # This module defines behaviour for fields.
  module Fields
    module ClassMethods #:nodoc
      def create_accessors(name, meth, options = {})
        generated_field_methods.module_eval do
          define_method(meth) { read_attribute(name) }
          define_method("#{meth}=") do |value| 
            if options[:type] == Array && options[:geo]
              value = case value
              when String 
                value.split(",").map(&:to_f)
              when Array 
                value.compact.extend(Mongoid::Geo::Point).to_points
              else
                !value.nil? ? value.extend(Mongoid::Geo::Point).to_point : value
              end
              value = value[0..1] if !value.nil?
            end            
            write_attribute(name, value) 
          end
          define_method("#{meth}?") do
            attr = read_attribute(name)
            (options[:type] == Boolean) ? attr == true : attr.present?
          end
        end
      end
    end
  end
end