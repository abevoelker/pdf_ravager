require File.dirname(__FILE__) + '/../integration_helper'

describe 'a PDF with a multiline text field' do
  let(:input_pdf) { File.join(File.dirname(__FILE__), "pdf") }

  context 'filled with FOO' do
    let(:template) {
      PDFRavager::Template.new do |t|
        t.text 'multilinetext', 'FOO' * 10000
      end
    }
    let(:expected) { File.join(File.dirname(__FILE__), "expected.png") }

    it 'matches expected.png when rendered' do
      pix_diff, _ = compare_pdf_to_png(ravage_to_temp_file(template, input_pdf), expected)
      expect(pix_diff).to eq(0)
    end
  end
end
