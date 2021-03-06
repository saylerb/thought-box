require "rails_helper"

RSpec.feature "update link attributes", js: true do
  context "with valid input" do
    scenario "user can update link title" do
      user = create_and_authenticate_user
      link = create(:link, title: "Original Title", url: "https://www.google.com/", user: user)

      visit root_path

      expect(Link.find(link.id).title).to eq("Original Title")

      within "#link-#{link.id}" do
        expect(page).to have_content("Original Title")

        page.execute_script("$('#title-#{link.id}').html('UPDATED TITLE')")
        page.execute_script("$('#title-#{link.id}').blur()")

        expect(page).to_not have_content("Original Title")
        expect(page).to have_content("UPDATED TITLE")
      end

      expect(page).to have_content("Updated successfully!")
      expect(Link.find(link.id).title).to eq("UPDATED TITLE")
    end

    scenario "user can update link url" do
      user = create_and_authenticate_user
      link = create(:link, title: "original title", url: "https://www.google.com/", user: user)

      visit root_path

      expect(Link.find(link.id).title).to eq("original title")

      within "#link-#{link.id}" do
        expect(page).to have_content("https://www.google.com/")

        page.execute_script("$('#url-#{link.id}').focus()")
        page.execute_script("$('#url-#{link.id}').html('https://www.stackoverflow.com')")
        page.execute_script("$('#url-#{link.id}').blur()")

        expect(page).to_not have_content("https://www.google.com/")
        expect(page).to have_content("https://www.stackoverflow.com")
      end

      expect(page).to have_content("Updated successfully!")
      expect(page).to have_content("https://www.stackoverflow.com")
      expect(Link.find(link.id).url).to eq("https://www.stackoverflow.com")
    end
    
    scenario "error message should clear after entering a valid update" do
      user = create_and_authenticate_user
      link = create(:link, title: "original title", url: "https://www.google.com/", user: user)

      visit root_path

      expect(Link.find(link.id).title).to eq("original title")

      page.execute_script("$('#table-body').prepend(\"<tr class='bg-danger'><td colspan='5'>Error message</td></tr>\")")

      within "tr.bg-danger" do
        expect(page).to have_content("Error message")
      end

      within "#link-#{link.id}" do
        expect(page).to have_content("https://www.google.com/")

        page.execute_script("$('#url-#{link.id}').focus()")
        page.execute_script("$('#url-#{link.id}').html('https://www.stackoverflow.com')")
        page.execute_script("$('#url-#{link.id}').blur()")
      end

      expect(page).to_not have_content("Error message")
      expect(page).to_not have_css("tr.bg-danger")
      expect(page).to_not have_content("Updated Successfully!")
      expect(Link.find(link.id).url).to eq("https://www.stackoverflow.com")
    end
  end

  context "with invalid input" do
    scenario "user should not be able to update title with invalid title" do
      user = create_and_authenticate_user
      link = create(:link, title: "original title", url: "https://www.google.com/", user: user)

      visit root_path

      expect(Link.find(link.id).title).to eq("original title")

      within "#link-#{link.id}" do
        expect(page).to have_content("https://www.google.com/")

        page.execute_script("$('#title-#{link.id}').focus()")
        page.execute_script("$('#title-#{link.id}').html('')")
        page.execute_script("$('#title-#{link.id}').blur()")
      end

      expect(page).to_not have_content("Updated Successfully!")
      expect(page).to have_content("Title can't be blank")
      expect(page).to have_content("https://www.google.com/")
      expect(Link.find(link.id).url).to eq("https://www.google.com/")
    end

    scenario "user should not be able to update url with invalid url" do
      user = create_and_authenticate_user
      link = create(:link, title: "original title", url: "https://www.google.com/", user: user)

      visit root_path

      expect(Link.find(link.id).title).to eq("original title")

      within "#link-#{link.id}" do
        expect(page).to have_content("https://www.google.com/")

        page.execute_script("$('#url-#{link.id}').focus()")
        page.execute_script("$('#url-#{link.id}').html('INVALID-URL')")

        page.execute_script("$('#url-#{link.id}').blur()")
      end

      expect(page).to_not have_content("INVALID-URL")
      expect(page).to_not have_content("Updated Successfully!")
      expect(page).to have_content("Url is not a valid URL")
      expect(page).to have_content("https://www.google.com/")
      expect(Link.find(link.id).url).to eq("https://www.google.com/")
    end
  end
end

