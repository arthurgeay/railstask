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
    @task_list = TaskList.find(params[:task_list_id])
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @task_list = TaskList.find(params[:task_list_id])
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task_list = TaskList.find(params[:task_list_id])
    @task = @task_list.tasks.new(task_params)
    @project = Project.find(params[:project_id])

    respond_to do |format|
      if @task.save
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
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to project_path(@project), notice: 'Task was successfully updated.' }
        format.json { render project_path(@project), status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to project_task_list_tasks_path, notice: 'Task was successfully destroyed.' }
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
      params.require(:task).permit(:title, :duration, :status, :description, :user_id)
    end
end
