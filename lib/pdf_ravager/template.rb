require 'json'
require 'pdf_ravager/fields/text'
require 'pdf_ravager/fields/rich_text'
require 'pdf_ravager/fields/checkbox'
require 'pdf_ravager/fields/radio'
require 'pdf_ravager/ravager' if RUBY_PLATFORM =~ /java/

module PDFRavager
  class Template
    attr_reader :fields

    def initialize
      @fields = []
      yield self if block_given?
    end

    def text(name, value)
      @fields << PDFRavager::Fields::Text.new(name, value)
    end

    def rich_text(name, value)
      @fields << PDFRavager::Fields::RichText.new(name, value)
    end

    def check(name, opts={})
      @fields << PDFRavager::Fields::Checkbox.new(name, true, opts)
    end

    def uncheck(name, opts={})
      @fields << PDFRavager::Fields::Checkbox.new(name, false, opts)
    end

    def fill(group_name, name)
      @fields << PDFRavager::Fields::Radio.new(group_name, name)
    end

    if RUBY_PLATFORM =~ /java/
      def ravage(file, opts={})
        PDFRavager::Ravager.ravage(self, opts.merge({:in_file => file}))
      end
    else
      def ravage(file, opts={})
        raise "You can only ravage PDFs using JRuby, not #{RUBY_PLATFORM}!"
      end
    end

    def ==(other)
      self.fields == other.fields
    end

  end
end
