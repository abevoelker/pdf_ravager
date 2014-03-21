require File.dirname(__FILE__) + '/fields_helper'

describe PDFRavager::Fields::Checkbox do

  let(:checked)   { PDFRavager::Fields::Checkbox.new('checkbox1', true,  :true_value => 'foo', :false_value => 'bar') }
  let(:unchecked) { PDFRavager::Fields::Checkbox.new('checkbox2', false, :true_value => 'foo', :false_value => 'bar') }

  context 'checked' do
    context 'AcroForm value' do
      it 'sets value properly' do
        expect(checked.xfa_value).to eq('foo')
      end
    end

    context 'XFA value' do
      it 'sets value properly' do
        expect(checked.xfa_value).to eq('foo')
      end
    end
  end

  context 'unchecked' do
    context 'AcroForm value' do
      it 'sets value properly' do
        expect(unchecked.xfa_value).to eq('bar')
      end
    end

    context 'XFA value' do
      it 'sets value properly' do
        expect(unchecked.xfa_value).to eq('bar')
      end
    end
  end

end
