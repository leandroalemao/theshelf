require 'spec_helper'

describe User do
  it_behaves_like 'a authorizable resource'

  context "#read_books" do
    it "knows when she has read no books" do
      user = create(:user)

      expect(user.read_books).to be_empty
    end

    it "knows a book she has returned" do
      user = create(:user)
      book = create(:lent_book, borrower: user)
      BookKeeper.new(book: book).return_by!(borrower: user)

      expect(user.read_books.map(&:title)).to eq [book.title]
    end

    it "does not return currently borrowed books" do
      user = create(:user)
      create(:lent_book, borrower: user)

      expect(user.read_books).to be_empty
    end
  end
end

