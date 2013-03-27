class ToolPartsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  before_filter :load_tool_part, only: [:show, :edit, :update, :destroy]

  # GET /tool_parts
  # GET /tool_parts.json
  # GET /tool_parts.xml
  def index
    @tool_parts = ToolPart.includes{tool_part_items}.accessible_by(current_ability).search(params[:search]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tool_parts }
      format.xml  { render xml: @tool_parts }
    end
  end

  # GET /tool_parts/1
  # GET /tool_parts/1.json
  # GET /tool_parts/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tool_part }
      format.xml  { render xml: @tool_part }
    end
  end

  # GET /tool_parts/new
  # GET /tool_parts/new.json
  # GET /tool_parts/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tool_part }
      format.xml  { render xml: @tool_part }
    end
  end

  # GET /tool_parts/1/edit
  def edit
  end

  # POST /tool_parts
  # POST /tool_parts.json
  # POST /tool_parts.xml
  def create
    @tool_part = ToolPart.new(params[:tool_part])

    respond_to do |format|
      if @tool_part.save
        format.html { redirect_to @tool_part, notice: I18n.t('controllers.create_success', name: @tool_part.class.model_name.human) }
        format.json { render json: @tool_part, status: :created, location: @tool_part }
        format.xml  { render xml: @tool_part, status: :created, location: @tool_part }
      else
        format.html { render action: "new" }
        format.json { render json: @tool_part.errors, status: :unprocessable_entity }
        format.xml  { render xml: @tool_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tool_parts/1
  # PUT /tool_parts/1.json
  # PUT /tool_parts/1.xml
  def update
    respond_to do |format|
      if @tool_part.update_attributes(params[:tool_part])
        format.html { redirect_to @tool_part, notice: I18n.t('controllers.update_success', name: @tool_part.class.model_name.human) }
        format.json { head :no_content }
        format.xml  { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tool_part.errors, status: :unprocessable_entity }
        format.xml  { render xml: @tool_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tool_parts/1
  # DELETE /tool_parts/1.json
  # DELETE /tool_parts/1.xml
  def destroy
    #@tool_part = ToolPart.find(params[:id])
    if @tool_part.destroy && @tool_part.destroy
      respond_to do |format|
        format.html { redirect_to tool_parts_url, notice: I18n.t('controllers.destroy_success', name: @tool_part.class.model_name.human) } 
        format.json { head :no_content }
        format.xml  { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to tool_parts_url, notice: I18n.t('controllers.destroy_fail', name: @tool_part.class.model_name.human) }
        format.json { head :no_content }
        format.xml  { head :no_content }
      end
    end
  end

  # GET /tool_parts/import
  def new_import
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /tool_parts/import
  def create_import
    respond_to do |format|
      if params[:tool_part] and file = params[:tool_part][:archive] and ToolPart.import(file) 
        format.html { redirect_to tool_parts_url, notice: I18n.t('controllers.tool_parts.import_success') }
      else
        format.html { render action: "new_import" }
      end
    end
  end

  private
  # Use callback to share common setup or constraints between actions
  def load_tool_part
    @tool_part = ToolPart.accessible_by(current_ability).find(params[:id])
  end
  
  # User this method to whitelist the permissible parameters. Example:
  #   params.require(:person).permit(:name, :age)
  #
  # Also, you can specialize this method with per-user checking of permissible
  # attributes.
  def tool_part_params
    params.require(:tool_part).permit()
  end
end
