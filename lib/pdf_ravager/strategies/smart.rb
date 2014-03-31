module PDFRavager
  module Strategies
    class Smart
      def initialize(stamper)
        @acro_form = Strategies::AcroForm.new(stamper)
        @xfa       = Strategies::XFA.new(stamper)
      end

      def set_field_values(template)
        parsed_fields = @acro_form.set_field_values(template)
        unparsed_fields = template.fields - parsed_fields
        if unparsed_fields.any?
          @xfa.set_field_values(Template.new{|t| t.fields = unparsed_fields })
        end
      end

      def set_read_only
        [@acro_form, @xfa].each(&:set_read_only)
      end
    end
  end
end
