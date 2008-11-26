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
    @detail.to_yaml.should_not be_empty
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
    @detail = create_from_url
    @detail.from_url.should_not be_nil
    @detail.new_record?.should be_false
  end

  it 'should update the content from the stored remote URL' do
    updated_data = '<updated><data/></updated>'
    @detail = create_from_url

    fake_response = {:content => updated_data}
    Detail.should_receive(:fetch_data).with(@detail.from_url).and_return(fake_response)

    @detail.update_cached_content!
    @detail.content.should eql(updated_data)
  end

  it "should return false if there's no stored remote URL" do
    @detail = create_detail  # no 'from_url' attribute
    @detail.update_cached_content!.should be_false
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

  def create_from_url(options = {})
    url  = options[:url]  || 'http://www.example.org/some/api.xml'
    data = options[:data] || '<data><to><test/></to></data>'
    content_type = options[:content_type] || 'application/xml'

    # mock up the HTTP response
    http_resp = mock('HTTP response')
    http_resp.should_receive(:content_type).and_return(content_type)
    http_resp.should_receive(:body).and_return(data)
    Net::HTTP.should_receive(:get_response).with(URI.parse(url)).and_return(http_resp)
    detail = Detail.create_from_url('New API', url)
    detail.save
    detail
  end
end
