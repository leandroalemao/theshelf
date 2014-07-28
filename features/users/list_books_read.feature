Feature: List books already read
  As a user
  I want to edit my account details
  In order to have my data updated

  Scenario: I can see the last book I've returned
    Given I have an account on the system
    And I've borrowed a book
    And I am on the shelf page
    When I return the book
    And I go to the read books list
    Then I should see the book I've returned
