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
  end

  # GET /task_lists/new
  def new
    @project = Project.find(params[:project_id])
    @task_list = @project.task_lists.build
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
        format.html { redirect_to project_task_list_path(id: @task_list.id), notice: 'Task list was successfully created.' }
        format.json { render :show, status: :created, location: @task_list }
      else
        format.html { render :new }
        format.json { render json: @task_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_lists/1
  # PATCH/PUT /task_lists/1.json
  def update
    respond_to do |format|
      if @task_list.update(task_list_params)
        format.html { redirect_to project_task_list_path(id: @task_list.id), notice: 'Task list was successfully updated.' }
        format.json { render :show, status: :ok, location: @task_list }
      else
        format.html { render :edit }
        format.json { render json: @task_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_lists/1
  # DELETE /task_lists/1.json
  def destroy
    @task_list.destroy
    respond_to do |format|
      format.html { redirect_to project_task_lists_path, notice: 'Task list was successfully destroyed.' }
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
