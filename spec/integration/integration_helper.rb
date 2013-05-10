require File.dirname(__FILE__) + '/../spec_helper'
require 'rspec'
require 'pdf_ravager'
require 'securerandom'
require 'chunky_png'
require 'tempfile'

def mktemp(ext)
  Tempfile.new(['', ext]).path
end

def pdf_to_ps(pdf_file, out_file=nil)
  out_file ||= mktemp('.ps')
  system("acroread -toPostScript -markupsOn -pairs #{pdf_file} #{out_file} >/dev/null 2>&1")
  out_file
end

def ps_to_png(ps_file, out_file=nil)
  out_file ||= mktemp('.png')
  system("gs -dSAFER -dBATCH -dNOPAUSE -r150 -sDEVICE=png16m -dTextAlphaBits=4 -sOutputFile=#{out_file} #{ps_file} >/dev/null 2>&1")
  out_file
end

def pdf_to_png(pdf_file)
  ps_to_png(pdf_to_ps(pdf_file))
end

# code taken from http://jeffkreeftmeijer.com/2011/comparing-images-and-creating-image-diffs/
def png_diff(img1, img2)
  images = [
    ChunkyPNG::Image.from_file(img1),
    ChunkyPNG::Image.from_file(img2)
  ]

  output = ChunkyPNG::Image.new(images.first.width, images.last.width, ChunkyPNG::Color::WHITE)

  diff = []

  images.first.height.times do |y|
    images.first.row(y).each_with_index do |pixel, x|
      unless pixel == images.last[x,y]
        score = Math.sqrt(
          (ChunkyPNG::Color::r(images.last[x,y]) - ChunkyPNG::Color::r(pixel)) ** 2 +
          (ChunkyPNG::Color::g(images.last[x,y]) - ChunkyPNG::Color::g(pixel)) ** 2 +
          (ChunkyPNG::Color::b(images.last[x,y]) - ChunkyPNG::Color::b(pixel)) ** 2
        ) / Math.sqrt(ChunkyPNG::Color::MAX ** 2 * 3)

        output[x,y] = ChunkyPNG::Color::grayscale(ChunkyPNG::Color::MAX - (score * ChunkyPNG::Color::MAX).round)
        diff << score
      end
    end
  end

  num_pixels_changed = diff.length
  pct_changed = (num_pixels_changed == 0) ? 0 : (diff.inject(:+) / images.first.pixels.length) * 100

  [num_pixels_changed, pct_changed]
end
