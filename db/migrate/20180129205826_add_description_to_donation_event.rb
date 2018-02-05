class AddDescriptionToDonationEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :donation_events, :description, :text
  end
end
