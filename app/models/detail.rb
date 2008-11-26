require 'net/http'

class Detail
  class WrongContentType < Exception; end

  include DataMapper::Resource

  property :id, Serial

  property :name,         String, :nullable => false
  property :content,      Text,   :nullable => false
  property :content_type, String, :nullable => false
  property :from_url,     String, :nullable => true

  # A list of valid content types.
  def content_types
    %w{ json yaml xml }
  end

  def to_json
    raise WrongContentType unless content_type == 'json'
    content
  end

  def to_xml
    raise WrongContentType unless content_type == 'xml'
    content
  end

  def to_yaml
    raise WrongContentType unless content_type == 'yaml'
    content
  end

  def self.create_from_url(name, url)
    response = Net::HTTP.get_response(::URI.parse(url))
    content = response.body
    content_type = response.content_type.split('/').last
    new(:name => name, :from_url => url,
        :content => content, :content_type => content_type)
  end

end
