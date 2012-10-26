require 'java'
require File.dirname(__FILE__)  + '/../../vendor/iText-4.2.0'

java_import "com.lowagie.text.pdf.AcroFields"
java_import "com.lowagie.text.pdf.PdfArray"
java_import "com.lowagie.text.pdf.PdfDictionary"
java_import "com.lowagie.text.pdf.PdfName"
java_import "com.lowagie.text.pdf.PdfObject"
java_import "com.lowagie.text.pdf.PdfReader"
java_import "com.lowagie.text.pdf.PdfStamper"
java_import "com.lowagie.text.pdf.PdfStream"
java_import "com.lowagie.text.pdf.PdfWriter"
java_import "com.lowagie.text.pdf.XfaForm"
java_import "com.lowagie.text.pdf.XfdfReader"

module PDFRavager
  class Ravager
    private_class_method :new

    def self.open(opts={}, &block)
      opts = {:in_file => opts} if opts.is_a? String
      out = if opts[:out_file]
        java.io.FileOutputStream.new(opts[:out_file])
      else
        java.io.ByteArrayOutputStream.new
      end
      raise "You must pass a block" unless block_given?
      ravager = new(opts[:in_file], out)
      yield ravager
      ravager.destroy
      out
    end

    def set_field_value(name, value, type=nil)
      return set_rich_text_field(name, value) if type == :rich_text
      # First use AcroForms method
      begin
        @afields.setField(XfaForm::Xml2Som::getShortName(SOM.escape(name)), value)
      rescue java.lang.NullPointerException
        # If the AcroForms method doesn't work, we'll set the XDP
        # Note: the double-load is to work around a Nokogiri bug I found:
        # https://github.com/sparklemotion/nokogiri/issues/781
        doc = Nokogiri::XML(Nokogiri::XML::Document.wrap(@xfa.getDomDocument).to_xml)
        doc.xpath("//*[local-name()='field'][@name='#{name}']").each do |node|
          # Create an XML node in the XDP basically like this: "<value><text>#{value}</text></value>"
          Nokogiri::XML::Builder.with(node) do |xml|
            xml.value_ {
              xml.text_ {
                xml.text value
              }
            }
          end
        end
        @xfa.setDomDocument(doc.to_java)
        @xfa.setChanged(true)
      end
    end

    def destroy
      @stamper.close
    end

    private

    def initialize(in_file, out)
      @reader = PdfReader.new(in_file)
      @out = out
      @stamper = PdfStamper.new(@reader, @out)
      @afields = @stamper.getAcroFields
      @xfa = @afields.getXfa
      @som = @xfa.getDatasetsSom
      @som_template = @xfa.getTemplateSom
    end

    def set_rich_text_field(name, value)
      doc = Nokogiri::XML(Nokogiri::XML::Document.wrap(@xfa.getDomDocument).to_xml)
      doc.xpath("//*[local-name()='field'][@name='#{name}']").each do |node|
        Nokogiri::XML::Builder.with(node) do |xml|
          xml.value_ do
            xml.exData('contentType' => 'text/html') do
              xml.body_('xmlns' => "http://www.w3.org/1999/xhtml", 'xmlns:xfa' => "http://www.xfa.org/schema/xfa-data/1.0/") do
                xml << value # Note: this value is not sanitized/escaped!
              end
            end
          end
        end
      end
      @xfa.setDomDocument(doc.to_java)
      @xfa.setChanged(true)
    end

  end

  class SOM
    def self.escape(str)
      XfaForm::Xml2Som.escapeSom(str) # just does: str.gsub(/\./) { '\\.' }
    end
  end
end
