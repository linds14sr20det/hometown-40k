class CohortsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_s3_direct_post, only: [:new, :edit, :create, :update]

  def index

    @active_cohort = current_user.cohorts.where(active: true)
    @cohorts = current_user.cohorts.where(active: false).paginate(page: params[:page], :per_page => 12)
  end

  def new
    @cohort = Cohort.new
    @cohort.build_info
  end

  def create
    @cohort = current_user.cohorts.create(cohort_params)
    @cohort.active = true if params[:activate_cohort]
    if @cohort.save
      flash[:success] = "Cohort created."
      redirect_to cohorts_path
    else
      render 'new'
    end
  end

  def edit
    @cohort = current_user.cohorts.find(params[:id])
  end

  def update
    @cohort = current_user.cohorts.find(params[:id])
    c_p = cohort_params
    c_p[:active] = true if params[:activate_cohort]
    if @cohort.update_attributes(c_p)
      flash[:success] = "Tournament updated"
      redirect_to cohorts_path
    else
      redirect_to edit_cohort_path(@cohort)
    end
  end

  def destroy
    if current_user.cohorts.find(params[:id]).destroy
      flash[:success] = "Cohort deleted"
    else
      flash[:warning] = "Cohort has systems with players. The cohort was not deleted."
    end
    redirect_to cohorts_path
  end

  private

    def cohort_params
      params.require(:cohort).permit(:start_at, :end_at, :descriptive_date, :active, :attachment_url, systems_attributes: [:id, :title, :description, :descriptive_date, :start_date, :max_players, :cost, :rounds, :_destroy], info_attributes: [:id, :body])
    end

    def set_s3_direct_post
      @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
    end
end
