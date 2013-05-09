require 'pdf_ravager/field_types/acro_form'
require 'pdf_ravager/field_types/xfa'

module PDFRavager
  module Fields
    class Text
      include FieldTypes::AcroForm
      include FieldTypes::XFA

      attr_reader :name, :value

      def initialize(name, value)
        @name, @value = name, value
      end

      def ==(other)
        self.name == other.name && self.value == other.value
      end

    end
  end
end
