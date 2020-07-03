module ApiErrorResponses
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :render_500 if !Rails.env.development?
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record_error
  end

  protected

    def render_404
      render_error("Resource not found", 404)
    end

    def render_500(e)
      render_error(e.to_s || "Application error", 500)
    end

    def render_invalid_record_error(e)
      render_error("Invalid record", 422, messages: e.record.errors&.full_messages)
    end

    def render_errors(errors)
      errors = errors.to_h.merge(full_messages: errors.try(:full_messages))
      return render json: { errors: errors }, status: 422
    end

    def render_error(error_message, code, extras = {})
      return render json: { error: error_message }.merge(extras) , status: code
    end

    def render_401
      render_error("Unauthorized request", 401)
    end

    def render_422(e)
      render_error(e.to_s || "Unprocessable entity", 422)
    end
end
