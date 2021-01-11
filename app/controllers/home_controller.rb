class HomeController < ApplicationController
    before_action :authenticate_user!
    
    def index
        @projects = Project.joins(:project_users).where({project_users: {user_id: current_user.id}}) 
    end
    def edit
        @users = User.all
    end
end
