require 'open-uri'
require 'nokogiri'
require 'json'

class ScrapeFitc
  attr_accessor :page_url, :conference_day, :with_description
  attr_reader   :sessions

  def initialize(page_url, conference_day)
    @page_url = page_url
    @conference_day = conference_day
  end

  def with_description
    @with_description || false
  end

  def build_sessions

    get_page
    get_rows

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
        item[:day]       = @conference_day
        item[:title]     = s.css('.title').text.strip
        item[:link]      = s['href']
        item[:speakers]  = s.css('.speakers').text.gsub("\n","").gsub(/[\s]{2}/, "").gsub("with ", "") # convert to lambda?
        item[:starttime] = starttime
        item[:endtime]   = endtime

        # get description
        if @with_description == true 
          item[:description] = Nokogiri::HTML(open(item[:link])).css('.single-overview') unless item[:link] == nil
        else
          item[:description] = "Skipped"
        end

        items << item
        $id += 1
      end
    end
    @sessions = items.map { |o| Hash[o.each_pair.to_a] }.to_json
  end

  private

  def get_page
    @page = Nokogiri::HTML(open(@page_url))
  end

  def get_rows
    return puts "Error: No content. Use get_page to get the page content." if @page.nil?
    @rows = @page.css('.row')
  end

end

