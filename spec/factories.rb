FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@gmail.com" }
    sequence(:first_name) { |n| "Mc#{n}" }
    sequence(:last_name ) { |n| "Donalds#{n}" }
    password 'password'

    factory :admin do
      after(:build) do |user|
        user.make_admin
      end
    end
  end

  factory :book, aliases: [:available_book] do
    sequence(:title) { |n| "#{n}Book" }
    authors 'John Doe'

    factory :rated_book do
      ignore do
        rater nil
      end

      after(:create) do |book, evaluator|
        RateBook.new(book: book, rater: evaluator.rater, rating: 3).rate!
      end
    end

    factory :lent_book do
      ignore do
        borrower nil
      end

      after(:create) do |book, evaluator|
        BookKeeper.new(book: book).lend_to! borrower: evaluator.borrower
      end
    end
  end

  factory :loan do
    book
    association :borrower, factory: :user
  end

  factory :review do
    body 'Nice one!'
    association :book
    association :user
  end

  factory :rating do
    value 3
    association :book
    association :rater, factory: :user
  end
end
