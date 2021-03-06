require 'services/review_book'

describe ReviewBook do
  context "#review!" do
    it 'requires a book, a reviewer and a body' do
      review_book = ReviewBook.new(book: nil, reviewer: nil, content: nil)

      review_book.review!.should be_false
    end

    it "creates a review for a book" do
      user = build :user
      book = create :book
      review_book = ReviewBook.new(book: book, reviewer: user, content: {body: 'Nice'})

      expect {
        review_book.review!
      }.to change { Review.all.size }.by(1)
    end
  end
end
