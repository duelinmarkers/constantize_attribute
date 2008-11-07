require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + '/../lib/constantize_attribute')

class FakeActiveRecordBase
  extend ConstantizeAttribute
  attr_reader :attributes

  def initialize
    @attributes = {}
  end

  def read_attribute att
    @attributes[att]
  end

  def write_attribute att, val
    @attributes[att] = val
  end
end

class SomeModel < FakeActiveRecordBase
  constantize_attribute :foo, :bar
end

module Foo; module Bar; end; end

class ConstantizeAttributeTest < Test::Unit::TestCase

  def test_writer_method_sets_to_s_of_supplied_value
    m = SomeModel.new
    m.foo = Foo::Bar
    assert_equal "Foo::Bar", m.attributes[:foo]
  end

  def test_reader_method_constantizes_string_value
    m = SomeModel.new
    m.attributes[:foo] = 'Foo::Bar'
    assert_equal Foo::Bar, m.foo
  end

  def test_passing_a_string_to_writer_still_results_in_reader_returning_the_constant
    m = SomeModel.new
    m.foo = "Foo::Bar"
    assert_equal Foo::Bar, m.foo
  end

  def test_supports_multiple_attributes_in_one_call
    m = SomeModel.new
    m.bar = Test::Unit::TestCase
    assert_equal 'Test::Unit::TestCase', m.attributes[:bar]
  end

  def test_constantize_attributes_is_the_same_as_constantize_attribute
    assert_equal ConstantizeAttribute.instance_method(:constantize_attribute), ConstantizeAttribute.instance_method(:constantize_attributes)
  end
end
