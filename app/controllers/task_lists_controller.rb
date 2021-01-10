require 'httparty'

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
        response = HTTParty.post('https://hooks.slack.com/services/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',
        :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' },
      :body => { :text => "🗂 Une nouvelle liste de tâche【" + task_list_params['name'] + "】à été crée dans le projet『" + @project['name'] + "』! 🎉"}.to_json)
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
