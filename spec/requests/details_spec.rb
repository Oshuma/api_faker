require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a detail exists" do
  Detail.all.destroy!
  request(resource(:details), :method => "POST",
    :params => { :detail => { :id => nil, :name => 'API', :from_url => nil,
                 :content => '<test><data /></test>', :content_type => 'xml' }})
end

describe "resource(:details)", :given => 'a detail exists' do
  describe "GET" do

    before(:each) do
      @response = request(resource(:details))
    end

    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of details" do
      @response.should have_xpath("//code/pre")
    end

  end

  describe "GET", :given => "a detail exists" do
    before(:each) do
      @response = request(resource(:details))
    end

    it "has a list of details" do
      @response.should have_xpath("//code/pre")
    end
  end

  describe "a successful POST" do
    before(:each) do
      Detail.all.destroy!
      @response = request(resource(:details), :method => "POST",
        :params => { :detail => { :id => nil, :name => 'API', :from_url => nil,
                     :content => '<test><data /></test>', :content_type => 'xml' }})
    end

    it "redirects to resource(:details)" do
      @response.should redirect_to(resource(Detail.first), :message => {:notice => "detail was successfully created"})
    end
  end

  describe "an unsuccessful POST" do
    before(:each) do
      Detail.all.destroy!
      @response = request(resource(:details), :method => "POST",
        :params => { :detail => { :id => nil, :from_url => nil }})
    end

    it "should return a 200 status" do
      @response.status.should == 200
    end
  end
end

describe "resource(@detail)" do
  describe "a successful DELETE", :given => "a detail exists" do
     before(:each) do
       @response = request(resource(Detail.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:details))
     end
  end
end

describe "resource(:details, :new)" do
  before(:each) do
    @response = request(resource(:details, :new))
  end

  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@detail, :edit)", :given => "a detail exists" do
  before(:each) do
    @response = request(resource(Detail.first, :edit))
  end

  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@detail)", :given => "a detail exists" do

  describe "GET" do
    before(:each) do
      @response = request(resource(Detail.first))
    end

    it "responds successfully" do
      @response.should be_successful
    end
  end

  describe "PUT" do
    before(:each) do
      @detail = Detail.first
      @response = request(resource(@detail), :method => "PUT",
        :params => { :detail => {:id => @detail.id, :name => 'API', :from_url => nil,
                     :content => '<updated><data /></updated>', :content_type => 'xml'} })
    end

    it "redirect to the detail show action" do
      @response.should redirect_to(resource(@detail))
    end

    it "should return a 200 status" do
      @detail = Detail.first
      @response = request(resource(@detail), :method => "PUT",
        :params => { :detail => {:id => @detail.id, :name => nil, :content => nil }})
      @response.status.should == 200
    end
  end

end

describe "create detail from URL" do
  before(:each) do
    Detail.all.destroy!
    @params = { :id => nil, :name => 'New API', :from_url => 'http://www.example.org/some/api.xml' }
    @fake_response = {:content => '<foo/>', :content_type => 'xml'}
    Detail.should_receive(:fetch_data).with(@params[:from_url]).and_return(@fake_response)
  end

  it 'should be successful' do
    @response = request(resource(:details), :method => "POST",
      :params => { :detail => @params })
    @response.should redirect_to(resource(Detail.first))
  end
end

describe "update a detail from stored URL" do
  before(:each) do
    Detail.all.destroy!
    @fake_response = {:content => '<foo/>', :content_type => 'xml'}
    @params = { :id => nil, :name => 'New API', :from_url => 'http://www.example.org/some/api.xml' }
    Detail.should_receive(:fetch_data).twice.with(@params[:from_url]).and_return(@fake_response)
    request(resource(:details), :method => "POST", :params => { :detail => @params })
    @detail = Detail.first
  end

  it 'should be successful' do
    @response = request(resource(@detail, :update_cached))
    @response.should redirect_to(resource(@detail))
  end
end

describe "exceptions" do
  it 'should throw a 404' do
    @response = request('/details/not_a_real_page')
    @response.status.should == 404
  end

  it 'should throw a 406' do
    @response = request(resource(:details, :format => 'monkey'))
    @response.status.should == 406
  end
end
