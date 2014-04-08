class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

	def location
	  if params[:address].blank?
	    if Rails.env.test? || Rails.env.development?
	      @location ||= Geocoder.search("50.78.167.161").first
	    else
	      @location ||= request.location
	    end
	  else
	    @location ||= Geocoder.search(params[:address])
	    @location
	  end
	end

end
