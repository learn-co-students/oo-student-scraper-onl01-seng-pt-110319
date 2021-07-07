require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student_info=[]
    web = Nokogiri::HTML(open(index_url))
    roster = web.css(".student-card")
    roster.each do |info|
      student_info << {:name=>info.css("h4").text,:location=>info.css("p").text,:profile_url=>info.xpath('a').attr('href').text.strip}
    end
    student_info
  end


  def self.scrape_profile_page(profile_url)

    student_info = {}

    web = Nokogiri::HTML(open(profile_url))
    web.css("div.social-icon-container a").each do |info|
        url = info.attribute("href").value
        student_info[:twitter] = url if url.include?("twitter")
        student_info[:linkedin] = url if url.include?("linkedin")
        student_info[:github] = url if url.include?("github")
        student_info[:blog] = url if info.css("img").attribute("src").text.include?("rss")
    end
        student_info[:profile_quote] = web.css("div.profile-quote").text
        student_info[:bio] = web.css("div.bio-content p").text
    student_info
  end
end