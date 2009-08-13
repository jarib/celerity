Celerity
========

* [http://celerity.rubyforge.org/](http://celerity.rubyforge.org/)

Description
------------

Celerity is a JRuby wrapper around HtmlUnit – a headless Java browser with 
JavaScript support. It provides a simple API for programmatic navigation through
web applications. Celerity aims at being API compatible with Watir.

Features
--------

* *Fast*: No time-consuming GUI rendering or unessential downloads
* *Scalable*: Java threads lets you run tests in parallel
* *Easy to use*: Simple API
* *Portable*: Cross-platform thanks to the JVM
* *Unintrusive*: No browser window interrupting your workflow (runs in background)
	
Requirements
------------

* JRuby 1.2.0 or higher
* Java 6

Install
-------

    `jruby -S gem install celerity`
  
  or from GitHub (updated frequently)
  
    `jruby -S gem install jarib-celerity`
  
  
Example
-------

    require "rubygems"
    require "celerity" 

    browser = Celerity::Browser.new
    browser.goto('http://www.google.com')
    browser.text_field(:name, 'q').value = 'Celerity'
    browser.button(:name, 'btnG').click

    puts "yay" if browser.text.include? 'celerity.rubyforge.org'
  
Source
------

The source code is available on [GitHub](http://github.com/jarib/celerity/tree/master).


Wiki & Bug Tracker
-------------------

* [Wiki](http://github.com/jarib/celerity/wikis)
* [Bug Tracker](http://github.com/jarib/celerity/issues)

Related projects
----------------

* [WatirSpec](http://github.com/jarib/watirspec/tree/master)
* [Celerity Viewers](http://github.com/jarib/celerity-viewers)

License
-------

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