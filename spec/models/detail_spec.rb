require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Detail do

  it 'should require the name' do
    @detail = create_detail(:name => nil)
    @detail.errors[:name].should_not be_empty
    @detail.valid?.should be_false
  end

  it 'should require the content' do
    @detail = create_detail(:content => nil)
    @detail.errors[:content].should_not be_empty
    @detail.valid?.should be_false
  end

  it 'should require the content_type' do
    @detail = create_detail(:content_type => nil)
    @detail.errors[:content_type].should_not be_empty
    @detail.valid?.should be_false
  end

  it 'should return XML' do
    # xml is the default in the create_detail below
    @detail = create_detail
    @detail.to_xml.should_not be_empty
  end

  it 'should return JSON' do
    @detail = create_detail(:content_type => 'json',
                            :content => '{"test": "data"}')
    @detail.to_json.should_not be_empty
  end

  it 'should return YAML' do
    @detail = create_detail(:content_type => 'yaml',
                            :content => '--- :test')
  end

  it 'should raise WrongContentType for XML' do
    @detail = create_detail(:content_type => 'json')
    lambda do
      @detail.to_xml
    end.should raise_error(Detail::WrongContentType)
  end

  it 'should raise WrongContentType for JSON' do
    @detail = create_detail # xml is default
    lambda do
      @detail.to_json
    end.should raise_error(Detail::WrongContentType)
  end

  it 'should raise WrongContentType for YAML' do
    @detail = create_detail # xml is default
    lambda do
      @detail.to_yaml
    end.should raise_error(Detail::WrongContentType)
  end

  it 'should fetch the content from a remote URL' do
    url  = 'http://www.example.org/some/api.xml'
    data = '<data><to><test /></to></data>'

    # mock up the HTTP response
    http_resp = mock('HTTP response')
    http_resp.should_receive(:content_type).and_return('application/xml')
    http_resp.should_receive(:body).and_return(data)
    Net::HTTP.should_receive(:get_response).with(URI.parse(url)).and_return(http_resp)

    detail = Detail.create_from_url('New API', url)
    detail.save.should be_true
    detail.from_url.should_not be_nil
  end

  private

  def create_detail(options = {})
    defaults = {
      :name => 'New API',
      :content_type => 'xml',
      :content => '<data><to><test /></to></data>'
    }
    detail = Detail.new(defaults.merge(options))
    detail.save
    detail
  end
end
