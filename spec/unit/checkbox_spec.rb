require File.dirname(__FILE__) + '/unit_helper'
require 'pdf_ravager/template'

class TestCheckbox < MiniTest::Unit::TestCase

  def setup
    @checked   = PDFRavager::Fields::Checkbox.new('checkbox1', true,  :true_value => 'foo', :false_value => 'bar')
    @unchecked = PDFRavager::Fields::Checkbox.new('checkbox2', false, :true_value => 'foo', :false_value => 'bar')
  end

  def test_that_custom_checked_acro_form_value_is_set
    assert_equal @checked.acro_form_value, 'foo'
  end

  def test_that_custom_checked_xfa_value_is_set
    assert_equal @checked.xfa_value, 'foo'
  end

  def test_that_custom_unchecked_acro_form_value_is_set
    assert_equal @unchecked.acro_form_value, 'bar'
  end

  def test_that_custom_unchecked_xfa_value_is_set
    assert_equal @unchecked.xfa_value, 'bar'
  end

end
