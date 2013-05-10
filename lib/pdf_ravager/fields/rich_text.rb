require 'pdf_ravager/field_types/xfa'

module PDFRavager
  module Fields
    class RichText
      include FieldTypes::XFA

      attr_reader :name, :value

      def initialize(name, value)
        @name, @value = name, value
      end

      def ==(other)
        self.name == other.name && self.value == other.value
      end

      def set_xfa_value(xfa)
        # the double-load is to work around a Nokogiri bug I found:
        # https://github.com/sparklemotion/nokogiri/issues/781
        doc = Nokogiri::XML(Nokogiri::XML::Document.wrap(xfa.getDomDocument).to_xml)
        # first, assume the user-provided field name is an xpath and use it directly:
        strict_match =
          begin
            doc.xpath(name)
          rescue Nokogiri::XML::XPath::SyntaxError
            []
          end
        # otherwise, we'll loosely match the field name anywhere in the document:
        loose_match = doc.xpath("//*[local-name()='field'][@name='#{@name}']")
        matched_nodes = strict_match.any? ? strict_match : loose_match
        matched_nodes.each do |node|
          value_node = node.at_xpath("*[local-name()='value']")
          if value_node
            # <value> node exists - just create <exData>
            Nokogiri::XML::Builder.with(value_node) do |xml|
              xml.exData('contentType' => 'text/html') do
                xml.body_('xmlns' => "http://www.w3.org/1999/xhtml", 'xmlns:xfa' => "http://www.xfa.org/schema/xfa-data/1.0/") do
                  xml << xfa_value # Note: this value is not sanitized/escaped!
                end
              end
            end
          else
            # No <value> node exists - create whole structure
            Nokogiri::XML::Builder.with(node) do |xml|
              xml.value_ do
                xml.exData('contentType' => 'text/html') do
                  xml.body_('xmlns' => "http://www.w3.org/1999/xhtml", 'xmlns:xfa' => "http://www.xfa.org/schema/xfa-data/1.0/") do
                    xml << xfa_value # Note: this value is not sanitized/escaped!
                  end
                end
              end
            end
          end
        end
        xfa.setDomDocument(doc.to_java)
        xfa.setChanged(true)
      end

    end
  end
end
