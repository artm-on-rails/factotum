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

  # Only allow a trusted parameter "white list" through.
  def jack_params
    params.require(:jack).permit(
      :email,
      :password,
      :password_confirmation,
      occupations_attributes: %i[id trade_id master _destroy]
    )
  end
end
