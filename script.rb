require './scrape.rb'

source = [
  ["http://fitc.ca/event/to14/schedule/?show=14924", 1],
  ["http://fitc.ca/event/to14/schedule/?show=14925", 2],
  ["http://fitc.ca/event/to14/schedule/?show=14926", 3],
  ["http://fitc.ca/event/to14/schedule/?show=14927", 4]
]

source.each do |url, day|
  x = ScrapeFitc.new(url, day)
  x.build_sessions

  File.open("./json/temp-#{day}.json","w") do |f|
    f.write(x.sessions)
  end
end



