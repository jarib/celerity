require 'fileutils'
include FileUtils

require 'rubygems'
%w[rake hoe].each do |req_gem|
    require req_gem
end

$:.unshift(File.join(File.dirname(__FILE__), %w[.. lib]))
