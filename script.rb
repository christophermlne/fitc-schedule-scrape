require './scrape.rb'

x = SessionsScrape.new
x.page_url = "http://fitc.ca/event/to14/schedule/?show=14925"
x.get_page
x.get_rows
x.build_items
