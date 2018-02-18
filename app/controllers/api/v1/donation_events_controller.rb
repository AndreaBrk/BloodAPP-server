module Api
  module V1
    class DonationEventsController < ApplicationController

      def destroy
        authorize! :delete, DonationEvent, :message => "Unable to delete users."
        @donations_events = DonationEvent.find(params[:id])
        @donations_events.destroy
      end

      def change_status
        authorize! :update, DonationEvent, :message => "Unable to update users."
        @donations_event = DonationEvent.find(params[:id])
        value = 1
        if @donations_event.status == 1
          value = 2
        end
        @donations_event.update({
          status: value
        })
      end

      def update
        authorize! :update, DonationEvent, :message => "Unable to read users."
        debugger
        @donations_event = DonationEvent.find(params[:id])
        @donations_event.update({
          name: create_params[:name],
          size: create_params[:size],
          blood_type: create_params[:type],
          lat: create_params[:lat],
          lng: create_params[:lng],
        })
        if !@donations_event.save
          render json: {errors: @donations_event.errors.messages}, status: 400
        end
      end

      def index
        authorize! :read, DonationEvent, :message => "Unable to read users."
        lat = params[:posLat].to_f
        lng = params[:posLng].to_f
        @donations_events = DonationEvent.select("donation_events.*, ('(#{lng},#{lat})'::point <@> point(lng,lat)) as distance").order('distance')
        @donations_events = @donations_events.where(status: DonationEvent.statuses[:open])
        @donations_events = @donations_events.where(blood_type: params[:blood_type]) if params[:blood_type]
        render json: @donations_events
      end

      def index_owner
        authorize! :read, DonationEvent, :message => "Unable to read users."
        @donations_events = current_user.donation_events
        @donations_events = @donations_events.where(blood_type: params[:blood_type]) if params[:blood_type]
        render json: @donations_events
      end

      def create
        authorize! :create, DonationEvent, :message => "Unable to create users."
        @donations_event = DonationEvent.new({
          name: create_params[:name],
          size: create_params[:size],
          blood_type: create_params[:type],
          lat: create_params[:lat],
          lng: create_params[:lng],
          user_id: current_user.id,
          description: create_params[:description]
        })
        if !@donations_event.save
          render json: {errors: @donations_event.errors.messages}, status: 400
        else
          render json: @donations_event
        end
      end


      private
      def create_params
        params.require(:data)
          .require(:attributes)
          .permit([:name, :type, :size, :lat, :lng, :description])
      end
    end
  end
end