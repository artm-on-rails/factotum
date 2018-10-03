# frozen_string_literal: true

# Controller for jacks resource
class JacksController < ApplicationController
  # find appropriate Jack(s), checks that `current_jack` can perform current
  # action on him/them, assigns the authorized resources to @jack(s). Thanks
  # to our extension it also looks for presence of nested attributes in
  # `#jack_params` and authorizes them as well.
  load_and_authorize_resource

  # empty action methods below are there as a reminder of the existence of the
  # actions. In these cases what CanCanCan does is enough to pass `@jack` /
  # `@jacks` to the view.

  # GET /jacks
  def index; end

  # GET /jacks/new
  def new; end

  # GET /jacks/1/edit
  def edit
    # redirect to profile editing when attempting to edit oneself
    redirect_to edit_profile_path if @jack == current_jack
  end

  # POST /jacks
  def create
    if @jack.save
      redirect_to edit_jack_path(@jack),
                  notice: "Jack was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /jacks/1
  def update
    if @jack.update(jack_params)
      redirect_to edit_jack_path(@jack),
                  notice: "Jack was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /jacks/1
  def destroy
    @jack.destroy
    redirect_to jacks_url,
                notice: "Jack was successfully destroyed."
  end

  private

  # param keys permitted with <action>_details ability
  def detail_keys
    %i[email password password_confirmation]
  end

  # param keys permitted with <action>_occupations ability
  def occupation_keys
    [occupations_attributes: %i[id trade_id master _destroy]]
  end

  # Only allow a trusted parameter "white list" through.
  # write access to Jack is split into two parts:
  # - can?(:update_details, @jack) allows updating Jack's "own" fields (email,
  #   password)
  # - can?(:manage, Occupation) allows modifying (creating, updating,
  #   destroying) Jack's occupations
  # The combination of these two abilities determines permitted parameters,
  # while finer ability details control actual authorization of the submitted
  # nested attributes.
  #
  # The can?(:update, @jack) ability is still required with any of the
  # finer abilities above to authorize the respective action. This is
  # redundant, especially for :update_details which allways requires :update
  # ability on the same Jack to make any difference, but I didn't figure out how
  # to simplify this.
  def jack_params
    action = params[:action]
    permitted_keys = []
    permitted_keys += detail_keys if can? :"#{action}_details", @jack
    permitted_keys += occupation_keys if can? :manage, Occupation
    params.require(:jack).permit(permitted_keys)
  end
end
