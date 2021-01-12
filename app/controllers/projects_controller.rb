require 'httparty'
require 'discordrb/webhooks'

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  
  # GET /projects
  # GET /projects.json
  
  def index
    @projects = Project.joins(:project_users).where({project_users: {user_id: current_user.id}})
    redirect_to ''
  end

  
  # GET /projects/1
  # GET /projects/1.json
  def show
    @own_projects = ProjectUser.where(project_id: @project.id).pluck(:user_id)
    if @own_projects.include?(current_user.id)
      @projects = Project.joins(:project_users).where({project_users: {user_id: current_user.id}}) 
    else
      redirect_to root_path, alert: 'This is not one of your projects' 
    end
  end

  def enforce_current_profile
    unless @profile && @profile.user == current_user.id
      format.html { redirect_to @project, notice: 'This is not one of your projects' }
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
    
    @all = User.all.pluck(:id)
    @current = current_user.id
    @all.delete(@current)
    @all
    @users = User.all.where(id: @all  )
  end

  # GET /projects/1/edit
  def edit
    @all = User.all.pluck(:id)
    @ban = ProjectUser.where(project_id: @project.id).pluck(:user_id)
    @ban.each do |b|
      @all.delete(b)
    end
    @users = User.all.where(id: @all  )
  end

  # POST /projects
  # POST /projects.json
  def create
   
    @users = User.all
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        @members = []
        @project.users.each do |user|
          @members << user.username
        end
      if current_user.slack_webhook != nil and current_user.slack_webhook.start_with?( 'https://hooks.slack.com/')
          response = HTTParty.post(current_user.slack_webhook,
          :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' },
          :body =>               
          {
           "blocks": [
             {
               "type": "section",
               "text": {
                 "type": "mrkdwn",
                 "text": "*🚀 Nouveau Projet* !\n "
               }
             },
             {
               "type": "header",
               "text": {
                 "type": "plain_text",
                 "text": "Projet: " + @project['name'],
                 "emoji": true
               }
             },
             {
               "type": "section",
               "text": {
                 "type": "mrkdwn",
                 "text": "*Description:* \n" + @project['description'] + "\n\n_"
               }
             },
             {
               "type": "context",
               "elements": [
                 {
                   "type": "mrkdwn",
                   "text": "*Membres: * " + @members.join(", ")
                 }
               ]
             },
             {
               "type": "context",
               "elements": [
                 {
                   "type": "mrkdwn",
                   "text": "📚 *Auteur* : " + current_user.username
                 }
               ]
             }
           ]
         }.to_json)
        end
        
        if current_user.discord_webhook != nil and current_user.discord_webhook.start_with?( 'https://discord.com/')
          
          client = Discordrb::Webhooks::Client.new(url: current_user.discord_webhook)
          client.execute do |builder|
            builder.add_embed do |embed|
              embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: current_user.username, url: "https://www.youtube.com/watch?v=M36MVIYTNlA", icon_url: "https://www.gravatar.com/avatar/" +  Digest::MD5.hexdigest(current_user.email))
              embed.title = '🎉 Nouveau Projet !'
              embed.description = "**Projet:** " + @project.name + "\n\n**Description**: \n" + @project.description + "\n\n**Membres:** " + @members.join(", ")
              embed.colour = 13369344
              embed.timestamp = Time.now
              embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "From RailsTask🚄", icon_url:"https://cloud-image-dlcn.netlify.com/railstask.png")
            end
          end
        end
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    @users = User.all
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @users = User.all
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:name, :description, :color, project_users_attributes: [ :user_id, :role ])
    end
end
