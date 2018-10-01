class ProfilesController < ApplicationController
  before_action :assign_jack
  authorize_resource :jack

  def show
    redirect_to edit_profile_path
  end

  # GET /jacks/1/edit
  def edit
  end

  # PATCH/PUT /jacks/1
  def update
    if @jack.update(jack_params)
      redirect_to edit_profile_path, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  private

  def assign_jack
    @jack = current_jack
  end

  # Only allow a trusted parameter "white list" through.
  def jack_params
    params.require(:jack).permit(%i[email password password_confirmation])
  end
end
