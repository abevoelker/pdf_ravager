require File.dirname(__FILE__) + '/../integration_helper'

describe 'a PDF with a text field' do
  let(:input_pdf) { File.join(File.dirname(__FILE__), "pdf") }

  context 'filled with foo' do
    let(:template) {
      PDFRavager::Template.new do |t|
        t.text 'text_field', 'foo'
      end
    }
    let(:expected) { File.join(File.dirname(__FILE__), "expected.png") }

    it 'matches expected.png when rendered' do
      pix_diff, _ = compare_pdf_to_png(ravage_to_temp_file(template, input_pdf), expected)
      expect(pix_diff).to eq(0)
    end
  end
end
