require 'nokogiri'
require 'open-uri'

class Scraper
  index_url = 'https://learn-co-curriculum.github.io/student-scraper-test-page/index.html'
    
  def self.scrape_index_page(index_url)
    students_array = []
    
    doc = Nokogiri::HTML(open(index_url))
    array = doc.css(".student-card").collect do |student|
     hash = {
      
      name: student.css(".student-name").text,
      location: student.css(".student-location").text,
      profile_url: student.css('a')[0]['href']
      
     }
    students_array << hash
    end
    students_array 
  end

  def self.scrape_profile_page(profile_url)
    students_hash = {}
    doc = Nokogiri::HTML(open(profile_url)) 
    doc.css(".social-icon-container a").map do |student|
      website = student.attribute('href').value
      if website.include?("twitter")
        students_hash[:twitter] = website
      elsif website.include?("linkedin")
        students_hash[:linkedin] = website
        elsif website.include?("github")
          students_hash[:github] = website
        else
          students_hash[:blog] = website
        end
      end
        if doc.css('.profile-quote')
          students_hash[:profile_quote] = doc.css('.profile-quote').text
        end
        if doc.css(".description-holder")[0].children[1]
          students_hash[:bio] = doc.css(".description-holder")[0].children[1].text
        end  
      students_hash
  end
end