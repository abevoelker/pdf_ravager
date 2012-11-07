require 'java'
require 'nokogiri'
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
      ravager = new(opts.merge({:out => out}))
      yield ravager
      ravager.destroy
      out
    end

    def set_field_value(name, value, type=nil, options={})
      return set_rich_text_field(name, value) if options && options[:rich]
      begin
        # First try AcroForms method of setting value
        @afields.setField(SOM.short_name(name), value)
      rescue java.lang.NullPointerException
      end
      # Also look for the XDP node and set that value
      # Note: the double-load is to work around a Nokogiri bug I found:
      # https://github.com/sparklemotion/nokogiri/issues/781
      doc = Nokogiri::XML(Nokogiri::XML::Document.wrap(@xfa.getDomDocument).to_xml)
      node_type = type == :checkbox ? 'integer' : 'text'
      doc.xpath("//*[local-name()='field'][@name='#{name}']").each do |node|
        value_node = node.at_xpath("*[local-name()='value']")
        if value_node
          text_node = value_node.at_xpath("*[local-name()='#{node_type}']")
          if text_node
            # Complete node structure already exists - just set the value
            text_node.content = value
          else
            # <value> node exists, but without child <text> node
            Nokogiri::XML::Builder.with(value_node) do |xml|
              xml.text_ {
                xml.send("#{node_type}_", value)
              }
            end
          end
        else
          # No <value> node exists - create whole structure
          Nokogiri::XML::Builder.with(node) do |xml|
            xml.value_ {
              xml.send("#{node_type}_") {
                xml.text value
              }
            }
          end
        end
      end
      @xfa.setDomDocument(doc.to_java)
      @xfa.setChanged(true)
    end

    def destroy
      read_only! if @opts[:read_only]
      @stamper.close
    end

    private

    def initialize(opts={})
      @opts = opts
      @reader = PdfReader.new(opts[:in_file])
      @stamper = PdfStamper.new(@reader, opts[:out])
      @afields = @stamper.getAcroFields
      @xfa = @afields.getXfa
      @som = @xfa.getDatasetsSom
      @som_template = @xfa.getTemplateSom
      @type = @xfa.isXfaPresent ? :xfa : :acro_forms
      if @type == :xfa
        @xfa_type = @afields.getFields.empty? ? :dynamic : :static
      end
    end

    def set_rich_text_field(name, value)
      doc = Nokogiri::XML(Nokogiri::XML::Document.wrap(@xfa.getDomDocument).to_xml)
      doc.xpath("//*[local-name()='field'][@name='#{name}']").each do |node|
        value_node = node.at_xpath("*[local-name()='value']")
        if value_node
          # <value> node exists - just create <exData>
          Nokogiri::XML::Builder.with(value_node) do |xml|
            xml.exData('contentType' => 'text/html') do
              xml.body_('xmlns' => "http://www.w3.org/1999/xhtml", 'xmlns:xfa' => "http://www.xfa.org/schema/xfa-data/1.0/") do
                xml << value # Note: this value is not sanitized/escaped!
              end
            end
          end
        else
          # No <value> node exists - create whole structure
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
      end
      @xfa.setDomDocument(doc.to_java)
      @xfa.setChanged(true)
    end

    def read_only!
      case @type
      when :acro_forms
        @stamper.setFormFlattening(true)
      when :xfa
        if @xfa_type == :static
          @stamper.setFormFlattening(true)
        else
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

  class SOM
    def self.short_name(str)
      XfaForm::Xml2Som.getShortName(self.escape(str))
    end

    def self.escape(str)
      XfaForm::Xml2Som.escapeSom(str) # just does: str.gsub(/\./) { '\\.' }
    end
  end
end
