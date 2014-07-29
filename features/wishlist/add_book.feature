Feature: Add books to the wishlist
	As a user
	I want to add a book to he wishlist

	Background:
    	Given I have an account on the system
    	And there are available books

	@javascript @selenium
	Scenario: I add a book
		Given I am on the shelf page
    	When add a book to the wishlist
    	And I go to the my account page
    	Then I should see the book I added to the wishlist