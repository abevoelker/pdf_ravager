module PDFRavager
  module Strategies
    class XFA
      def initialize(stamper)
        @xfa = stamper.getAcroFields.getXfa
      end

      def set_field_values(template)
        # the double-load is to work around a Nokogiri bug I found:
        # https://github.com/sparklemotion/nokogiri/issues/781
        doc = Nokogiri::XML(Nokogiri::XML::Document.wrap(@xfa.getDomDocument).to_xml)
        template.fields.select{|f| f.respond_to?(:set_xfa_value)}.each do |f|
          # first, assume the user-provided field name is an xpath and use it directly:
          strict_match =
            begin
              doc.xpath(f.xfa_name)
            rescue Nokogiri::XML::XPath::SyntaxError
              []
            end
          # otherwise, we'll loosely match the field name anywhere in the document:
          loose_match = doc.xpath("//*[local-name()='field'][@name='#{f.xfa_name}']")
          matched_nodes = strict_match.any? ? strict_match : loose_match
          matched_nodes.each do |node|
            value_node = node.at_xpath("*[local-name()='value']")
            if value_node
              text_node = value_node.at_xpath("*[local-name()='#{f.xfa_node_type}']")
              if text_node
                # Complete node structure already exists - just set the value
                text_node.content = f.xfa_value
              else
                # <value> node exists, but without child <text> node
                Nokogiri::XML::Builder.with(value_node) do |xml|
                  xml.text_ {
                    xml.send("#{f.xfa_node_type}_", f.xfa_value)
                  }
                end
              end
            else
              # No <value> node exists - create whole structure
              Nokogiri::XML::Builder.with(node) do |xml|
                xml.value_ {
                  xml.send("#{f.xfa_node_type}_") {
                    xml.text f.xfa_value
                  }
                }
              end
            end
          end
        end
        @xfa.tap do |x|
          x.setDomDocument(doc.to_java)
          x.setChanged(true)
        end
      end

      def set_read_only
        doc = Nokogiri::XML(Nokogiri::XML::Document.wrap(@xfa.getDomDocument).to_xml)
        doc.xpath("//*[local-name()='field']").each do |node|
          node["access"] = "readOnly"
        end
        @xfa.setDomDocument(doc.to_java)
        @xfa.setChanged(true)
      end

    end
  end
end
