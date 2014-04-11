class NewslettersController < ApplicationController
  slimmer_template :www

  def index
    @newsletter = Newsletters.new
  end

  def create
    @newsletter = Newsletters.new(email:      params[:email],
                                 first_name:  params[:first_name],
                                 last_name:   params[:last_name],
                                 format:      params[:format],
                                 newsletters: params[:newsletters])
    @newsletter.subscribe!
  end

end
