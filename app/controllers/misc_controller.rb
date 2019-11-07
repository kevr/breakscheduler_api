class MiscController < ApplicationController
  def not_found
    respond_to do |format|
      format.html {
        render "not_found", status: :not_found
      }
      format.json {
        render json: {
          error: "Endpoint not found"
        }, status: :not_found
      }
    end
  end
end
