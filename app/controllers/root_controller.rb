require 'gds_api/helpers'
require 'gds_api/content_api'
require 'artefact_retriever'

class RecordNotFound < StandardError
end

class RootController < ApplicationController
  slimmer_template :wrapper
  
  def index
    @title = "Welcome"
  end
  
  def section    
    @artefacts = content_api.sorted_by(params[:section], "curated").results
    @title = params[:section].capitalize
    render "section.html"
  end
  
end