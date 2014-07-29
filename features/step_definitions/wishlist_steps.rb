Given(/^I (?:am on|go to) the my account page$/) do
  visit my_account_path
end

Then(/^I should see the wishlist$/) do
  page.should have_content "my wishlist"
end

When(/^add a book to the wishlist$/) do
  within '#book-list' do
  	first('.btn-wishlist').click
  end
end

Then(/^I should see the book I added to the wishlist$/) do
  page.should have_css ".wishlist-item"
end
