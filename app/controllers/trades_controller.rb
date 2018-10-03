# Controller for trade resource.
#
# This controller is very similar to JackController, see it for all the details
class TradesController < ApplicationController
  load_and_authorize_resource

  # GET /trades
  def index
  end

  # GET /trades/1
  def show
  end

  # GET /trades/new
  def new
  end

  # GET /trades/1/edit
  def edit
  end

  # POST /trades
  def create
    if @trade.save
      redirect_to @trade, notice: 'Trade was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /trades/1
  def update
    if @trade.update(trade_params)
      redirect_to @trade, notice: 'Trade was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /trades/1
  def destroy
    @trade.destroy
    redirect_to trades_url, notice: 'Trade was successfully destroyed.'
  end

  private

  # param keys permitted with <action>_details ability
  def detail_keys
    %i[name]
  end

  # param keys permitted with <action>_occupations ability
  def occupation_keys
    [ occupations_attributes: %i[id jack_id master _destroy] ]
  end

  # Only allow a trusted parameter "white list" through.
  def trade_params
    action = params[:action]
    permitted_keys = []
    permitted_keys += detail_keys if can? :"#{action}_details", @trade
    permitted_keys += occupation_keys if can? :manage, Occupation
    params.require(:trade).permit(permitted_keys)
  end
end
