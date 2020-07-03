class ApplicationController < ActionController::API
  include ApiErrorResponses

  def serialized(type, object, opts={})
    "#{type}Serializer".constantize.new(object, opts).serialized_json
  end
end
