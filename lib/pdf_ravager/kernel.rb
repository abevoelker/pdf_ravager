require 'pdf_ravager/template'

module Kernel
  def pdf(*args, &blk)
    PDFRavager::Template.new(*args, &blk)
  end
end
