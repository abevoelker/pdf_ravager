require 'nokogiri'

module PDFRavager
  module FieldTypes
    module XFA

      def xfa_node_type
        'text'
      end

      def xfa_value
        @value.to_s
      end

      def set_xfa_value(doc)
        # first, assume the user-provided field name is an xpath and use it directly:
        strict_match = doc.xpath(name)
        # otherwise, we'll loosely match the field name anywhere in the document:
        loose_match = doc.xpath("//*[local-name()='field'][@name='#{@name}']")
        matched_nodes = strict_match.any? ? strict_match : loose_match
        matched_nodes.each do |node|
          value_node = node.at_xpath("*[local-name()='value']")
          if value_node
            text_node = value_node.at_xpath("*[local-name()='#{xfa_node_type}']")
            if text_node
              # Complete node structure already exists - just set the value
              text_node.content = value
            else
              # <value> node exists, but without child <text> node
              Nokogiri::XML::Builder.with(value_node) do |xml|
                xml.text_ {
                  xml.send("#{xfa_node_type}_", value)
                }
              end
            end
          else
            # No <value> node exists - create whole structure
            Nokogiri::XML::Builder.with(node) do |xml|
              xml.value_ {
                xml.send("#{xfa_node_type}_") {
                  xml.text value
                }
              }
            end
          end
        end
      end

    end
  end
end
