unless RUBY_PLATFORM =~ /java/
  raise "You can only ravage PDFs using JRuby, not #{RUBY_PLATFORM}!"
end

require 'java'
require 'nokogiri'
require File.dirname(__FILE__)  + '/../../vendor/iText-4.2.0'

module PDFRavager
  class Ravager
    private_class_method :new

    def self.ravage(template, opts={})
      opts = {:in_file => opts} if opts.is_a? String
      out = if opts[:out_file]
        java.io.FileOutputStream.new(opts[:out_file])
      else
        java.io.ByteArrayOutputStream.new
      end
      ravager = new(template, opts.merge({:out => out}))
      ravager.send(:set_field_values)
      ravager.send(:set_read_only) if opts[:read_only]
      ravager.send(:destroy)
      out
    end

    private

    # instantiation is private because there is a lot of state mutation
    # and some invariants that need to be cleaned up. therefore, Ravager's
    # lifecycle is managed by the public class method `ravage`.
    def initialize(template, opts={})
      @template = template
      reader = com.lowagie.text.pdf.PdfReader.new(opts[:in_file])
      @stamper = com.lowagie.text.pdf.PdfStamper.new(reader, opts[:out])
      @afields = @stamper.getAcroFields
      @xfa = @afields.getXfa
      @type = @xfa.isXfaPresent ? :xfa : :acro_forms
      if @type == :xfa
        @xfa_type = @afields.getFields.empty? ? :dynamic : :static
      end
    end

    def destroy
      @stamper.close
    end

    def set_field_values
      case @type
      when :acro_forms
        @template.fields.each{|f| f.set_acro_form_value(@afields) }
      when :xfa
        @template.fields.each do |f|
          f.set_acro_form_value(@afields) if f.respond_to? :set_acro_form_value
          f.set_xfa_value(@xfa) if f.respond_to? :set_xfa_value
        end
      end
    end

    def set_read_only
      case @type
      when :acro_forms
        @stamper.setFormFlattening(true)
      when :xfa
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
