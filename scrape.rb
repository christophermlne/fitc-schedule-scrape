require 'open-uri'
require 'nokogiri'
require 'json'

class ScrapeFitc
  attr_accessor :page_url
  attr_reader   :sessions

  def get_page
    @page = Nokogiri::HTML(open(@page_url))
  end

  def get_rows
    return puts "Error: No content. Use get_page to get the page content." if @page.nil?
    @rows = @page.css('.row')
  end

  def build_items

    return puts "Error: No content. Use get_page to get the page content." if @page.nil?
    return puts "Error: No rows. Use get_rows to get the content rows." if @rows.nil?

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
        item[:link]      = s['href']
        item[:speakers]  = s.css('.speakers').text.gsub("\n","").gsub(/[\s]{2}/, "").gsub("with ", "")
        item[:starttime] = starttime
        item[:endtime]   = endtime
        items << item
        $id += 1
      end
    end
    @sessions = items.map { |o| Hash[o.each_pair.to_a] }.to_json
  end
end

