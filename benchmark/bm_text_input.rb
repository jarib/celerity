require File.dirname(__FILE__) + "/loader"

browser = create_browser
browser.goto(HTML_DIR + "/forms_with_input_elements.html")

TESTS = 10000
res = Benchmark.bmbm do |results|
  results.report("TextField#set") do
    TESTS.times { browser.text_field(:id, "new_user_first_name").set("1234567890") }
  end
  results.report("TextField#value=") do
    TESTS.times { browser.text_field(:id, "new_user_first_name").value = "1234567890" }
  end
end

puts
total = res.inject(0.0) { |mem, bm| mem + bm.real }
puts "total  : " + total.to_s
puts "average: " + (total/res.size.to_f).to_s