class Detail
  class WrongContentType < Exception; end

  include DataMapper::Resource

  property :id, Serial

  property :name,         String, :nullable => false
  property :content,      Text,   :nullable => false
  property :content_type, String, :nullable => false

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

end
