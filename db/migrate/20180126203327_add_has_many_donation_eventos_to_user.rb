class AddHasManyDonationEventosToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :donation_events, :user
    add_column :donation_events, :status, :integer, default: 0
  end
end
