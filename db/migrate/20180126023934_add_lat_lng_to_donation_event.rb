class AddLatLngToDonationEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :donation_events, :lat, :decimal, precision: 8, scale: 2
    add_column :donation_events, :lng, :decimal, precision: 8, scale: 2
  end
end
