module Api
  module V1
    class UsersController < ApplicationController

      def index
        authorize! :read, User, :message => "Unable to read users."
        @users = User.all
        render json: @users, each_serializer: UserSerializer
      end

      def destroy
        user = User.find(delete_params[:id])
        authorize! :delete, user, :message => "Unable to delete users."
        user.delete
      end
      
      def update
        user = User.find(update_params[:id])
        authorize! :update, user, :message => "Unable to update users."

        user.update(
          first_name: update_params[:first_name],
          last_name: update_params[:first_name],
          email: update_params[:email]
        )

        if update_params[:password]
          user.update(
            password: update_params[:password],
            password_confirmation: update_params[:password],
          )
        end
      end

      def create
        @user = User.new({
          first_name: create_params[:first_name],
          last_name: create_params[:last_name],
          email: create_params[:email],
          password: create_params[:password],
          password_confirmation: create_params[:password_confirmation]
        })
        if !@user.save
          render json: {errors: @user.errors.messages}, status: 400
        else
          @user.add_role "user"
          @user.send_confirmation_instructions
        end
      end

      def reset_password
        user = User.find_by(email: create_params[:email])
        ResetPasswordMailer.reset_password(user).deliver_now
        redirect_to 'https://avbapp.herokuapp.com/login', notice: "You are going to receive an email with the new passsword"
      end


      def confirm_token
        user = User.where(confirmation_token: params[:token]).first
        if user
          user.confirm
          redirect_to 'https://avbapp.herokuapp.com/login', notice: "Gracias por confirmar tu cuanta!"
        else
          render text: 'user not found'
        end
      end


      private

      def create_params
        params.require(:data)
          .require(:attributes)
          .permit([:first_name, :email, :password, :password_confirmation, :last_name])
      end

      def update_params
        params.require(:data)
          .require(:attributes)
          .permit([:id, :first_name, :email, :password, :last_name])
      end

      def delete_params
        params.require(:data)
          .require(:attributes)
          .permit([:id])
      end

    end
  end
end
