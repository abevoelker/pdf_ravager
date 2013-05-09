require 'pdf_ravager/fields/text'
require 'pdf_ravager/fields/rich_text'
require 'pdf_ravager/fields/checkbox'
require 'pdf_ravager/fields/radio'
require 'pdf_ravager/fieldsets/checkbox_group'
require 'pdf_ravager/fieldsets/radio_group'
require 'pdf_ravager/ravager' if RUBY_PLATFORM =~ /java/

module PDFRavager
  class Template
    attr_reader :name, :fields

    def initialize(name=nil)
      @name, @fields = name, []
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

    def checkbox_group(group_name, &blk)
      PDFRavager::Fieldsets::CheckboxGroup.new(self, group_name, &blk)
    end

    def radio_group(group_name, &blk)
      PDFRavager::Fieldsets::RadioGroup.new(self, group_name, &blk)
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
