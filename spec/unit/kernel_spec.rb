require File.dirname(__FILE__) + '/unit_helper'
require 'pdf_ravager/kernel'

describe Kernel do
  let(:template) {
    pdf do |p|
      p.text      'text',        'foo'
      p.rich_text 'rich_text',   '<b>foo</b>'
      p.check     'checkbox1'
      p.uncheck   'checkbox2'
      p.fill      'radio_group', 'button'
    end
  }

  let(:longform_template) {
    PDFRavager::Template.new do |t|
      t.text      'text',        'foo'
      t.rich_text 'rich_text',   '<b>foo</b>'
      t.check     'checkbox1'
      t.uncheck   'checkbox2'
      t.fill      'radio_group', 'button'
    end
  }

  context 'equality' do
    context 'a shorthand and longform template with equal options' do
      it 'is equal' do
        expect(template).to eq(longform_template)
      end
    end
  end

end
