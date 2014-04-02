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

      def set_xfa_value(node)
        value_node = node.at_xpath("*[local-name()='value']")
        value_node && value_node.remove # we will replace the whole <value> node
        Nokogiri::XML::Builder.with(node) do |xml|
          xml.value_ {
            xml.exData('contentType' => 'text/html') {
              xml.body_('xmlns'     => "http://www.w3.org/1999/xhtml",
                        'xmlns:xfa' => "http://www.xfa.org/schema/xfa-data/1.0/") {
                xml << xfa_value
              }
            }
          }
        end
      end

    end
  end
end
