module ApplicationHelper

  def attachment(object, caption = true, options={})
    return '' if object.nil?
    tag = case object['content_type']
    when /^image/
      image_tag(object['web_url'], options)
    when /^video/
      video_tag(object['web_url'], options.merge(controls: true))
    end
    if caption === true
      caption = content_tag(:figcaption, asset_caption(object))
      content_tag(:figure, tag + caption)
    else
      tag
    end
  end

  def asset_caption(asset)
    title = h asset['title']
    if asset['description'].present?
      title += "; " + asset['description']
    end    
    byline = h(asset['attribution'])
    byline = "By #{h asset['creator']}" if byline.blank? && asset['creator'].present? 
    byline_link = link_to byline, asset['source'] if asset['source'] && byline    
    license = Odlifier.translate(asset['license'], nil)
    [title, byline_link, license].select{|x| !x.blank?}.join('. ').html_safe
  end
  
  def menus
    $menus ||= YAML.load_file("#{Rails.root.to_s}/config/menus.yml")
  end
end
