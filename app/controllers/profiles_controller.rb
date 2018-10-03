# frozen_string_literal: true

# Profile (i.e. current_jack) controller
#
# Note: an alternative approach could have been to add non-standard actions
# to the JacksController, reusing some of the common logic
class ProfilesController < ApplicationController
  # this controller has a different resource loading logic from the
  # default load-by-id provided by the CanCanCan. Therefore instead of
  # `load_and_authorize_resource` a custom loading + standard authorization
  # is used
  before_action :assign_jack
  authorize_resource :jack

  # For the rest this controller works similar to the JacksController

  def show
    redirect_to edit_profile_path
  end

  # GET /jacks/1/edit
  def edit; end

  # PATCH/PUT /jacks/1
  def update
    if @jack.update(jack_params)
      redirect_to edit_profile_path, notice: "Profile was successfully updated."
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
