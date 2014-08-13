class AddRenewCountToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :renew_count, :integer, default: 0
  end
end
