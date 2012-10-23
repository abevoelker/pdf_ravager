require 'spec_helper'
require 'pdf_ravager/pdf'

class TestPDF < MiniTest::Unit::TestCase
  def setup
    @pdf = pdf 'foo.pdf' do
      text 'text_always',       'foo'
      text 'text_when_true',    'foo', :when => true
      text 'text_when_false',   'foo', :when => false
      text 'text_if_true',      'foo', :if => true
      text 'text_if_false',     'foo', :if => false
      text 'text_unless_true',  'foo', :unless => true
      text 'text_unless_false', 'foo', :unless => false
      check 'checkbox'
      radio_group 'radio_group_always_filled' do
        fill 'foo'
      end
      radio_group 'radio_group_if' do
        fill 'true',  :if => true
        fill 'false', :if => false
      end
      radio_group 'radio_group_when' do
        fill 'true',  :when => true
        fill 'false', :when => false
      end
      radio_group 'radio_group_unless' do
        fill 'true',  :unless => true
        fill 'false', :unless => false
      end
      checkbox_group 'checkbox_group_always_checked' do
        check 'foo'
      end
      checkbox_group 'checkbox_group_if' do
        check 'true',  :if => true
        check 'false', :if => false
      end
      checkbox_group 'checkbox_group_when' do
        check 'true',  :when => true
        check 'false', :when => false
      end
      checkbox_group 'checkbox_group_unless' do
        check 'true',  :unless => true
        check 'false', :unless => false
      end
    end

    @pdf_from_json = JSON.parse(@pdf.to_json)
  end

  def test_that_name_is_set
    assert_equal @pdf.name, 'foo.pdf'
  end

  def test_that_text_is_set
    assert_includes @pdf.fields, {:name => 'text_always', :value => 'foo', :type => :text}
  end

  def test_that_text_when_true_is_set
    assert_includes @pdf.fields, {:name => 'text_when_true', :value => 'foo', :type => :text}
  end

  def test_that_text_when_false_is_not_set
    refute_includes @pdf.fields, {:name => 'text_when_false', :value => 'foo', :type => :text}
  end

  def test_that_text_if_true_is_set
    assert_includes @pdf.fields, {:name => 'text_if_true', :value => 'foo', :type => :text}
  end

  def test_that_text_if_false_is_not_set
    refute_includes @pdf.fields, {:name => 'text_if_false', :value => 'foo', :type => :text}
  end

  def test_that_text_unless_true_is_not_set
    refute_includes @pdf.fields, {:name => 'text_unless_true', :value => 'foo', :type => :text}
  end

  def test_that_text_unless_false_is_set
    assert_includes @pdf.fields, {:name => 'text_unless_false', :value => 'foo', :type => :text}
  end

  def test_that_checkbox_is_set
    assert_includes @pdf.fields, {:name => 'checkbox', :value => true, :type => :checkbox}
  end

  def test_that_radio_group_always_filled_is_filled
    assert_includes @pdf.fields, {:name => 'radio_group_always_filled.foo', :value => true, :type => :radio}
  end

  def test_that_radio_group_when_true_is_set
    assert_includes @pdf.fields, {:name => 'radio_group_when.true', :value => true, :type => :radio}
  end

  def test_that_radio_group_when_false_is_not_set
    refute_includes @pdf.fields, {:name => 'radio_group_when.false', :value => true, :type => :radio}
  end

  def test_that_radio_group_if_true_is_set
    assert_includes @pdf.fields, {:name => 'radio_group_if.true', :value => true, :type => :radio}
  end

  def test_that_radio_group_if_false_is_not_set
    refute_includes @pdf.fields, {:name => 'radio_group_if.false', :value => true, :type => :radio}
  end

  def test_that_radio_group_unless_true_is_not_set
    refute_includes @pdf.fields, {:name => 'radio_group_unless.true', :value => true, :type => :radio}
  end

  def test_that_radio_group_unless_false_is_set
    assert_includes @pdf.fields, {:name => 'radio_group_unless.false', :value => true, :type => :radio}
  end

  def test_that_checkbox_group_always_checked_is_checked
    assert_includes @pdf.fields, {:name => 'checkbox_group_always_checked.foo', :value => true, :type => :checkbox}
  end

  def test_that_checkbox_group_when_true_is_set
    assert_includes @pdf.fields, {:name => 'checkbox_group_when.true', :value => true, :type => :checkbox}
  end

  def test_that_checkbox_group_when_false_is_not_set
    refute_includes @pdf.fields, {:name => 'checkbox_group_when.false', :value => true, :type => :checkbox}
  end

  def test_that_checkbox_group_if_true_is_set
    assert_includes @pdf.fields, {:name => 'checkbox_group_if.true', :value => true, :type => :checkbox}
  end

  def test_that_checkbox_group_if_false_is_not_set
    refute_includes @pdf.fields, {:name => 'checkbox_group_if.false', :value => true, :type => :checkbox}
  end

  def test_that_checkbox_group_unless_true_is_not_set
    refute_includes @pdf.fields, {:name => 'checkbox_group_unless.true', :value => true, :type => :checkbox}
  end

  def test_that_checkbox_group_unless_false_is_set
    assert_includes @pdf.fields, {:name => 'checkbox_group_unless.false', :value => true, :type => :checkbox}
  end

  def test_json_serialization
    assert_equal @pdf, @pdf_from_json
  end
end
