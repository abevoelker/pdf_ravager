require File.dirname(__FILE__) + '/unit_helper'
require 'pdf_ravager/kernel'

class TestKernelIntegration < MiniTest::Unit::TestCase

  def setup
    @template = pdf do |p|
      p.text      'text',        'foo'
      p.rich_text 'rich_text',   '<b>foo</b>'
      p.check     'checkbox1'
      p.uncheck   'checkbox2'
      p.fill      'radio_group', 'button'
    end
  end

  def test_that_dsl_template_equals_longform_template
    template = PDFRavager::Template.new do |t|
      t.text      'text',        'foo'
      t.rich_text 'rich_text',   '<b>foo</b>'
      t.check     'checkbox1'
      t.uncheck   'checkbox2'
      t.fill      'radio_group', 'button'
    end
    assert_equal @template, template
  end

end
