require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a detail exists" do
  Detail.all.destroy!
  request(resource(:details), :method => "POST",
    :params => { :detail => { :id => nil, :name => 'API', :content => 'test data' }})
end

describe "resource(:details)" do
  describe "GET" do

    before(:each) do
      @response = request(resource(:details))
    end

    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of details" do
      @response.should have_xpath("//div/code")
    end

  end

  describe "GET", :given => "a detail exists" do
    before(:each) do
      @response = request(resource(:details))
    end

    it "has a list of details" do
      @response.should have_xpath("//div/code")
    end
  end

  describe "a successful POST" do
    before(:each) do
      Detail.all.destroy!
      @response = request(resource(:details), :method => "POST",
        :params => { :detail => { :id => nil, :name => 'API', :content => 'test data' }})
    end

    it "redirects to resource(:details)" do
      @response.should redirect_to(resource(Detail.first), :message => {:notice => "detail was successfully created"})
    end
  end

  describe "an unsuccessful POST" do
    before(:each) do
      Detail.all.destroy!
      @response = request(resource(:details), :method => "POST",
        :params => { :detail => { :id => nil }})
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
        :params => { :detail => {:id => @detail.id, :name => 'API', :content => 'updated data'} })
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
