require 'json'
require 'pdf_ravager/ravager' if RUBY_PLATFORM =~ /java/

module PDFRavager
  class PDF
    attr_reader :name, :fields

    def initialize(name=nil, opts={})
      @name = name if name
      @fields = opts[:fields] || []
    end

    def text(name, value, opts={})
      if opts.empty?
        @fields << {:name => name, :value => value, :type => :text}
      else
        @fields << {:name => name, :value => value, :type => :text, :options => opts}
      end
    end

    def check(name, opts={})
      @fields << {:name => name, :value => true, :type => :checkbox}
    end

    def radio_group(gname, &blk)
      fields = []
      # TODO: replace w/ singleton method?
      PDF.instance_eval do
        send(:define_method, :fill) do |name, opts={}|
          fields << {:name => gname, :value => name, :type => :radio}
        end
        blk.call
        send(:undef_method, :fill)
      end

      @fields += fields
    end

    def checkbox_group(gname, &blk)
      # TODO: replace w/ singleton method?
      PDF.instance_eval do
        alias_method :__check_original__, :check
        send(:define_method, :check) do |name, opts={}|
          __check_original__("#{gname}.#{name}", opts)
        end
        blk.call
        # restore check method back to normal
        alias_method :check, :__check_original__
        send(:undef_method, :__check_original__)
      end
    end

    if RUBY_PLATFORM =~ /java/
      def ravage(file, opts={})
        PDFRavager::Ravager.open(opts.merge(:in_file => file)) do |pdf|
          @fields.each do |f|
            value = if f[:type] == :checkbox
              !!f[:value] ? '1' : '0' # Checkbox default string values
            else
              f[:value]
            end
            pdf.set_field_value(f[:name], value, f[:type], f[:options])
          end
        end
      end
    else
      def ravage(file, opts={})
        raise "You can only ravage .pdfs using JRuby, not #{RUBY_PLATFORM}!"
      end
    end

    def ==(other)
      self.name == other.name && self.fields == other.fields
    end

    def to_json(*args)
      {
        "json_class"   => self.class.name,
        "data"         => {"name" => @name, "fields" => @fields }
      }.to_json(*args)
    end

    def self.json_create(obj)
      fields = obj["data"]["fields"].map do |f|
        # symbolize the root keys
        f = f.inject({}){|h,(k,v)| h[k.to_sym] = v; h}
        f[:type] = f[:type].to_sym if f[:type]
        # symbolize the :options keys
        if f[:options]
          f[:options] = f[:options].inject({}){|h,(k,v)| h[k.to_sym] = v; h}
        end
        f
      end
      o = new(obj["data"]["name"], :fields => fields)
    end
  end
end

module Kernel
  def pdf(name=nil, opts={}, &blk)
    r = PDFRavager::PDF.new(name, opts)
    r.instance_eval(&blk)
    r
  end
end