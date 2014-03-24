require File.dirname(__FILE__) + '/../integration_helper'

describe 'a PDF with a checkbox group' do
  let(:input_pdf) { File.join(File.dirname(__FILE__), "pdf") }

  context 'nothing checked' do
    let(:template) {
      PDFRavager::Template.new
    }
    let(:expected) { File.join(File.dirname(__FILE__), "unchecked.png") }

    it 'matches unchecked.png when rendered' do
      pix_diff, _ = compare_pdf_to_png(ravage_to_temp_file(template, input_pdf), expected)
      expect(pix_diff).to eq(0)
    end
  end

  context 'CheckBoxGroup.foo checked' do
    let(:template) {
      PDFRavager::Template.new do |t|
        t.checkbox_group 'CheckBoxGroup' do |g|
          g.check 'foo'
        end
      end
    }
    let(:expected) { File.join(File.dirname(__FILE__), "foo.png") }

    it 'matches foo.png when rendered' do
      pix_diff, _ = compare_pdf_to_png(ravage_to_temp_file(template, input_pdf), expected)
      expect(pix_diff).to eq(0)
    end
  end

  context 'CheckBoxGroup.bar checked' do
    let(:template) {
      PDFRavager::Template.new do |t|
        t.checkbox_group 'CheckBoxGroup' do |g|
          g.check 'bar'
        end
      end
    }
    let(:expected) { File.join(File.dirname(__FILE__), "bar.png") }

    it 'matches bar.png when rendered' do
      pix_diff, _ = compare_pdf_to_png(ravage_to_temp_file(template, input_pdf), expected)
      expect(pix_diff).to eq(0)
    end
  end
end
