class ToolBomsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  before_filter :load_tool_bom, only: [:show, :edit, :update, :destroy]

  # GET /tool_boms
  # GET /tool_boms.json
  # GET /tool_boms.xml
  def index
    @tool_boms = ToolBom.accessible_by(current_ability).search(params[:search]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tool_boms }
      format.xml  { render xml: @tool_boms }
    end
  end

  # GET /tool_boms/1
  # GET /tool_boms/1.json
  # GET /tool_boms/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tool_bom }
      format.xml  { render xml: @tool_bom }
    end
  end

  # GET /tool_boms/new
  # GET /tool_boms/new.json
  # GET /tool_boms/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tool_bom }
      format.xml  { render xml: @tool_bom }
    end
  end

  # GET /tool_boms/1/edit
  def edit
  end

  # POST /tool_boms
  # POST /tool_boms.json
  # POST /tool_boms.xml
  def create
    @tool_bom = ToolBom.new(params[:tool_bom])

    respond_to do |format|
      if @tool_bom.save
        format.html { redirect_to @tool_bom, notice: I18n.t('controllers.create_success', name: @tool_bom.class.model_name.human) }
        format.json { render json: @tool_bom, status: :created, location: @tool_bom }
        format.xml  { render xml: @tool_bom, status: :created, location: @tool_bom }
      else
        format.html { render action: "new" }
        format.json { render json: @tool_bom.errors, status: :unprocessable_entity }
        format.xml  { render xml: @tool_bom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tool_boms/1
  # PUT /tool_boms/1.json
  # PUT /tool_boms/1.xml
  def update
    respond_to do |format|
      if @tool_bom.update_attributes(params[:tool_bom])
        format.html { redirect_to @tool_bom, notice: I18n.t('controllers.update_success', name: @tool_bom.class.model_name.human) }
        format.json { head :no_content }
        format.xml  { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tool_bom.errors, status: :unprocessable_entity }
        format.xml  { render xml: @tool_bom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tool_boms/1
  # DELETE /tool_boms/1.json
  # DELETE /tool_boms/1.xml
  def destroy
    #@tool_bom = ToolBom.find(params[:id])
    if @tool_bom.destroy && @tool_bom.destroy
      respond_to do |format|
        format.html { redirect_to tool_boms_url, notice: I18n.t('controllers.destroy_success', name: @tool_bom.class.model_name.human) } 
        format.json { head :no_content }
        format.xml  { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to tool_boms_url, notice: I18n.t('controllers.destroy_fail', name: @tool_bom.class.model_name.human) }
        format.json { head :no_content }
        format.xml  { head :no_content }
      end
    end
  end

  # GET /tool_boms/import
  def new_import
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /tool_boms/import
  def create_import
    respond_to do |format|
      if params[:tool_bom] and file = params[:tool_bom][:archive] and ToolBom.import(file) 
        format.html { redirect_to tool_boms_url, notice: I18n.t('controllers.tool_boms.import_success') }
      else
        format.html { render action: "new_import" }
      end
    end
  end

  private
  # Use callback to share common setup or constraints between actions
  def load_tool_bom
    @tool_bom = ToolBom.accessible_by(current_ability).find(params[:id])
  end
  
  # User this method to whitelist the permissible parameters. Example:
  #   params.require(:person).permit(:name, :age)
  #
  # Also, you can specialize this method with per-user checking of permissible
  # attributes.
  def tool_bom_params
    params.require(:tool_bom).permit()
  end
end
