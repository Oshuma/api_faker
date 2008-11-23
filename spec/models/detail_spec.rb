require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Detail do

  it 'should require the name' do
    @detail = create_detail(:name => nil, :content => 'Some Content')
    @detail.errors[:name].should_not be_empty
    @detail.valid?.should be_false
  end

  it 'should require the content' do
    @detail = create_detail(:name => 'New Detail', :content => nil)
    @detail.errors[:content].should_not be_empty
    @detail.valid?.should be_false
  end

  private

  def create_detail(options = {})
    detail = Detail.new(options)
    detail.save
    detail
  end
end
