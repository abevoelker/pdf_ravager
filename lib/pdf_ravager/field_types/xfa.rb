require 'nokogiri'

module PDFRavager
  module FieldTypes
    module XFA

      def xfa_node_type
        'text'
      end

      def xfa_name
        @name
      end

      def xfa_value
        @value.to_s
      end

      def set_xfa_value(node)
        value_node = node.at_xpath("*[local-name()='value']")
        if value_node
          child_node = value_node.at_xpath("*[local-name()='#{xfa_node_type}']")
          if child_node
            # Complete node structure already exists - just set the value
            child_node.content = xfa_value
          else
            # Must create child <#{xfa_node_type}> node
            Nokogiri::XML::Builder.with(value_node) do |xml|
              xml.send("#{xfa_node_type}_", xfa_value)
            end
          end
        else
          # No <value> node exists - create whole structure
          Nokogiri::XML::Builder.with(node) do |xml|
            xml.value_ {
              xml.send("#{xfa_node_type}_", xfa_value)
            }
          end
        end
      end

    end
  end
end
