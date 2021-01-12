class ProjectUsersController < ApplicationController
  before_action :set_project_user, only: [:show, :edit, :update, :destroy]

  # GET /project_users
  # GET /project_users.json
  def index
    @project = Project.find(params[:project_id])
    @project_users = @project.project_users

    @all = User.all.pluck(:id)
    @ban = ProjectUser.where(project_id: @project.id).pluck(:user_id)
    @ban.each do |b|
      @all.delete(b)
    end
    @users = User.all.where(id: @all  )
  end

  # GET /project_users/1
  # GET /project_users/1.json
  def show
  end

  # GET /project_users/new
  def new
    @project_user = ProjectUser.new
  end

  # GET /project_users/1/edit
  def edit
  end

  # POST /project_users
  # POST /project_users.json
  def create
    @project_user = ProjectUser.new(project_user_params)
      if @project_user.save
         redirect_to project_path(@project_user.project_id), notice: 'Project user was successfully created.' 
      else
         render :new 
    end
  end

  # PATCH/PUT /project_users/1
  # PATCH/PUT /project_users/1.json
  def update
    respond_to do |format|
      if @project_user.update(project_user_params)
        format.html { redirect_to @project_user, notice: 'Project user was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_user }
      else
        format.html { render :edit }
        format.json { render json: @project_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_users/1
  # DELETE /project_users/1.json
  def destroy
    @project = Project.find(params[:project_id])
    @project_user.destroy
      redirect_to project_path(@project), notice: 'Project user was successfully destroyed.' 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_user
      @project_user = ProjectUser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_user_params
      params.require(:project_user).permit(:user_id, :role, :project_id)
    end
end
