require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    student_list = doc.css("div.student-card")

     student_list.map { |student|
      new_student = {
        :name => student.css("a div.card-text-container h4").text.strip,
        :location => student.css("a div.card-text-container p").text.strip,
        :profile_url => student.css("a").first.attributes['href'].value.strip
      }
    }
    # binding.pry
  end

  def self.scrape_profile_page(profile_url)
    student_page = Nokogiri::HTML(open(profile_url))
    social_media_info = student_page.css("div.main-wrapper div.vitals-container div.social-icon-container").first
    social_media_info = social_media_info.children.each.collect {|child| child['href']}.compact

    student = {}

    social_media_info.each { |info|
      if info.include?("twitter")
        student[:twitter] = info
      elsif info.include?("linkedin")
        student[:linkedin] = info
      elsif info.include?("github")
        student[:github] = info
      else
        student[:blog] = info
      end
    }
    student[:profile_quote] = student_page.css("div.main-wrapper div.vitals-container div.vitals-text-container div.profile-quote").text
    student[:bio] = student_page.css("div.main-wrapper div.details-container div.bio-block div.bio-content div.description-holder p").text
    student
  end

end
