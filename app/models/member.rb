class Member < ApplicationRecord
  require 'open-uri'
  include ShortestPath::Member

  has_many :headings
  has_many :friendships, :foreign_key => "person_id", :class_name => "Friendship"
  has_many :friends, :through => :friendships
  before_save :shorten_url
  after_create :parse_url

  validates :name, :url, presence: true
  validate :valid_url

  def befriend(member)
    return false unless can_be_befriended?(member)
    self.friends << member
    member.friends << self
  end

  protected

  def can_be_befriended?(member)
    errors.add(:base, "cannot be yourself") if self == member
    self != member
  end

  def parse_url
    page = Nokogiri::HTML(open(url))
    page.css('h1,h2,h3').each do |h1|
      headings << Heading.create!(heading: h1.text.strip, member: self)
    end
  rescue StandardError => e
    errors.add(:base, e.message)
    false
  end

  def shorten_url
    self.url_short =  ShortURL.shorten(url)
  rescue StandardError => e
    errors.add(:base, e.message)
    false
  end

  def valid_url
    open(url).status == ["200", "OK"]
  rescue StandardError => e
    errors.add(:url, 'invalid')
    false
  end
end
