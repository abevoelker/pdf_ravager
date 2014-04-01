module PDFRavager
  module Strategies
    class Smart
      def initialize(stamper)
        @acro_form = Strategies::AcroForm.new(stamper)
        @xfa       = Strategies::XFA.new(stamper)
        afields    = stamper.getAcroFields
        @type = if afields.getXfa.isXfaPresent
          if afields.getFields.empty?
            :dynamic_xfa
          else
            :static_xfa
          end
        else
          :acro_form
        end
      end

      def set_field_values(template)
        parsed_fields = @acro_form.set_field_values(template)
        unparsed_fields = template.fields - parsed_fields
        if unparsed_fields.any?
          @xfa.set_field_values(Template.new{|t| t.fields = unparsed_fields })
        end
      end

      def set_read_only
        case @type
        when :acro_form, :static_xfa
          @acro_form.set_read_only
        when :dynamic_xfa
          @xfa.set_read_only
        end
      end
    end
  end
end
