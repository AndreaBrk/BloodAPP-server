class AddLatLngToDonationEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :donation_events, :lat, :decimal, precision: 14, scale: 14
    add_column :donation_events, :lng, :decimal, precision: 14, scale: 14
  end
end
