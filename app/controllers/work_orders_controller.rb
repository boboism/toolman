class WorkOrdersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  before_filter :load_work_order, only: [:show, :edit, :update, :destroy]

  # GET /work_orders
  # GET /work_orders.json
  # GET /work_orders.xml
  def index
    @work_orders = WorkOrder.accessible_by(current_ability).search(params[:search]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @work_orders }
      format.xml  { render xml: @work_orders }
    end
  end

  # GET /work_orders/1
  # GET /work_orders/1.json
  # GET /work_orders/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @work_order }
      format.xml  { render xml: @work_order }
    end
  end

  # GET /work_orders/new
  # GET /work_orders/new.json
  # GET /work_orders/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @work_order }
      format.xml  { render xml: @work_order }
    end
  end

  # GET /work_orders/1/edit
  def edit
  end

  # POST /work_orders
  # POST /work_orders.json
  # POST /work_orders.xml
  def create
    @work_order = WorkOrder.new(params[:work_order])

    respond_to do |format|
      if @work_order.save
        format.html { redirect_to @work_order, notice: I18n.t('controllers.create_success', name: @work_order.class.model_name.human) }
        format.json { render json: @work_order, status: :created, location: @work_order }
        format.xml  { render xml: @work_order, status: :created, location: @work_order }
      else
        format.html { render action: "new" }
        format.json { render json: @work_order.errors, status: :unprocessable_entity }
        format.xml  { render xml: @work_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /work_orders/1
  # PUT /work_orders/1.json
  # PUT /work_orders/1.xml
  def update
    respond_to do |format|
      if @work_order.update_attributes(params[:work_order])
        format.html { redirect_to @work_order, notice: I18n.t('controllers.update_success', name: @work_order.class.model_name.human) }
        format.json { head :no_content }
        format.xml  { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @work_order.errors, status: :unprocessable_entity }
        format.xml  { render xml: @work_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_orders/1
  # DELETE /work_orders/1.json
  # DELETE /work_orders/1.xml
  def destroy
    #@work_order = WorkOrder.find(params[:id])
    if @work_order.destroy && @work_order.destroy
      respond_to do |format|
        format.html { redirect_to work_orders_url, notice: I18n.t('controllers.destroy_success', name: @work_order.class.model_name.human) } 
        format.json { head :no_content }
        format.xml  { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to work_orders_url, notice: I18n.t('controllers.destroy_fail', name: @work_order.class.model_name.human) }
        format.json { head :no_content }
        format.xml  { head :no_content }
      end
    end
  end

  # GET /work_orders/issue
  def new_issue
    @work_order = WorkOrder.new(issued_by_id: (User.where(name: cookies[:issued_by]).first || current_user).id)

    cookies[:issue_count] ||= ToolBom.group{id}.sum('issue_count').max_by{|result| result.last}.last
    (cookies[:issue_count].to_s.to_i || 10).abs.times{ @work_order.work_order_items << WorkOrderItem.new }

    respond_to do |format|
      format.html 
    end
  end

  # POST /work_orders/issue
  def create_issue

    respond_to do |format|
      if @work_order = WorkOrder.issue(params[:work_order])
        format.html { redirect_to issue_work_orders_url, notice: I18n.t('controllers.work_orders.issue_success', hilt_no: params[:work_order][:hilt_no]) }
        format.json { head :no_content }
        format.xml  { head :no_content }
      else
        format.html { redirect_to issue_work_orders_url, flash: {error: I18n.t('controllers.work_orders.issue_error_work_order', hilt_no: params[:work_order][:hilt_no])}}
        format.json { render json: @work_order.errors, status: :unprocessable_entity }
        format.xml  { render xml: @work_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /work_orders
  # GET /work_orders.json
  # GET /work_orders.xml
  def index_issue
    @work_orders = WorkOrder.accessible_by(current_ability).search(params[:search]).order("issued_at desc, received").page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @work_orders }
      format.xml  { render xml: @work_orders }
    end
  end

  # GET /work_orders/receive
  def new_receive
    @work_order = WorkOrder.new
    respond_to do |format|
      format.html 
    end
  end

  # POST /work_orders/receive
  def create_receive
    hilt_no = params[:work_order][:hilt_no]
    @work_order = WorkOrder.unreceived.where(hilt_no: hilt_no).first
    respond_to do |format|
      if @work_order && @work_order.receive(received_by_id: current_user.id)
        format.html { redirect_to receive_work_orders_url, notice: I18n.t('controllers.work_orders.receive_success', hilt_no: @work_order.hilt_no) }
        format.json { head :no_content }
        format.xml  { head :no_content }
      elsif @work_order
        format.html { redirect_to receive_work_orders_url, flash: { error: @work_order.errors } }
        format.json { render json: @work_order.errors, status: :unprocessable_entity }
        format.xml  { render xml: @work_order.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to receive_work_orders_url, flash: { error: I18n.t('controllers.work_orders.receive_nil_work_order', hilt_no: params[:work_order][:hilt_no]) } } 
        format.json { head :no_content }
        format.xml  { head :no_content }
      end
    end
  end

  # GET /work_orders
  # GET /work_orders.json
  # GET /work_orders.xml
  def index_receive
    @work_orders = WorkOrder.accessible_by(current_ability).search(params[:search]).order("issued_at desc, received").page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @work_orders }
      format.xml  { render xml: @work_orders }
    end
  end

  # GET /work_orders/receive
  def new_tune
    @work_order = WorkOrder.new(tuned_by_id: (User.where(name: cookies[:tuned_by]).first || current_user).id)
    respond_to do |format|
      format.html 
    end
  end

  # POST /work_orders/receive
  def create_tune
    cookies[:tuned_by] = params[:work_order][:tuned_by]
    hilt_no = params[:work_order][:hilt_no]
    @work_order = WorkOrder.untuned.where(hilt_no: hilt_no).first
    respond_to do |format|
      if @work_order && @work_order.tune(tuned_by_id: (User.where(name: cookies[:tuned_by]).first || current_user).id )
        format.html { redirect_to tune_work_orders_url, notice: I18n.t('controllers.work_orders.tune_success', hilt_no: @work_order.hilt_no) }
        format.json { head :no_content }
        format.xml  { head :no_content }
      elsif @work_order
        format.html { render action: "new_tune", error: I18n.t('controllers.work_orders.tune_nil_work_order', hilt_no: hilt_no) }
        format.json { render json: @work_order.errors, status: :unprocessable_entity }
        format.xml  { render xml: @work_order.errors, status: :unprocessable_entity }
      else
        @work_order = WorkOrder.new
        format.html { redirect_to tune_work_orders_url, flash: {error: I18n.t('controllers.work_orders.tune_nil_work_order', hilt_no: hilt_no) } }
        format.json { render json: @work_order.errors, status: :unprocessable_entity }
        format.xml  { render xml: @work_order.errors, status: :unprocessable_entity }
      end
    end
  end

  def index_tune
    @work_orders = WorkOrder.accessible_by(current_ability).search(params[:search]).order("tuned_at desc, tuned").page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @work_orders }
      format.xml  { render xml: @work_orders }
    end
  end
  
  def index_grind
    @work_orders = WorkOrder.grindable.accessible_by(current_ability).search(params[:search]).order("tuned_at desc, tuned").page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @work_orders }
      format.xml  { render xml: @work_orders }
    end
  end
  
  # GET /work_orders/receive
  def new_grind
    @work_order_item = WorkOrderItem.new(grinded_by_id: (User.where(name: cookies[:grinded_by]).first||current_user).id)
    respond_to do |format|
      format.html 
    end
  end

  # POST /work_orders/issue
  def create_grind
    @work_order_item = WorkOrderItem.ungrinded.search({serial_no: params[:work_order_item][:serial_no]}).first
    p @work_order_item.inspect
    grind_params = { grinded_by_id: (User.where(name: cookies[:grinded_by]).first || current_user).id, 
                     grinding_machine: params[:work_order_item][:grinding_machine],
                     grinding_mode: params[:work_order_item][:grinding_mode],
                     grinding_man_hour: params[:work_order_item][:grinding_man_hour],
                     grinded: true }


    respond_to do |format|
      if @work_order_item && @work_order_item.grind(grind_params)
        format.html { redirect_to grind_work_orders_url, notice: I18n.t('controllers.update_success', name: @work_order_item.class.model_name.human) }
        format.json { head :no_content }
        format.xml  { head :no_content }
      else
        format.html { render action: "new_grind" }
        format.json { render json: @work_order_item.errors, status: :unprocessable_entity }
        format.xml  { render xml: @work_order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callback to share common setup or constraints between actions
  def load_work_order
    @work_order = WorkOrder.accessible_by(current_ability).find(params[:id])
  end
  
  # User this method to whitelist the permissible parameters. Example:
  #   params.require(:person).permit(:name, :age)
  #
  # Also, you can specialize this method with per-user checking of permissible
  # attributes.
  def work_order_params
    params.require(:work_order).permit()
  end
end
