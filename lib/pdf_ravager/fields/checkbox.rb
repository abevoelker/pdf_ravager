require 'pdf_ravager/field_types/acro_form'
require 'pdf_ravager/field_types/xfa'

module PDFRavager
  module Fields
    class Checkbox
      include FieldTypes::AcroForm
      include FieldTypes::XFA

      attr_reader :name, :value

      def initialize(name, value, opts={})
        @name, @value = name, value
        @true_value = opts[:true_value] ? opts[:true_value] : '1'
        @false_value = opts[:false_value] ? opts[:false_value] : '0'
      end

      def ==(other)
        self.name == other.name && self.value == other.value
      end

      def xfa_node_type
        'integer'
      end

      def xfa_value
        @value ? @true_value : @false_value
      end

      def acro_form_value
        @value ? @true_value : @false_value
      end

    end
  end
end
