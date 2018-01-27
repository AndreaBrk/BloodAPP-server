class CreateDonationEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :donation_events do |t|
      t.string :name
      t.integer :size
      t.string :blood_type

      t.timestamps
    end
  end
end
