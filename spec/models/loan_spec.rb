require 'spec_helper'

describe Loan do
  context '#start!' do
    it 'needs a book and borrower' do
      expect {
        Loan.new.start!
      }.to raise_error
    end
  end

  context '#ending?' do
    it "is true when less than one week of loan remaining" do
      Timecop.freeze(Time.now) do
        loan = create(:loan, ends_at: 7.days.from_now)

        expect(loan).to be_ending
      end
    end

    it "is false when more than one week of loan remaining" do
      Timecop.freeze(Time.now) do
        loan = create(:loan, ends_at: 8.days.from_now)

        expect(loan).not_to be_ending
      end
    end
  end

  context '#extended?' do
    it "is true when the loan has been extended" do
      Timecop.freeze(Time.now) do
        loan = create(:loan)
        loan.start!
        loan.extend!

        expect(loan).to be_extended
      end
    end

    it "is false when the loan has not been extended" do
      Timecop.freeze(Time.now) do
        loan = create(:loan)
        loan.start!

        expect(loan).not_to be_extended
      end
    end
  end
end
