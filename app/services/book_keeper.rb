class BookKeeper
  def initialize(book: nil)
    @book = book
  end

  def lend_to!(borrower: nil)
    return false unless book.available?

    ActiveRecord::Base.transaction do
      Loan.new(borrower: borrower, book: book.make_lent).start!
    end
  end

  def return_by!(borrower: nil)
    return false unless book.lent? && book.current_borrower == borrower

    ActiveRecord::Base.transaction do
      book.make_available
      book.increment!(:readings)
      book.current_loan.update closed_at: Time.now
    end
  end

  def renew_until!(borrower: nil)
    return false unless book.lent? && book.current_borrower == borrower

    ActiveRecord::Base.transaction do
      book.current_loan.update ends_at: book.current_loan.ends_at + 15.days
      if book.current_loan.allowed_to_renew_again?
        book.current_loan.update renew_count: book.current_loan.renew_count + 1
      else
        return false
      end
    end
  end

  private
  attr_reader :book
end
