require 'httparty'

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
    @projects = Project.joins(:project_users).where({project_users: {user_id: current_user.id}}) 
  end

  def enforce_current_profile
    unless @profile && @profile.user == current_user.id
      format.html { redirect_to @project, notice: 'This is not one of your projects' }
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
    @users = User.all
  end

  # GET /projects/1/edit
  def edit
    @users = User.all
  end

  # POST /projects
  # POST /projects.json
  def create
   
    @users = User.all

    @project = Project.new(project_params)
    logger.debug "AAAAA: #{project_params['name']}"
    respond_to do |format|
      if @project.save
        response = HTTParty.post('https://hooks.slack.com/services/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',
        :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' },
        :body => { :text => "Le projet " + project_params['name'] + " à été crée !"}.to_json)
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
        # @project_admin = ProjectUser.new()
        # @project_admin.users_id = current_user.id
        # @project_admin.role = "Administrator"
        # @project_admin.projects_id = @project.id
        # @project_admin.save
      
        # @project_member = ProjectUser.new()
        # puts @project_member.inspect

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
