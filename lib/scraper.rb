require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

    def self.scrape_index_page(index_url)
      # scrapped_students = Nokogiri::HTML(open("#{index_url}"))
      doc = Nokogiri::HTML(open(index_url))
      students = []

      doc.css('div.student-card').each do |student|
        name = student.css('.student-name').text
        location = student.css('.student-location').text
        profile_url = student.css('a').attribute('href').value
        student_info = {
          :name => name,
          :location => location, 
          :profile_url => profile_url
        }
        
        students << student_info
      end 
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student_profile = {}

    container = doc.css('div.social-icon-container a').map{|icon| icon.attribute('href').value}
    
    container.each do |link|
      if link.include?('twitter')
        student_profile[:twitter] = link 
      elsif link.include?('linkedin')
        student_profile[:linkedin] = link 
      elsif link.include?('github')
        student_profile[:github] = link
      elsif link.include?('.com')
        student_profile[:blog] = link
      end
    end
    student_profile[:bio] = doc.css('div.description-holder p').text
    student_profile[:profile_quote] = doc.css('.profile-quote').text
    student_profile
  end
end