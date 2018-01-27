module Api
  module V1
    class DonationEventsController < ApplicationController

      def index
        # authorize! :read, DonationEvent, :message => "Unable to read users."
        lat = params[:posLat].to_f
        lng = params[:posLng].to_f
        @donations_events = DonationEvent.select("donation_events.*, ('(#{lng},#{lat})'::point <@> point(lng,lat)) as distance").order('distance')
        render json: @donations_events
      end

      def index_owner
        # authorize! :read, DonationEvent, :message => "Unable to read users."
        debugger
        @donations_events = current_user.donation_events
        render json: @donations_events
      end

      def create
        # authorize! :create, User, :message => "Unable to create users."
        @donations_event = DonationEvent.new({
          name: create_params[:name],
          size: create_params[:size],
          blood_type: create_params[:type],
          lat: create_params[:lat],
          lng: create_params[:lng]
        })
        if !@donations_event.save
          render json: {errors: @donations_event.errors.messages}, status: 400
        end
      end


      private
      def create_params
        params.require(:data)
          .require(:attributes)
          .permit([:name, :type, :size, :lat, :lng])
      end

    end
  end
end