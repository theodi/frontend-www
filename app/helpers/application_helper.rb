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
  
  def author(publication)
    if publication.author
      if publication.author['tag_ids'].include?("team")
        link_to publication.author["name"], team_article_path(publication.author["slug"]), :class => "author"
      else
        content_tag :span, publication.author["name"], :class => "author"
      end
    end
  end
  
  def module_block(section, publication)
  	begin
  		render :partial => "module/#{section.gsub('-', '_')}", :locals => { :section => section, :publication => publication }
    rescue ActionView::MissingTemplate
  	  render :partial => 'module/block', :locals => { :section => section, :publication => publication }
  	end
  end
  
  def date_range(from_date, until_date)
    if from_date.to_date == until_date.to_date
     "#{from_date.strftime("%A %d %B %Y")}, #{from_date.strftime("%l:%M%P")} - #{until_date.strftime("%l:%M%P")}"
    else
     "#{from_date.strftime("%A %d %B %Y")} #{from_date.strftime("%l:%M%P")} - #{until_date.strftime("%A %d %B %Y")} #{until_date.strftime("%l:%M%P")}"
    end    
  end

  def country(iso_code)
    c = Country[iso_code]
    c ? c.name : nil
  end
  
end
