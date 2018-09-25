class JacksController < ApplicationController
  load_and_authorize_resource
  before_action :authorize_nested_attributes_for_occupations, only: %i[create update]

  # GET /jacks
  def index
    @jacks = Jack.all
  end

  # GET /jacks/1
  def show
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
      redirect_to @jack, notice: 'Jack was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /jacks/1
  def update
    if @jack.update(jack_params)
      redirect_to @jack, notice: 'Jack was successfully updated.'
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

  def authorize_nested_attributes_for_occupations
    return unless jack_params.include?(:occupations_attributes)
    jack_params[:occupations_attributes].each do |attributes|
      id = attributes[:id]
      occupation = if id.present?
        Occupation.find(id)
      else
        Occupation.new(attributes)
      end
      if attributes.include?(:_destroy)
        authorize! :destroy, occupation
      elsif attributes.include?(:id)
        authorize! :update, occupation
        occupation.assign_attributes(attributes)
        authorize! :update, occupation
      else
        authorize! :create, occupation
      end
    end
  end
end
