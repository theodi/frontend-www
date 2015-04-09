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

      @artefacts = filter_artefacts(@artefacts, @joined_tags)
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

  protected

  def filter_artefacts(artefacts, joined_tags)
    artefacts.reject do |artefact|

      # The second that a joined tag isn't in tag_ids,
      # we need to reject the artefact

      # All the joined tags are represented.
      joined_tags.inject(false) do |truthy, tag|
        unless artefact.tag_ids.include? tag
          truthy = true
        end
      end
    end
  end
end
