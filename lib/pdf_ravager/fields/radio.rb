require 'pdf_ravager/field_types/acro_form'
require 'pdf_ravager/field_types/xfa'

module PDFRavager
  module Fields
    class Radio
      include FieldTypes::AcroForm
      include FieldTypes::XFA

      attr_reader :group_name, :name

      def initialize(group_name, name)
        @group_name, @name = group_name, name
      end

      def ==(other)
        self.group_name == other.group_name && self.name == other.name
      end

      def acro_form_name
        @group_name
      end

      def xfa_name
        @group_name
      end

      def acro_form_value
        @name
      end

      def xfa_value
        @name
      end

    end
  end
end
