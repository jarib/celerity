require "benchmark"

require File.dirname(__FILE__) + "/../spec/spec_helper"

# Create browser object
browser = Watir::IE.new
browser.goto(TEST_HOST + "/2000_spans.html")

TESTS = 20 # 1000 Celerity runs: ~20 s | 20 Watir runs: ~24 s
res = Benchmark.bmbm do |results|
  results.report("Loop through all spans") do
    TESTS.times do
      browser.spans.each do |span|
        span
      end
    end
  end
  
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