class IntegrationController < ApplicationController
    before_action :authenticate_user!

    def new
        @service = params[:service]
        @slack = current_user.slack_webhook
        @discord = current_user.discord_webhook
    end

    def create
        @user = current_user
        @slack = integration_params[:slack_webhook]
        @discord = integration_params[:discord_webhook]
        if !integration_params[:slack_webhook].blank?
            @user.update_attributes({slack_webhook: @slack}) 
            redirect_to root_path
        elsif !integration_params[:discord_webhook].blank?
            @user.update_attributes({discord_webhook: @discord})
            redirect_to root_path
        else 
            redirect_to root_path
        end
    end

    def integration_params
        params.permit(:slack_webhook, :discord_webhook, :authenticity_token, :commit)
    end
end
