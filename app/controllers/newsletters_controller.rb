class NewslettersController < ApplicationController
  slimmer_template :www

  def index
    @newsletter = Newsletters.new(id: newsletter_id)
  end

  def create
    @newsletter = Newsletters.new(id:          params[:id],
                                  email:       params[:email],
                                  first_name:  params[:first_name],
                                  last_name:   params[:last_name])
    @newsletter.subscribe!
  end

  private

    def newsletter_id
      YAML.load_file("#{Rails.root.to_s}/config/newsletters.yml")[Rails.env][0]['id']
    end

end
