class JacksController < ApplicationController
  load_and_authorize_resource

  # GET /jacks
  def index
    @jacks = Jack.all
  end

  # GET /jacks/new
  def new
    @jack = Jack.new
  end

  # GET /jacks/1/edit
  def edit
  end

  # POST /jacks
  def create
    @jack = Jack.new(jack_params)

    if @jack.save
      redirect_to edit_jack_path(@jack), notice: 'Jack was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /jacks/1
  def update
    if @jack.update(jack_params)
      redirect_to edit_jack_path(@jack), notice: 'Jack was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /jacks/1
  def destroy
    @jack.destroy
    redirect_to jacks_url, notice: 'Jack was successfully destroyed.'
  end

  private

  # param keys permitted with <action>_details ability
  def detail_keys
    %i[email password password_confirmation]
  end

  # param keys permitted with <action>_occupations ability
  def occupation_keys
    [ occupations_attributes: %i[id trade_id master _destroy] ]
  end

  # Only allow a trusted parameter "white list" through.
  def jack_params
    action = params[:action]
    permitted_keys = []
    permitted_keys += detail_keys if can? :"#{action}_details", @jack
    permitted_keys += occupation_keys if can? :manage, Occupation
    params.require(:jack).permit(permitted_keys)
  end
end
