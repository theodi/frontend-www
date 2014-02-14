xml.instruct! :xml, :version => "1.0" 
xml.feed :xmlns => "http://www.w3.org/2005/Atom", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.title @title
  xml.updated DateTime.parse(@artefacts.first.updated_at) rescue DateTime.now
  xml.id request.original_url
  xml.link :href => request.original_url, :rel => "self"
  if @artefacts
    @artefacts.each do |item|
      xml.entry do
        if item.tag_ids.include?('blog')
          section = 'blog' 
        else
          section = @section
        end
        xml.link :href => course_instance_url(@courses[item.details.course].slug, item.details.date[0..9])
        xml.title item.title, :type => 'html'
        xml.content @courses[item.details.course].description, :type => 'html'
        xml.summary item.details.description, :type => 'html'
        xml.updated DateTime.parse(item.created_at).rfc3339
        xml.id send("#{@section.gsub('-', '_')}_article_path", item.slug, :only_path => false)
        xml.author do |author|
          author.name (item.details.author||item.author).name rescue nil
        end
      end
    end
  end
end