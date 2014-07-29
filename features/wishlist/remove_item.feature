Feature: Remove book from wishlist
	
	Background:
    	Given I have an account on the system
    	And there are available books
    	And there is one book on the wishlist

	Scenario: 
		Given I am on the my account page
    	And I remove one book from the wishlist
    	Then the item should be removed from the wishlist