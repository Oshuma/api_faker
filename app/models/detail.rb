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

  # Creates a new Detail from the given +url+ response.
  def self.create_from_url(name, url)
    response     = fetch_data(url)
    content      = response[:content]
    content_type = response[:content_type]
    new(:name => name, :from_url => url,
        :content => content, :content_type => content_type)
  end

  private

  # Fetch the data from the remote +url+.
  def self.fetch_data(url)
    response = Net::HTTP.get_response(::URI.parse(url))
    data = {}
    data[:content] = response.body
    data[:content_type] = parse_content_type(response.content_type)
    data
  end

  # Returns the 'basename' (so to speak) of the content +type+.
  def self.parse_content_type(type)
    case type
    when 'application/json'
      'json'
    when 'application/xml'
      'xml'
    when 'application/x-yaml'
      'yaml'
    end
  end

end
