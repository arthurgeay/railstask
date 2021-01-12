require 'httparty'
require 'discordrb/webhooks'

class TaskListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task_list, only: [:show, :edit, :update, :destroy]

  # GET /task_lists
  # GET /task_lists.json
  def index
    @project = Project.find(params[:project_id])
    @task_lists = TaskList.where(project_id: params[:project_id])
  end

  # GET /task_lists/1
  # GET /task_lists/1.json
  def show
    @tasks = Task.where(task_list_id: params[:id])
  end

  # GET /task_lists/new
  def new
    @project = Project.find(params[:project_id])
    @task_list = TaskList.new
  end

  # GET /task_lists/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @task_list = TaskList.find(params[:id])
  end

  # POST /task_lists
  # POST /task_lists.json
  def create
    @project = Project.find(params[:project_id])
    @task_list = @project.task_lists.new(task_list_params)

    respond_to do |format|
      if @task_list.save
      if current_user.slack_webhook != nil and current_user.slack_webhook.start_with?('https://hooks.slack.com/')
        response = HTTParty.post(current_user.slack_webhook,
        :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' },
        :body => 
        {
          "blocks": [
            {
              "type": "section",
              "text": {
                "type": "mrkdwn",
                "text": "*💼 Nouvelle Liste*!\n " + task_list_params['name']
              }
            },
            {
              "type": "header",
              "text": {
                "type": "plain_text",
                "text": "Liste: ",
                "emoji": true
              }
            },
            {
              "type": "section",
              "text": {
                "type": "mrkdwn",
                "text": "🚀 *Projet:* " + @project['name']
              }
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
            embed.title = '💼 Nouvelle Liste !'
            embed.description = "**Projet:** " + @project.name + "\n**Liste:** " + @task_list.name
            embed.colour = 13369344
            embed.timestamp = Time.now
            embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "From RailsTask🚄", icon_url:"https://cloud-image-dlcn.netlify.com/railstask.png")
          end
        end
      end

        format.html { redirect_to project_path(@project), notice: 'Task list was successfully created.' }
        format.json { render project_path(@project), status: :created, location: @task_list }
      else
        format.html { render :new }
        format.json { render json: @task_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_lists/1
  # PATCH/PUT /task_lists/1.json
  def update
    @project = Project.find(params[:project_id])

    respond_to do |format|
      if @task_list.update(task_list_params)
        format.html { redirect_to project_path(@project), notice: 'Task list was successfully updated.' }
        format.json { render project_path(@project), status: :ok, location: @task_list }
      else
        format.html { render :edit }
        format.json { render json: @task_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_lists/1
  # DELETE /task_lists/1.json
  def destroy
    @project = Project.find(params[:project_id])

    @task_list.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: 'Task list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_list
      @task_list = TaskList.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_list_params
      params.require(:task_list).permit(:name)
    end
end
