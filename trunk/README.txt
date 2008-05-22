= Celerity

* http://celerity.rubyforge.org/

== DESCRIPTION:

        Celerity is a JRuby library for easy and fast functional test automation for web applications. It is a wrapper around the HtmlUnit Java library and is currently aimed at providing the same API and functionality as Watir.

== FEATURES:

* Fast: No time-consuming GUI rendering or unessential downloads
* Scalable: Java threads lets you run tests in parallel
* Easy to use: Simple API
* Portable: Cross-platform
* Unintrusive: No browser window interrupting your workflow (runs in background)

== SYNOPSIS:

	require 'rubygems'
	require 'celerity'
	
	browser = Celerity::IE.new
	browser.goto("google.com")
	browser.text_field(:name, 'q').set("celerity")
	browser.button(:name, 'btnG').submit
	
== REQUIREMENTS:

* JRuby 1.1
	
* Java 6

== INSTALL:

* jruby -S gem install celerity

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