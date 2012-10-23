require 'java'
require File.dirname(__FILE__)  + '/../../vendor/iText-4.2.0'

include_class "com.lowagie.text.pdf.AcroFields"
include_class "com.lowagie.text.pdf.PdfArray"
include_class "com.lowagie.text.pdf.PdfDictionary"
include_class "com.lowagie.text.pdf.PdfName"
include_class "com.lowagie.text.pdf.PdfObject"
include_class "com.lowagie.text.pdf.PdfReader"
include_class "com.lowagie.text.pdf.PdfStamper"
include_class "com.lowagie.text.pdf.PdfStream"
include_class "com.lowagie.text.pdf.PdfWriter"
include_class "com.lowagie.text.pdf.XfaForm"
include_class "com.lowagie.text.pdf.XfdfReader"

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

    def set_field_value(name, value)
      # First use AcroForms method
      begin
        @afields.setField(XfaForm::Xml2Som::getShortName(SOM.escape(name)), value)
      rescue java.lang.NullPointerException
        # If the AcroForms method doesn't work, we'll set the XDP
        doc = Nokogiri::XML::Document.wrap(@xfa.getDomDocument)
        doc.xpath("//*[local-name()='field'][@name='#{name}']").each do |node|
          # Create an XML node in the XDP basically like this: "<value><text>#{value}</text></value>"
          Nokogiri::XML::Builder.with(node) do |xml|
            xml.value_ do |v|
              v.text_ value
            end
          end
        end
        @xfa.setDomDocument(doc.to_java)
        @xfa.setChanged(true)
      end
    end

    def get_field_type(name)
      short_name = XfaForm::Xml2Som::getShortName(SOM.escape(name))
      begin
        @afields.getFieldType(short_name)
      rescue java.lang.NullPointerException
        nil
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

  end

  class SOM
    def self.escape(str)
      XfaForm::Xml2Som.escapeSom(str) # just does: str.gsub(/\./) { '\\.' }
    end
  end
end
