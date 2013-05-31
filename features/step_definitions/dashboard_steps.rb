When /^I make a new post$/ do
  within("#new-post") do
    fill_in 'post_headline', :with => 'My new headline'
    fill_in 'post_body', :with => 'My new post'
  end
  click_button 'Post'
end

Then /^I should be on the dashboard screen$/ do
  current_path.should == '/'
end

Then /^I should see my post in the news feed$/ do
  page.should have_content 'My new headline'
end

Then /^I should see a new post success message$/ do
  page.should have_content 'Post was successfully created.'
end

When /^I click on a headline$/ do
  click_on 'My new headline'
end

Then /^I should be on the posts screen$/ do
  current_path.should == '/posts/my-new-headline'
end

Then /^I should see the posts content$/ do
  page.should have_content 'My new post'
end

When /^I follow my friend$/ do
  @friend = User.create!(slug: 'testy2', password: 'sekret1234', username: 'testy2', email: 'my@mail.com')
  @user.follow @friend
end

When /^My friend makes a new post$/ do
  @friend.posts.create(headline: 'Sup Dawg', body: 'My Sexy Bod')
end

Then /^I should see my friends posts before my post$/ do
  page.body.should =~ /My new headline.*Sup Dawg/m
end

Then /^I should see his post appear on the page$/ do
  page.should have_content "Sup Dawg"
end
