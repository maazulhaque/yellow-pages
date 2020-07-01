class Member < ApplicationRecord
  has_many :headings
  has_many :friendships, :foreign_key => "person_id", :class_name => "Friendship"
  has_many :friends, :through => :friendships


  def befriend(member)
    # TODO: put in check that association does not exist
    self.friends << member
    member.friends << self
  end
end
