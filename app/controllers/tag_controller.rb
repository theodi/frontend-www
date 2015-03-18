require 'gds_api/helpers'
require 'gds_api/content_api'

class TagController < ApplicationController
  slimmer_template :www

  def index
    # TODO: this needs to be made more robust.
    # Also needs to handle when there are no tags.
    @joined_tags = params[:tag].split('/').join(',')
    @options = { keyword: @joined_tags.to_s }
    @artifacts = content_api.with_tag('', @options).results
    render "list/tags"
  end
end
