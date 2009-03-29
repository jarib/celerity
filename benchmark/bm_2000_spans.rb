require File.dirname(__FILE__) + "/loader"

# Create browser object
browser = create_browser
browser.goto(HTML_DIR + "/2000_spans.html")

TESTS = 100
res = Benchmark.bmbm do |results|
  results.report("Loop through all spans (n = 1)") do
    1.times do # Hard coded 1 run
      browser.spans.each do |span|
        span.text
      end
    end
  end

#  results.report("Loop through all spans (raw)") do
#    TESTS.times do
#      if RUBY_PLATFORM =~ /java/
#        browser.document.getHtmlElementsByTagName("span").each do |span|
#          span.asText
#        end
#      else
#        browser.document.getElementsByTagName("span").each do |span|
#          span.innerText
#        end
#      end
#    end
#  end

  results.report("Last span by id (String)") do
    TESTS.times do
      browser.span(:id, "id_2000").exists?
    end
  end

  results.report("Last span by id (Regexp)") do
    TESTS.times do
      browser.span(:id, "/2000/").exists?
    end
  end

end

puts
total = res.inject(0.0) { |mem, bm| mem + bm.real }
puts "total  : " + total.to_s
puts "average: " + (total/res.size.to_f).to_s