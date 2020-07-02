class Member < ApplicationRecord
  require 'open-uri'

  has_many :headings
  has_many :friendships, :foreign_key => "person_id", :class_name => "Friendship"
  has_many :friends, :through => :friendships

  after_create :parse_url


  def befriend(member)
    # TODO: put in check that association does not exist
    self.friends << member
    member.friends << self
  end


  def parse_url
    page = Nokogiri::HTML(open(url))
    page.css('h1,h2,h3').each do |h1|
      headings << Heading.create!(heading: h1.text.strip, member: self)
    end
  end
end
