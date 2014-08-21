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
            # first assume the user has provided the full/raw SOM path
            unless @afields.setField(f.acro_form_name, f.acro_form_value)
              # if that fails, try setting the shorthand version of the path
              @afields.setField(FieldTypes::AcroForm::SOM.short_name(f.acro_form_name), f.acro_form_value)
            end
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
