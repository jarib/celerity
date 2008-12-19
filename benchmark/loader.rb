require 'benchmark'
require File.dirname(__FILE__) + "/../spec/spec_helper"

if RUBY_PLATFORM =~ /java/
  FRAMEWORK = Celerity
else
  require 'watir'
  FRAMEWORK = Watir
end