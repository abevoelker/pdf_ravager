require 'pdf_ravager/template'

module Kernel
  def pdf(*args, &blk)
    warn "[DEPRECATION] Please use `PDFRavager::Template.new` instead of `pdf`"
    PDFRavager::Template.new(*args, &blk)
  end
end
