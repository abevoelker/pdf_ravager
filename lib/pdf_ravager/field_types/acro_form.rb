require 'java'
require File.dirname(__FILE__)  + '/../../../vendor/iText-4.2.0'

module PDFRavager
  module FieldTypes
    module AcroForm

      module SOM
        def self.short_name(str)
          com.lowagie.text.pdf.XfaForm::Xml2Som.getShortName(self.escape(str))
        end

        def self.escape(str)
          com.lowagie.text.pdf.XfaForm::Xml2Som.escapeSom(str) # just does: str.gsub(/\./) { '\\.' }
        end
      end

      def acro_form_name
        @name
      end

      def acro_form_value
        @value.to_s
      end

    end
  end
end
