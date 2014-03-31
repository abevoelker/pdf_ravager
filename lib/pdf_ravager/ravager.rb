require 'pdf_ravager/strategies/xfa'
require 'pdf_ravager/strategies/acro_form'
require 'pdf_ravager/strategies/smart'

unless RUBY_PLATFORM =~ /java/
  raise "You can only ravage PDFs using JRuby, not #{RUBY_PLATFORM}!"
end

require 'java'
require 'nokogiri'
require File.dirname(__FILE__)  + '/../../vendor/iText-4.2.0'

module PDFRavager
  class Ravager
    def self.ravage(*args, &blk)
      warn "[DEPRECATION] Please use PDFRavager::Ravager's instance " +
           "methods instead of the `::ravage` method"
      new(*args, &blk).ravage
    end

    def initialize(template, opts={})
      @opts = opts
      opts = {:in_file => opts} if opts.is_a? String
      @out = if opts[:out_file]
        java.io.FileOutputStream.new(opts[:out_file])
      else
        java.io.ByteArrayOutputStream.new
      end
      @template = template
      reader = com.lowagie.text.pdf.PdfReader.new(opts[:in_file])
      @stamper = com.lowagie.text.pdf.PdfStamper.new(reader, @out)
      @strategy = case template.strategy
      when :acro_forms
        Strategies::AcroForm.new(@stamper)
      when :xfa
        Strategies::XFA.new(@stamper)
      when :smart
        Strategies::Smart.new(@stamper)
      end
    end

    def ravage
      @strategy.set_field_values(@template)
      @strategy.set_read_only if @opts[:read_only]
      @stamper.close
      @out
    end
  end
end
