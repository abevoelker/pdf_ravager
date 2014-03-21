require File.dirname(__FILE__) + '/../integration_helper'

describe 'a PDF with a checkbox field' do
  let(:input_pdf) { File.join(File.dirname(__FILE__), "pdf") }

  context 'unchecked' do
    let(:template) {
      PDFRavager::Template.new
    }
    let(:expected) { File.join(File.dirname(__FILE__), "unchecked.png") }

    it 'matches unchecked.png when rendered' do
      pix_diff, _ = compare_pdf_to_png(ravage_to_temp_file(template, input_pdf), expected)
      expect(pix_diff).to eq(0)
    end
  end

  context 'checked' do
    let(:template) {
      PDFRavager::Template.new do |t|
        t.check 'CheckBox1'
      end
    }
    let(:expected) { File.join(File.dirname(__FILE__), "checked.png") }

    it 'matches checked.png when rendered' do
      pix_diff, _ = compare_pdf_to_png(ravage_to_temp_file(template, input_pdf), expected)
      expect(pix_diff).to eq(0)
    end
  end
end
