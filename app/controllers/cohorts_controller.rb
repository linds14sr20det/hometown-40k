class CohortsController < ApplicationController
  before_action :authenticate_user!, except: [:find, :search, :show, :cohort_search]
  before_action :set_s3_direct_post, only: [:new, :edit, :create, :update]

  def index
    @active_cohort = current_user.cohorts.where(active: true).order("start_at DESC", "name")
    @cohorts = current_user.cohorts.where(active: false).paginate(page: params[:page], :per_page => 12)
  end

  def show
    @cohort = Cohort.where(active: true).where(id: params[:id]).first
    @paid_registrants = my_paid_registrants_for_cohort(@cohort)
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

  def my_events
    params['timeframe'] ||= 'future'
    @cohorts = Cohort.where(id: my_registered_cohorts_ids).where(date_range)
  end

  def my_search
    @cohorts = if params["search_term"].length == 0
                 Cohort.where(id: my_registered_cohorts_ids).where(date_range)
               else
                 response = Cohort.search params["search_term"]
                 ids = response.results.map { |r| r._id.to_i }
                 # TODO: Use array operator where ids appear in both
                 Cohort.where(id: ids & my_registered_cohorts_ids).where(date_range).paginate(page: params[:page], per_page: 50)
               end

    render json: { html: render_to_string(partial: 'search') }
  end

  def find
    params['timeframe'] ||= 'future'
    @cohorts = find_cohorts_by_location
  end

  def cohort_search
    @cohorts = if params["search_term"].length == 0
                 find_cohorts_by_location
               else
                 response = Cohort.search elasticsearch_dsl(params["search_term"])
                 ids = response.results.map { |r| r._id.to_i }
                 Cohort.where(id: ids).where(active: true).where(date_range).paginate(page: params[:page], per_page: 50)
               end
    render json: { html: render_to_string(partial: 'search') }
  end

  private

  def cohort_params
    params.require(:cohort).permit(:name, :body, :street, :city, :state, :country, :start_at, :end_at, :paypal_client_id, :paypal_client_secret, :active, :attachment_url, systems_attributes: [:id, :title, :description, :start_date, :end_date, :registration_open, :registration_close, :max_players, :cost, :round_individuals, :_destroy])
  end

  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
  end

  def my_registered_cohorts_ids
    # TODO: This needs to not be three queries :facepalm:
    system_ids = current_user.registrants.where(:paid => true).map{ |registrant| registrant.system_id }
    System.where(id: system_ids).map{ |system| system.cohort_id }
  end

  def my_paid_registrants_for_cohort(cohort)
    current_user.registrants.where(paid: true)&.where(system_id: cohort.systems.pluck(:id)) if current_user
  end

  def find_cohorts_by_location
    location_raw = request.location&.coordinates
    # Default lat long is san fran
    coordinates = location_raw.blank? ? [37.7, -122.4] : location_raw
    Cohort.where(active: true).where(date_range).near(coordinates, 15000).paginate(page: params[:page], per_page: 50)
  end

  def date_range
    return "end_at < '#{Time.now}'" if params['timeframe'] == 'past'
    return "end_at >= '#{Time.now}' AND start_at <= '#{Time.now}'" if params['timeframe'] == 'current'
    "start_at > '#{Time.now}'" if params['timeframe'] == 'future'
  end

  def elasticsearch_dsl(term)
    {
      query: {
        fuzzy: {
          name: {
            value: term,
          },
        }
      },
    }
  end
end
