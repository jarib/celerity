require File.expand_path("../spec_helper", __FILE__)

WatirSpec.implementation do |imp|
  imp.name          = :celerity
  imp.browser_class = Celerity::Browser
  imp.browser_args  = [{ :log_level => $DEBUG ? :all : :off }]
end
