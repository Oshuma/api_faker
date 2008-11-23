class Detail
  include DataMapper::Resource

  property :id, Serial

  property :name,    String, :nullable => false
  property :content, Text,   :nullable => false

end
