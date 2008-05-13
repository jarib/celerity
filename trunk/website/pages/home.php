                <a href="http://rubyforge.org/frs/?group_id=6198" id="download" title="Latest version: 0.0.1">Download &#x2192;</a>

                <h2>What is Celerity?</h2>
                <p>Celerity is a <a href="http://jruby.codehaus.org/">JRuby</a> library for easy and fast functional test automation for web applications. It is a wrapper around the <a href="http://htmlunit.sourceforge.net/">HtmlUnit</a> Java library and is currently aimed at providing the same API and functionality as <a href="http://wtr.rubyforge.org/">Watir</a>.</p>
                
                <h2>Features</h2>
                <ul>
                    <li>Fast: No time-consuming GUI rendering or unessential downloads</li>
                    <li>Scalable: Java threads lets you run tests in parallel</li>
                    <li>Easy to use: Simple API</li>
                    <li>Portable: Cross-platform</li>
                    <li>Unintrusive: No browser window interrupting your workflow (runs in background)</li>
                </ul>
                
                <h2>Requirements</h2>
                <ul>
                    <li>JRuby 1.1</li>
                    <li>Java 6</li>
                </ul>
                
                <h2>Background</h2>
                <p><a href="http://www.finn.no/">FINN.no</a> is a top provider of online classifieds in Europe. Consequently automated functional testing is an essential part of our quality assurance effort. As of spring 2008 our Watir test suite, consisting of 340 test cases (which only covers part of our application), completes in 3 hours. Obviously, not optimal for an agile development environment.</p>
                <p>We need a faster alternative. At the same time, we enjoy working with Ruby and Watir's API. By providing this API on top of HtmlUnit, we hope to significantly speed up test suite execution, while avoiding a rewrite of our existing test suite. <a href="?page=benchmarks">Early benchmarks</a> are available.</p>

                
                <h2>Installing Celerity</h2>
                <pre>
                <code>
jruby -S gem install celerity
                </code>
                </pre>

                <h2>Code example</h2>
                <pre>
                <code>
require "celerity" 

browser = Celerity::IE.new
browser.goto('http://www.google.com')
browser.text_field(:name, 'q').value = "Celerity" 
browser.button(:name, 'btnG').click

puts "yay" if browser.text.include? 'celerity.rubyforge.org'
                </code>
                </pre>

                <h2>How to submit patches</h2>
                <p>Read the <a href="http://drnicwilliams.com/2007/06/01/8-steps-for-fixing-other-peoples-code/">8 steps for fixing other people&#8217;s code</a>. The trunk repository is <code>svn://rubyforge.org/var/svn/celerity/trunk</code> for anonymous access. Failing specs for issues/features you don't know how to implement yourself are most welcome.</p>

                <h2>License</h2>
                <p>Celerity is licensed under the <a href="http://www.gnu.org/licenses/gpl-3.0.html">GPLv3 license</a>.</p>

                <h2>Contact</h2>
                <p>Comments are welcome. You can reach us through our <a href="http://rubyforge.org/mail/?group_id=6198">mailing lists</a>, our <a href="http://rubyforge.org/forum/?group_id=6198">forum</a>, or our individual email addresses below.</p>
                
                <h2>Developers</h2>
                <ul>
                    <li><a href="mailto:tinius.alexander@lystadonline.no">T. Alexander Lystad</a></li>
                    <li><a href="mailto:knut.johannes.dahle@gmail.com">Knut Johannes Dahle</a></li>
                    <li><a href="mailto:jari.bakken@finntech.no">Jari Bakken</a></li>
                </ul>