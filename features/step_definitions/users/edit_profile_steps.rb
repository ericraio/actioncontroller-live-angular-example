When /^I am on the edit profile screen$/ do
  visit '/user/profile/edit'
end

When /^I enter image details$/ do
  attach_file('avatar', "#{Rails.root}/features/fixtures/test.jpg")
  click_on 'Upload Avatar'
end

When /^I enter cover photo details$/ do
  attach_file('cover_photo', "#{Rails.root}/features/fixtures/test.jpg")
  click_on 'Upload Cover Photo'
end

Then /^I should see an edit profile success message$/ do
  page.should have_content "Successfully updated your profile."
end

