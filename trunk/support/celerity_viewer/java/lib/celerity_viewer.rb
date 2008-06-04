$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'java'
Dir['lib/celerity_viewer/jar/*.jar'].each { |f| require(f) }

module LoboBrowser
  include_package "org.lobobrowser"
end

module Swing
  include_package "javax.swing"
end

require "drb"
require "drb/acl"
require "uri"

require "celerity_viewer/lobo_frame"
require "celerity_viewer/application"
require "celerity_viewer/distributed_viewer"


