require 'gds_api/helpers'
require 'gds_api/content_api'

class TagController < ApplicationController
  slimmer_template :www

  def index
    joined_tags = params[:tag].split('/').join(',')
    # AND:
    # http://contentapi.dev/with_tag.json?keyword=data-as-culture&keyword=dac3
    # OR:
    # http://contentapi.dev/with_tag.json?keyword=data-as-culture,dac3
    @artifacts = content_api.with_tag('', { keyword: joined_tags.to_s }).results
    render "list/tags"
  end

  private

  def get_tag_ids
  end
end
