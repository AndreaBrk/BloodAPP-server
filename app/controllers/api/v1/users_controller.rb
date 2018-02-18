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
          debugger
        end
      end

      def get_role
        user = User.find(get_role_params[:id])
        @role = user.roles
        render json: @role.to_json
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
        user.update_attributes(password: 'user1234', password_confirmation: 'user1234')
      end

      def password
        user = current_user
        authorize! :manage, user, :message => "Unable to manage users."
        if !user.update_attributes(password: password_params[:password], password_confirmation: password_params[:password_confirmation])
          render json: {errors: user.errors.messages}, status: 400
        end
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

      def get_role_params
        params.require(:data)
          .require(:attributes)
          .permit([:id])
      end

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

      def password_params
        params.require(:data)
          .require(:attributes)
          .permit([:password, :password_confirmation])
      end

    end
  end
end
