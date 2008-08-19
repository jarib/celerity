= Celerity

* http://celerity.rubyforge.org/

== TUTORIAL:

* http://celerity.rubyforge.org/wiki/wiki.pl?GettingStarted

== DESCRIPTION:

Celerity is a JRuby library for easy and fast functional test automation for web applications.
It is a wrapper around the HtmlUnit Java library and is currently aimed at providing the same API and functionality as Watir.

== FEATURES:

* Fast: No time-consuming GUI rendering or unessential downloads
* Scalable: Java threads lets you run tests in parallel
* Easy to use: Simple API
* Portable: Cross-platform
* Unintrusive: No browser window interrupting your workflow (runs in background)
	
== REQUIREMENTS:

* JRuby 1.1 or higher
* Java 6

== INSTALL:

  `jruby -S gem install celerity`
  
  
== EXAMPLE:

  require "rubygems"
  require "celerity" 

  browser = Celerity::Browser.new
  browser.goto('http://www.google.com')
  browser.text_field(:name, 'q').value = 'Celerity'
  browser.button(:name, 'btnG').click

  puts "yay" if browser.text.include? 'celerity.rubyforge.org'
  
== GIT

The project is manually mirrored @ http://github.com/jarib/celerity/tree/master 

== LICENSE:

Celerity - JRuby wrapper for HtmlUnit
Copyright (c) 2008 FINN.no AS

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.