require './scrape.rb'

x = ScrapeFitc.new
x.page_url = "http://fitc.ca/event/to14/schedule/?show=14925"
x.get_page
x.get_rows
x.build_items

puts x.sessions # should be valid json
