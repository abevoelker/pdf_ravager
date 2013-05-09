module PDFRavager
  module Fieldsets
    class CheckboxGroup

      def initialize(template, name)
        @template, @name = template, name
        yield self if block_given?
      end

      def check(name, opts={})
        @template.check("#{@name}.#{name}", opts)
      end

      def uncheck(name, opts={})
        @template.uncheck("#{@name}.#{name}", opts)
      end

    end
  end
end
