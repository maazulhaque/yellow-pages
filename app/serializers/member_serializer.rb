class MemberSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name,
            :url,
            :url_short


  attribute :headings do |object|
    object.headings.map(&:heading)
  end

  attribute :friends do |object|
    object.friends.map{|friend| {name: friend.name, url: friend.url}}
  end

end
