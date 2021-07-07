require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    scraped_students = []
    index_page = Nokogiri::HTML(open(index_url))
    index_page.css("div.roster-cards-container").each do |profile|
      profile.css(".student-card a").each do |student|
        student_name = student.css(".student-name").text
        student_link = "#{student.attr('href')}"
        student_location = student.css(".student-location").text

    
    scraped_students << {name: student_name, location: student_location, profile_url: student_link }
      end
    end
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    student_profile = {}
    profile_page = Nokogiri::HTML(open(profile_url))
    social_media_links = profile_page.css(".social-icon-container").children.css("a").map { |sml| sml.attribute("href").value }
    social_media_links.each do |link|
      if link.include?("linkedin")
        student_profile[:linkedin] = link
      elsif link.include?("twitter")
        student_profile[:twitter] = link
      elsif link.include?("github")
        student_profile[:github] = link
      else student_profile[:blog] = link
      end
    end
      student_profile[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
      student_profile[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")

    student_profile
  end
end
