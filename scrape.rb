require 'open-uri'
require 'nokogiri'

class SessionsScrape
  attr_accessor :page_url

  def get_page
    @page = Nokogiri::HTML(open(@page_url))
  end

  def get_rows
    @rows = @page.css('.row')
  end

  def build_items

    items = Array.new
    $id = 0
    @rows.each do |row|
      timebox    = row.css('.timebox')
      starttime  = timebox.css('.starttime').text
      endtime    = timebox.css('.endtime').text
      sessions   = row.css('.sbox')

      sessions.each do |s|
        item = Hash.new
        item[:id]        = $id
        item[:title]     = s.css('.title').text.strip
        item[:speakers]  = s.css('.speakers').text.strip
        item[:starttime] = starttime
        item[:endtime]   = endtime
        # datadump[id][title] => title
        items << item
        $id += 1
      end
    end
    items.each do |item|
      puts "#{item[:id]} #{item[:title]}"
      puts "\tStarts: #{item[:starttime]} Ends: #{item[:endtime]}\n"
    end
  end

end

