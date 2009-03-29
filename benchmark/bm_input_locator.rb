require File.dirname(__FILE__) + "/loader"

browser = create_browser
browser.goto(HTML_DIR + "/forms_with_input_elements.html")

TESTS = 1000
res = Benchmark.bmbm do |results|
  results.report("text input by id (String)") do
    TESTS.times { browser.text_field(:id, "new_user_first_name").exists? }
  end
  results.report("text input by id (Regexp)") do
    TESTS.times { browser.text_field(:id, /first_name/).exists? }
  end
  results.report("text input by name (String)") do
    TESTS.times { browser.text_field(:name, "new_user_email").exists? }
  end
  results.report("text input by name (Regexp)") do
    TESTS.times { browser.text_field(:name, /user_email/).exists? }
  end

  results.report("select list by id (String)") do
    TESTS.times { browser.select_list(:id, 'new_user_country').exists? }
  end
  results.report("select list by id (Regexp)") do
    TESTS.times { browser.select_list(:id, /user_country/).exists? }
  end
  results.report("select list by name (String)") do
    TESTS.times { browser.select_list(:name, 'new_user_country').exists? }
  end
  results.report("select list by name (Regexp)") do
    TESTS.times { browser.select_list(:name, /user_country/).exists? }
  end

  results.report("checkbox by id (String)") do
    TESTS.times { browser.checkbox(:id, 'new_user_interests_books').exists? }
  end
  results.report("checkbox by id (Regexp)") do
    TESTS.times { browser.checkbox(:id, /interests_books/).exists? }
  end

  results.report("checkbox by name (String)") do
    TESTS.times { browser.checkbox(:name, 'new_user_interests').exists? }
  end
  results.report("checkbox by name (Regexp)") do
    TESTS.times { browser.checkbox(:name, /user_interests/).exists? }
  end

  results.report("checkbox by id (String) and value (String)") do
    TESTS.times { browser.checkbox(:id, 'new_user_interests_books', 'cars').exists? }
  end
  results.report("checkbox by id (Regexp) and value (Regexp)") do
    TESTS.times { browser.checkbox(:id, /interests_books/, /car/).exists? }
  end

  results.report("checkbox by name (String) and value (String)") do
    TESTS.times { browser.checkbox(:name, 'new_user_interests', 'dancing').exists? }
  end
  results.report("checkbox by name (Regexp) and value (Regexp)") do
    TESTS.times { browser.checkbox(:name, /user_interests/, /danc/).exists? }
  end



end

puts
total = res.inject(0.0) { |mem, bm| mem + bm.real }
puts "total  : " + total.to_s
puts "average: " + (total/res.size.to_f).to_s