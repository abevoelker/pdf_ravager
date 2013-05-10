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

      def set_xfa_value(xfa)
        # the double-load is to work around a Nokogiri bug I found:
        # https://github.com/sparklemotion/nokogiri/issues/781
        doc = Nokogiri::XML(Nokogiri::XML::Document.wrap(xfa.getDomDocument).to_xml)
        # first, assume the user-provided field name is an xpath and use it directly:
        strict_match =
          begin
            doc.xpath(xfa_name)
          rescue Nokogiri::XML::XPath::SyntaxError
            []
          end
        # otherwise, we'll loosely match the field name anywhere in the document:
        loose_match = doc.xpath("//*[local-name()='field'][@name='#{xfa_name}']")
        matched_nodes = strict_match.any? ? strict_match : loose_match
        matched_nodes.each do |node|
          value_node = node.at_xpath("*[local-name()='value']")
          if value_node
            text_node = value_node.at_xpath("*[local-name()='#{xfa_node_type}']")
            if text_node
              # Complete node structure already exists - just set the value
              text_node.content = xfa_value
            else
              # <value> node exists, but without child <text> node
              Nokogiri::XML::Builder.with(value_node) do |xml|
                xml.text_ {
                  xml.send("#{xfa_node_type}_", xfa_value)
                }
              end
            end
          else
            # No <value> node exists - create whole structure
            Nokogiri::XML::Builder.with(node) do |xml|
              xml.value_ {
                xml.send("#{xfa_node_type}_") {
                  xml.text xfa_value
                }
              }
            end
          end
        end
        xfa.setDomDocument(doc.to_java)
        xfa.setChanged(true)
      end

    end
  end
end
