class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.where(task_list_id: params[:task_list_id])
    @task_list = TaskList.find(params[:task_list_id])
    @project = Project.find(params[:project_id])
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @project = Project.find(params[:project_id])
    @users = @project.users
    @task_list = TaskList.find(params[:task_list_id])
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @users = @project.users
    @task_list = TaskList.find(params[:task_list_id])
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task_list = TaskList.find(params[:task_list_id])
    @task = @task_list.tasks.new(task_params)
    @project = Project.find(params[:project_id])
    @users = @project.users
    
    respond_to do |format|
      if @task.save
        @users = @task.users
        @stackholders = []
        @mails = []
        @users.each do |user|
          @stackholders << user.username
        end

        if current_user.slack_webhook.start_with?( 'https://hooks.slack.com/')
          response = HTTParty.post(current_user.slack_webhook,
          :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' },
          :body =>               
             {
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "*📄 Nouvelle Tâche* !\n "
                  }
                },
                {
                  "type": "header",
                  "text": {
                    "type": "plain_text",
                    "text": "Tâche: " + task_params['title'],
                    "emoji": true
                  }
                },
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "🚀 *Projet:* " + @project['name'] + "\n *💼 Liste:* " + @task_list['name']
                  }
                },
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "*Description:* \n" + @task['description'] + "\n\n_"
                  }
                },
                {
                  "type": "context",
                  "elements": [
                    {
                      "type": "mrkdwn",
                      "text": "*Participants: * " + @stackholders.join(", ")
                    },
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

        if current_user.discord_webhook.start_with?( 'https://discord.com/')
          client = Discordrb::Webhooks::Client.new(url: current_user.discord_webhook)
          client.execute do |builder|
            builder.add_embed do |embed|
              embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: current_user.username, url: "https://www.youtube.com/watch?v=M36MVIYTNlA", icon_url: "https://www.gravatar.com/avatar/" +  Digest::MD5.hexdigest(current_user.email))
              embed.title = ' 📄  Nouvelle tâche !'
              embed.description = "**Projet:** " + @project.name + "\n**Liste:** " + @task_list.name + "\n**Tâche:** " + @task.title + "\n\n**Description**: \n" + @task.description + "\n\n**Participants:** " + @stackholders.join(", ")
              embed.colour = 13369344
              embed.timestamp = Time.now
              embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "From RailsTask🚄", icon_url:"https://cloud-image-dlcn.netlify.com/railstask.png")
            end
          end
        end
        format.html { redirect_to project_path(@project), notice: 'Task was successfully created.' }
        format.json { render project_path(@project), status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    @task_list = TaskList.find(params[:task_list_id])
    @project = Project.find(params[:project_id])
    @users = @project.users
    
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to project_path(@project), notice: 'Task was successfully updated.' }
        format.json { render json: @task, status: :ok}
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @project = Project.find(params[:project_id])
    @task.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :duration, :status, :description, user_ids:[])
    end
end
