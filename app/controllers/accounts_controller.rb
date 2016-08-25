class AccountsController < ApplicationController
  before_action :authenticate_account!
  after_action :allow_bookingsync_iframe

  # GET /accounts
  # GET /accounts.json
  def index
    if params[:ids].present? or params[:owner_id].present?
      @groups = @groups.where(teacher_id: params[:owner_id]) if params[:owner_id].present?
      @groups = @groups.where(id: params[:ids]) if params[:ids].present?
    else
      @groups = []
    end
    render json: @groups, each_serializer: Openedmodels::PublicGroupSerializer, root: :groups
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = @groups.find(params[:id])
    render json: @group, serializer: Openedmodels::PublicGroupSerializer, root: :group
  rescue ActiveRecord::RecordNotFound
    return render json: {errors: 'Group not found'}, status: :not_found
  end
end
