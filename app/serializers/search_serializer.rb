class SearchSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name

  attribute :connection do |object, params|
    object.shortest_path(params[:member])
  end
end
