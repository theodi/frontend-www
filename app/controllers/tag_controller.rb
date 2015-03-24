require 'gds_api/helpers'
require 'gds_api/content_api'

class TagController < ApplicationController
  slimmer_template :www

  def index
    # TODO: this needs to be made more robust.
    # Also needs to handle when there are no tags.
    @joined_tags = params[:tag].split('/').join(',')
    @options = { keyword: @joined_tags.to_s }
    @artefacts = content_api.with_tag('', @options).results
    @title = 'Tags'
    @section = 'tags'
    respond_to do |format|
      format.html do
        render "list/tags"
      end
      format.json do
        render json: @artifacts.to_json
      end
      format.atom do
        render "list/tags", layout: false
      end
    end
  end
end
