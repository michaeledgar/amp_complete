# -*- coding: us-ascii -*-
##################################################################
#                  Licensing Information                         #
#                                                                #
#  The following code is licensed, as standalone code, under     #
#  the Ruby License, unless otherwise directed within the code.  #
#                                                                #
#  For information on the license of this code when distributed  #
#  with and used in conjunction with the other modules in the    #
#  Amp project, please see the root-level LICENSE file.          #
#                                                                #
#  © Michael J. Edgar and Ari Brown, 2009-2010                   #
#                                                                #
##################################################################

require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper'))
require 'amp-git/encoding/binary_delta'

class TestPackfileWithIndex < AmpTestCase
  include Amp::Core::Repositories::Git::Encoding
  
  def test_parse_numbers
    delta_str = "\x10\x20"
    input = BinaryDelta.new(delta_str)
    assert_equal 0x10, input.base_length
    assert_equal 0x20, input.result_length
  end
  
  def test_parse_longer_numbers
    delta_str = "\xA0\x73\xB0\x6F"
    input = BinaryDelta.new(delta_str)
    base = 0b11100110100000
    result = 0b11011110110000
    assert_equal base, input.base_length
    assert_equal result, input.result_length
  end
  
  def test_simple_duplicating_patch
    delta_str = "\x04\x08\x91\x00\x04\x91\x00\x04"
    input = "abcd"
    expected = "abcdabcd"
    assert_equal expected, BinaryDelta.new(delta_str).apply(input)
  end
  
  def test_patch_with_insert
    delta_str = "\x04\x14\x10hello, world!lol\x91\x00\x04"
    input = "abcd"
    expected = "hello, world!lolabcd"
    assert_equal expected, BinaryDelta.new(delta_str).apply(input)
  end
  
  def test_raises_on_mismatched_base_length
    delta_str = "\x04\x04"
    input = "abcdef"
    assert_raises DeltaError do
      BinaryDelta.new(delta_str).apply(input)
    end
  end
  
  def test_raises_on_mismatched_result_length
    delta_str = "\x04\x09\x91\x00\x04\x91\x00\x04"
    input = "abcd"
    assert_raises DeltaError do
      BinaryDelta.new(delta_str).apply(input)
    end
  end
end
