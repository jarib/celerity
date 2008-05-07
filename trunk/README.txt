= Celerity

* http://celerity.rubyforge.org/

== DESCRIPTION:

	Celerity is a JRuby/RJB wrapper around the HtmlUnit Java library (http://htmlunit.sourceforge.net/).
	The goal of the project is to implement the Watir API (http://wtf.rubyforge.org/) on top of HtmlUnit.

== FEATURES/PROBLEMS:

* FIX (list of features or problems)

== SYNOPSIS:

	require 'rubygems'
	require 'celerity'
	
	browser = Celerity::IE.new
	browser.goto("google.com")
	browser.text_field(:name, 'q').set("celerity")
	browser.button(:name, 'btnG').submit
	
== REQUIREMENTS:

* JRuby 1.1
	
	or 

* Ruby Java Bridge (on MRI)

NOTE: RJB currently has problems with threading. Use JRuby if you want to run your tests concurrently. 

== INSTALL:

* jruby -S gem install celerity

	or
	
* (sudo) gem install rjb celerity

== LICENSE:

Celerity - JRuby wrapper for HtmlUnit
Copyright (c) 2008 FinnTech AS

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