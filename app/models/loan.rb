class Loan < ActiveRecord::Base
  REGULAR_PERIOD = 30.days
  scope :by_most_recent, -> { order('started_at desc') }

  belongs_to :borrower, foreign_key: :user_id, class_name: 'User'
  belongs_to :book

  validates_presence_of :book, :borrower

  def start!
    update! started_at: Time.now, ends_at: REGULAR_PERIOD.from_now
  end

  def closed?
    !!closed_at
  end

  def extend!
    update! ends_at: self.ends_at + 15.days
  end

  def extended?
    ends_at.to_i > started_at.to_i + REGULAR_PERIOD
  end

  def ending?
    ends_at <= 7.days.from_now
  end
end
