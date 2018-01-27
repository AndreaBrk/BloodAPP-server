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
        user_state = nil
        if update_params[:state]
          user_state = User.states[:active]
        else
          user_state = User.states[:inactive]
        end
        

        user.update(
          first_name: update_params[:first_name],
          last_name: update_params[:first_name],
          birthday: update_params[:birthday],
          whatsapp: update_params[:whatsapp],
          personal_email: update_params[:personal_email],
          trello_user_name: update_params[:trello_user_name],
          github_user_name: update_params[:github_user_name],
          slack_user_name: update_params[:slack_user_name],
          kw_email: update_params[:kw_email],
          bitbucket_user_name: update_params[:bitbucket_user_name],
          country: update_params[:country],
          ends_at: update_params[:ends_at],
          technologies: params[:data][:attributes][:technologies],
          state: user_state
        )
      end

      def get_role
        user = User.find(get_role_params[:id])
        @role = user.roles
        render json: @role.to_json
      end

      def create
        authorize! :create, User, :message => "Unable to create users."
        @user = User.new({
          first_name: create_params[:first_name],
          last_name: create_params[:last_name],
          email: create_params[:email],
          password: create_params[:password],
          password_confirmation: create_params[:password_confirmation]
        })
        @user.add_role "user"
        if !@user.save
          render json: {errors: @user.errors.messages}, status: 500
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
          .permit([:id, :first_name, :email, :birthday, :whatsapp, :last_name, :personal_email, :kw_email, :trello_user_name, :slack_user_name, :trello_user_name, :github_user_name, :bitbucket_user_name, :country, :ends_at, :technologies, :state])
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
