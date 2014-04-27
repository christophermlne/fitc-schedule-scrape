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
    @rows.each do |row|
      timebox = row.css('.timebox')
      starttime = timebox.css('.starttime').text
      endtime = timebox.css('.endtime').text

      sessions = row.css('.sbox')
      sessions.each do |session|
        title    = session.css('.title').text.strip
        speakers = session.css('.speakers').text.strip
        puts "Title: #{title}"
        puts "Speakers: #{speakers}"
      end
    end
  end

end

