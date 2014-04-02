module PDFRavager
  module Strategies
    class XFA
      def initialize(stamper)
        @xfa = stamper.getAcroFields.getXfa
      end

      def set_field_values(template)
        doc = to_nokogiri_xml
        template.fields.select{|f| f.respond_to?(:set_xfa_value)}.each do |f|
          # first, assume the user-provided field name is an xpath and use it directly:
          strict_match =
            begin
              doc.xpath(f.xfa_name)
            rescue Nokogiri::XML::XPath::SyntaxError
              []
            end
          if strict_match.any?
            strict_match.each{|node| f.set_xfa_value(node) }
          else
            # otherwise, we'll loosely match the field name anywhere in the document:
            loose_match = doc.xpath("//*[local-name()='field'][@name='#{f.xfa_name}']")
            loose_match.each{|node| f.set_xfa_value(node) }
          end
        end
        @xfa.setDomDocument(doc.to_java)
        @xfa.setChanged(true)
      end

      def set_read_only
        doc = to_nokogiri_xml
        doc.xpath("//*[local-name()='field']").each do |node|
          node["access"] = "readOnly"
        end
        @xfa.setDomDocument(doc.to_java)
        @xfa.setChanged(true)
      end

      private

      def to_nokogiri_xml
        # the double-load is to work around a Nokogiri bug I found:
        # https://github.com/sparklemotion/nokogiri/issues/781
        Nokogiri::XML(Nokogiri::XML::Document.wrap(@xfa.getDomDocument).to_xml)
      end

    end
  end
end
