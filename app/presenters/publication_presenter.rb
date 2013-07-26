class PublicationPresenter  
  attr_reader :artefact

  attr_accessor :places, :parts, :current_part

  def initialize(artefact)
    @artefact = artefact
  end
  
  PASS_THROUGH_KEYS = [
    :title, :details, :web_url
  ]

  PASS_THROUGH_DETAILS_KEYS = [
    :body, :subtitle, :featured
  ]
  
  PASS_THROUGH_KEYS.each do |key|
    define_method key do
      artefact[key.to_s]
    end
  end

  PASS_THROUGH_DETAILS_KEYS.each do |key|
    define_method key do
      details[key.to_s] if details
    end
  end
  
  def format
    @artefact["format"]
  end

end