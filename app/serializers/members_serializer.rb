class MembersSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name,
             :url

  attribute :number_of_friends do |object|
    object.friends.count
  end
end
