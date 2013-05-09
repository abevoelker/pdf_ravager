module PDFRavager
  module Fieldsets
    class RadioGroup

      def initialize(template, name)
        @template, @name = template, name
        yield self if block_given?
      end

      def fill(name)
        @template.fill(@name, name)
      end

    end
  end
end
