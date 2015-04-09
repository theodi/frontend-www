require 'gds_api/helpers'
require 'gds_api/content_api'

class TagController < ApplicationController
  slimmer_template :www

  def index
    # TODO: this needs to be made more robust.
    if params[:tag] && params[:tag] != ''
      @joined_tags = params[:tag].split('/')
      @options = { keyword: @joined_tags.join(',').to_s }
      begin
        @artefacts = content_api.with_tag('', @options).results
      rescue GdsApi::HTTPNotFound
        @artefacts = []
      end
      @artefacts = @artefacts.reject do |artefact|
        doesnotexist = false

        # The second that a joined tag isn't in tag_ids,
        # we need to reject the artefact

        # All the joined tags are represented.
        @joined_tags.each do |tag|
          unless artefact.tag_ids.include? tag
            doesnotexist = true
          end
        end
        doesnotexist
      end
    else
      @artefacts = []
    end
    @title = 'Tags'
    @section = 'tags'
    respond_to do |format|
      format.html do
        render "list/tags"
      end
      format.json do
        render json: @artefacts.to_json
      end
      format.atom do
        render "list/tags", layout: false
      end
    end
  end
end
