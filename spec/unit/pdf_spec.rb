require File.dirname(__FILE__) + '/unit_helper'
require 'pdf_ravager/pdf'

class TestPDF < MiniTest::Unit::TestCase
  def setup
    @pdf = pdf 'foo.pdf' do
      text  'text',      'foo'
      text  'rich_text', '<b>foo</b>', :rich => true
      check 'checkbox'
      checkbox_group 'checkbox_group' do
        check 'foo'
      end
      radio_group 'radio_group' do
        fill 'foo'
      end
    end

    @pdf_from_json = JSON.parse(@pdf.to_json)
  end

  def test_that_name_is_set
    assert_equal @pdf.name, 'foo.pdf'
  end

  def test_that_text_is_set
    assert_includes @pdf.fields, {:name => 'text', :value => 'foo', :type => :text}
  end

  def test_that_rich_text_is_set
    assert_includes @pdf.fields, {:name => 'rich_text', :value => '<b>foo</b>', :type => :text, :options => {:rich => true}}
  end

  def test_that_checkbox_is_set
    assert_includes @pdf.fields, {:name => 'checkbox', :value => true, :type => :checkbox}
  end

  def test_that_checkbox_group_is_set
    assert_includes @pdf.fields, {:name => 'checkbox_group.foo', :value => true, :type => :checkbox}
  end

  def test_that_radio_group_is_set
    assert_includes @pdf.fields, {:name => 'radio_group', :value => 'foo', :type => :radio}
  end

  def test_json_serialization
    assert_equal @pdf, @pdf_from_json
  end
end
