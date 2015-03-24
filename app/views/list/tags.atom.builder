xml.instruct! :xml, :version => "1.0"
xml.feed :xmlns => "http://www.w3.org/2005/Atom", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.title @title
  xml.updated DateTime.parse(@artefacts.first.updated_at) rescue DateTime.now
  xml.id request.original_url
  xml.link :href => request.original_url, :rel => "self"
  @artefacts.each do |item|
    xml.entry do
      xml.link :href => item.web_url
      xml.title item.title, :type => 'html'
      xml.content item.details.body, :type => 'html'
      xml.summary item.details.excerpt, :type => 'html'
      xml.updated DateTime.parse(item.created_at).rfc3339
      xml.id item.web_url
      xml.author do |author|
        author.name (item.details.author||item.author).name rescue nil
      end
    end
  end
end
