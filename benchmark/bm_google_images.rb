require File.dirname(__FILE__) + "/loader"

TESTS = 5
res = Benchmark.bmbm do |results|
  results.report("Google image search results") do
    TESTS.times do
      # Create browser object
      browser = create_browser

      # Goto images.google.com
      browser.goto('http://images.google.com/ncr')

      # Search for Watir
      browser.text_field(:name, 'q').set('Watir')
      browser.button(:value, 'Search Images').click

      src_pool = []
      pages = 1
      # Gather statistics and click Next if there are more results
      while browser.link(:text, 'Next').exists?
        pages += 1
        browser.link(:text, 'Next').click unless src_pool.empty?
        table_cells = browser.cells.select { |cell| cell.id =~ /tDataImage\d+/ }
        table_cells.each do |cell|
          src_pool << cell.images.first.src if cell.images.first.exists?
        end
      end
      #puts "Looked at #{pages} pages of image search results. Got #{src_pool.size} images."
    end
  end
end

puts
total = res.inject(0.0) { |mem, bm| mem + bm.real }
puts "total  : " + total.to_s
puts "average: " + (total/res.size.to_f).to_s