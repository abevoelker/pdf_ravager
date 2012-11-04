require File.dirname(__FILE__) + '/../integration_helper'

describe 'a PDF with a multiline text field' do
  describe 'filled with FOO' do
    before(:each) do
      p = pdf do
        text 'multilinetext', 'FOO' * 10000
      end
      pdf_file = File.join(File.dirname(__FILE__), "pdf")
      @pdf_file = "#{mktemp}.pdf"
      @pdf = p.ravage pdf_file, :out_file => @pdf_file
    end

    it 'should match expected.png when rendered' do
      png = pdf_to_png(@pdf_file)
      pix_diff, pct_diff = png_diff(png, File.join(File.dirname(__FILE__), "expected.png"))
      pix_diff.should == 0
    end
  end
end
