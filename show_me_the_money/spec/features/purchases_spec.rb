require "rails_helper"

feature "File Upload" do
  scenario "User uploads purchase file, sees sum of purchases" do
    visit datafile_path
    page.should have_content("Show Me the Money")
    find_field "datafile"
    
    root_path = "#{Rails.root}/spec/fixtures/files/"
    path = "#{root_path}example_input.tab"
    attach_file('datafile', path)
    click_button "Upload"

    page.should have_text("Successfully recorded $95.00. Well done!")
    page.should have_content("Show Me the Money")
    find_field "datafile"

    path2 = "#{root_path}example_input_2.tab"
    attach_file('datafile', path2)
    click_button "Upload"

    page.should have_text("Successfully recorded $895.00. Well done!")
  end
end

