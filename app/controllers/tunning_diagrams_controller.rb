class TunningDiagramsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  before_filter :load_tunning_diagram, only: [:show, :edit, :update, :destroy]

  # GET /tunning_diagrams
  # GET /tunning_diagrams.json
  # GET /tunning_diagrams.xml
  def index
    @tunning_diagrams = TunningDiagram.accessible_by(current_ability).search(params[:search]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tunning_diagrams }
      format.xml  { render xml: @tunning_diagrams }
    end
  end

  # GET /tunning_diagrams/1
  # GET /tunning_diagrams/1.json
  # GET /tunning_diagrams/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tunning_diagram }
      format.xml  { render xml: @tunning_diagram }
    end
  end

  # GET /tunning_diagrams/scan
  def scan
    hilt_no = (params[:tunning_diagram]||{})[:hilt_no]
    @tunning_diagram = TunningDiagram.accessible_by(current_ability).where(hilt_no: hilt_no).first || TunningDiagram.new
    respond_to do |format|
      format.html 
    end
  end

  # GET /tunning_diagrams/new
  # GET /tunning_diagrams/new.json
  # GET /tunning_diagrams/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tunning_diagram }
      format.xml  { render xml: @tunning_diagram }
    end
  end

  # GET /tunning_diagrams/1/edit
  def edit
  end

  # POST /tunning_diagrams
  # POST /tunning_diagrams.json
  # POST /tunning_diagrams.xml
  def create
    all_saved = false
    if params[:tunning_diagram] && file = params[:tunning_diagram][:archive]
      if file.original_filename =~ /\.zip$/i
        require 'zip/zipfilesystem'
        extract_path = Rails.root.join('public', 'tmp', Digest::MD5.hexdigest(file.original_filename))
        FileUtils.rm_rf(extract_path)
        FileUtils.mkdir_p(extract_path)
        Zip::ZipFile.open(file.tempfile) do |zip| 
          all_saved = zip.select{|zipfile| zipfile.name =~ /\.(jpg|jpeg)$/i}.map do |zipfile|
            f_path = File.join(extract_path, zipfile.name)
            zipfile.extract(f_path)
            File.open(f_path = File.join(extract_path, zipfile.name), 'r+') do |f| 
              f_name     = zipfile.name.split('.')[0].upcase
              td         = TunningDiagram.where(hilt_no: f_name).first || TunningDiagram.new(hilt_no: f_name)
              td.archive = f
              td.save
            end
          end 
        end
        FileUtils.rm_rf(extract_path)
      elsif file.original_filename =~ /\.(jpg|jpeg)$/i
        f_name     = file.original_filename.split('.')[0]
        td         = TunningDiagram.where(hilt_no: f_name).first || TunningDiagram.new(hilt_no: f_name)
        td.archive = file 
        all_saved  = td.save
      end
    end
    respond_to do |format|
      if all_saved
        format.html { redirect_to @tunning_diagram, notice: I18n.t('controllers.create_success', name: @tunning_diagram.class.model_name.human) }
        format.json { render json: @tunning_diagram, status: :created, location: @tunning_diagram }
        format.xml  { render xml: @tunning_diagram, status: :created, location: @tunning_diagram }
      else
        format.html { render action: "new" }
        format.json { render json: @tunning_diagram.errors, status: :unprocessable_entity }
        format.xml  { render xml: @tunning_diagram.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tunning_diagrams/1
  # PUT /tunning_diagrams/1.json
  # PUT /tunning_diagrams/1.xml
  def update
    respond_to do |format|
      if @tunning_diagram.update_attributes(params[:tunning_diagram])
        format.html { redirect_to @tunning_diagram, notice: I18n.t('controllers.update_success', name: @tunning_diagram.class.model_name.human) }
        format.json { head :no_content }
        format.xml  { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tunning_diagram.errors, status: :unprocessable_entity }
        format.xml  { render xml: @tunning_diagram.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tunning_diagrams/1
  # DELETE /tunning_diagrams/1.json
  # DELETE /tunning_diagrams/1.xml
  def destroy
    #@tunning_diagram = TunningDiagram.find(params[:id])
    if @tunning_diagram.destroy && @tunning_diagram.destroy
      respond_to do |format|
        format.html { redirect_to tunning_diagrams_url, notice: I18n.t('controllers.destroy_success', name: @tunning_diagram.class.model_name.human) } 
        format.json { head :no_content }
        format.xml  { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to tunning_diagrams_url, notice: I18n.t('controllers.destroy_fail', name: @tunning_diagram.class.model_name.human) }
        format.json { head :no_content }
        format.xml  { head :no_content }
      end
    end
  end

  private
  # Use callback to share common setup or constraints between actions
  def load_tunning_diagram
    @tunning_diagram = TunningDiagram.accessible_by(current_ability).find(params[:id])
  end
  
  # User this method to whitelist the permissible parameters. Example:
  #   params.require(:person).permit(:name, :age)
  #
  # Also, you can specialize this method with per-user checking of permissible
  # attributes.
  def tunning_diagram_params
    params.require(:tunning_diagram).permit()
  end
end
