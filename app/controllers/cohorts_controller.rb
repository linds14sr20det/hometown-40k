class CohortsController < ApplicationController
  before_action :authenticate_user!, except: [:find, :search, :show]
  before_action :set_s3_direct_post, only: [:new, :edit, :create, :update]

  def index
    @active_cohort = current_user.cohorts.where(active: true)
    @cohorts = current_user.cohorts.where(active: false).paginate(page: params[:page], :per_page => 12)
  end

  def show
    @cohort = Cohort.where(active: true).where(id: params[:id]).first
  end

  def new
    @cohort = Cohort.new
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

  def find
    params['timeframe'] ||= 'future'
    @cohorts = find_cohorts_by_location
  end

  def search
    @cohorts = if params["search_term"].length == 0
                 find_cohorts_by_location
               else
                 response = Cohort.search params["search_term"]
                 ids = response.results.map { |r| r._id.to_i }
                 Cohort.where(id: ids).where(active: true).where(date_range).paginate(page: params[:page], per_page: 50)
               end

    render json: { html: render_to_string(partial: 'search') }
  end

  def my_events
    #TODO: This actually needs to be events where the current user is a registrant
    # Registrant and cart need to change
    @cohorts = current_user.cohorts
  end

  private

    def cohort_params
      params.require(:cohort).permit(:name, :body, :street, :city, :state, :country, :start_at, :end_at, :descriptive_date, :active, :attachment_url, systems_attributes: [:id, :title, :description, :descriptive_date, :start_date, :max_players, :cost, :rounds, :_destroy])
    end

    def set_s3_direct_post
      @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
    end

    def find_cohorts_by_location
      location_raw = request.location.coordinates
      coordinates = location_raw.empty? ? [37.751425, -122.419443] : location_raw

      Cohort.where(active: true).where(date_range).near(coordinates, 3000).paginate(page: params[:page], per_page: 50)
    end

    def date_range
      return "end_at < '#{Time.now}'" if params['timeframe'] == 'past'
      return "end_at >= '#{Time.now}' AND start_at <= '#{Time.now}'" if params['timeframe'] == 'in-progress'
      "start_at > '#{Time.now}'" if params['timeframe'] == 'future'
    end
end
