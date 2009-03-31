require File.dirname(__FILE__) + "/loader"

TESTS = 5
res = Benchmark.bmbm do |results|
  results.report("Diggs on front page") do
    TESTS.times do
      # Create browser object
      browser = create_browser

      # Go to digg.com
      browser.goto('http://digg.com/')

      # Gather statistics
      total_diggs = 0
      digg_number_elements = browser.links.select { |link| link.id =~ /diggs/ }
      digg_numbers = digg_number_elements.collect { |digg_number_element| digg_number_element.text }
      digg_numbers.each { |digg_number| total_diggs += digg_number.to_i }
      #puts "Found #{digg_numbers.size} stories, with a total of #{total_diggs} diggs."
    end
  end
end

puts
total = res.inject(0.0) { |mem, bm| mem + bm.real }
puts "total  : " + total.to_s
puts "average: " + (total/res.size.to_f).to_s