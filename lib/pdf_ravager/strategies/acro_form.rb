module PDFRavager
  module Strategies
    class AcroForm
      def initialize(stamper)
        @stamper = stamper
        @afields = stamper.getAcroFields
      end

      def set_field_values(template)
        template.fields.select{|f| f.respond_to?(:acro_form_value)}.select do |f|
          begin
            @afields.setField(FieldTypes::AcroForm::SOM.short_name(f.acro_form_name), f.acro_form_value)
          rescue java.lang.NullPointerException
            false
          end
        end
      end

      def set_read_only
        @stamper.setFormFlattening(true)
      end

    end
  end
end
