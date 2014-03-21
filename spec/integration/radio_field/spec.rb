require File.dirname(__FILE__) + '/../integration_helper'

describe 'a PDF with a radio field' do
  let(:input_pdf) { File.join(File.dirname(__FILE__), "pdf") }

  context 'with nothing filled in' do
    let(:template) {
      PDFRavager::Template.new
    }
    let(:expected) { File.join(File.dirname(__FILE__), "empty.png") }

    it 'matches empty.png when rendered' do
      pix_diff, _ = compare_pdf_to_png(ravage_to_temp_file(template, input_pdf), expected)
      expect(pix_diff).to eq(0)
    end
  end

  context 'with "Yes" filled in' do
    let(:template) {
      PDFRavager::Template.new do |t|
        t.fill 'RadioButtonList', 'Yes'
      end
    }
    let(:expected) { File.join(File.dirname(__FILE__), "yes.png") }

    it 'matches yes.png when rendered' do
      pix_diff, _ = compare_pdf_to_png(ravage_to_temp_file(template, input_pdf), expected)
      expect(pix_diff).to eq(0)
    end
  end

  context 'with "No" filled in' do
    let(:template) {
      PDFRavager::Template.new do |t|
        t.fill 'RadioButtonList', 'No'
      end
    }
    let(:expected) { File.join(File.dirname(__FILE__), "no.png") }

    it 'matches no.png when rendered' do
      pix_diff, _ = compare_pdf_to_png(ravage_to_temp_file(template, input_pdf), expected)
      expect(pix_diff).to eq(0)
    end
  end
end
