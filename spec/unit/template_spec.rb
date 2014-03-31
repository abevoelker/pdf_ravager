require File.dirname(__FILE__) + '/unit_helper'

describe PDFRavager::Template do

  context 'initialization' do
    context 'template with a name' do
      let(:template) { PDFRavager::Template.new('template') }

      it 'sets the name' do
        expect(template.name).to eq('template')
      end
    end

    context 'template without a name' do
      let(:template) { PDFRavager::Template.new }

      it 'does not set the name' do
        expect(template.name).to be_nil
      end
    end

    context 'setting strategy' do
      context 'with a valid strategy' do
        let(:template) { PDFRavager::Template.new(:strategy => :xfa) }

        it 'sets the strategy' do
          expect(template.strategy).to eq(:xfa)
        end
      end

      context 'with an invalid strategy' do
        it 'raises an error' do
          expect { PDFRavager::Template.new(:strategy => :foo) }.to raise_error
        end
      end
    end
  end

  context 'setting template values' do

    let(:template) {
      PDFRavager::Template.new do |t|
        t.text      'text',        'foo'
        t.rich_text 'rich_text',   '<b>foo</b>'
        t.check     'checkbox1'
        t.uncheck   'checkbox2'
        t.checkbox_group 'cbox_group' do |cb|
          cb.check   'checked'
          cb.uncheck 'unchecked'
        end
        t.fill      'radio_group', 'button'
        t.radio_group 'better_radio_group' do |rg|
          rg.fill 'button'
        end
      end
    }

    context 'text' do
      it 'is set' do
        expect(template.fields).to include(PDFRavager::Fields::Text.new('text', 'foo'))
      end
    end

    context 'rich_text' do
      it 'is set' do
        expect(template.fields).to include(PDFRavager::Fields::RichText.new('rich_text', '<b>foo</b>'))
      end
    end

    context 'checkbox1' do
      it 'is set' do
        expect(template.fields).to include(PDFRavager::Fields::Checkbox.new('checkbox1', true))
      end
    end

    context 'checkbox2' do
      it 'is unset' do
        expect(template.fields).to include(PDFRavager::Fields::Checkbox.new('checkbox2', false))
      end
    end

    context 'cbox_group' do
      context '.checked' do
        it 'is checked' do
          expect(template.fields).to include(PDFRavager::Fields::Checkbox.new('cbox_group.checked', true))
        end
      end

      context '.unchecked' do
        it 'is unchecked' do
          expect(template.fields).to include(PDFRavager::Fields::Checkbox.new('cbox_group.unchecked', false))
        end
      end
    end

    context 'radio buttons' do
      context 'one-line syntax' do
        it 'fills the radio_group button' do
          expect(template.fields).to include(PDFRavager::Fields::Radio.new('radio_group', 'button'))
        end
      end

      context 'block syntax' do
        it 'fills the better_radio_group button' do
          expect(template.fields).to include(PDFRavager::Fields::Radio.new('better_radio_group', 'button'))
        end
      end
    end
  end

end
