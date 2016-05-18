require 'rails_helper'

RSpec.describe PurchasesController, :type => :controller do
  describe "GET datafile" do
    it "renders the datafile template when called via GET" do
      get :datafile
      response.should render_template("datafile")
      response.status.should == 200
    end
  end

  describe "POST datafile" do
    it "renders 500 page if no datafile in POST" do
      post :datafile
      response.body.should =~ /We\'re sorry, but something went wrong\./
      response.status.should == 500
    end

    it "takes datafile input and calls appropriate method on file upload; does redirect" do
      path = "#{Rails.root}/spec/fixtures/files/example_input.tab"
      file = fixture_file_upload(path, 'text/csv')
      data = CSV.read(path, { :col_sep => "\t" })
      # check that Purchase.parse_data method gets called with data
      # note that unit tests sufficiently cover the parse_data method
      Purchase.should receive(:parse_data).with(data)
      post :datafile, datafile: file
      response.status.should == 302 # redirect
      response.should redirect_to(datafile_path)
    end

  end

end
