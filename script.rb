require './scrape.rb'

source = [
  ["http://fitc.ca/event/to14/schedule/?show=14924", 1],
  ["http://fitc.ca/event/to14/schedule/?show=14925", 2],
  ["http://fitc.ca/event/to14/schedule/?show=14926", 3],
  ["http://fitc.ca/event/to14/schedule/?show=14927", 4]
]

source.each do |url, day|
  x = ScrapeFitc.new
  x.page_url = url
  x.conference_day = day
  x.get_page
  x.get_rows
  x.build_sessions

  puts x.sessions # should be valid json

  File.open("./json/temp-#{day}.json","w") do |f|
    f.write(x.sessions)
  end
end



