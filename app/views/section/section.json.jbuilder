json._response_info do |response|
  response.status "ok"
end
json.description @section['title']
json.links do |links|
  links.array! @section['links'] do |link|
    if link['link']
      links.title link['alt']
      links.link "#{request.protocol}#{request.host_with_port}" + link['link']
    end
  end
end