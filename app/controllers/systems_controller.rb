class SystemsController < ApplicationController
  before_action :authenticate_user!, only: [:add_to_cart]

  def index
    @cohort = Cohort.find_by(id: params[:cohort_id])
    @systems = @cohort.systems.order(:start_date, :title) unless @cohort.nil? || @cohort.inactive?
    redirect_to find_cohorts_path if @systems.blank?
  end

  def show
    @system= System.find(params[:id])
    @registrant = current_user.registrants.where(paid: true).where(system_id: @system.id).first if current_user
    unless @registrant.present?
      @registrant = Registrant.new(:system_id => @system.id)
    end
  end

  def add_to_cart
    @system = System.find(params["id"])
    unless @system.cohort.active? && @system.registration_open?
      redirect_to systems_path and return
    end
    if Registrant.find_by(system_id: params["id"], user_id: current_user.id, paid: true)
      flash[:warning] = "You've already registered for this system"
      redirect_to system_path(params["id"]) and return
    end
    @registrant = current_user.registrants.create(:system_id => params["id"], :paid => false, :uuid => SecureRandom.uuid)
    if @system.full?
      flash[:warning] = "Unfortunately that system has sold out!"
      redirect_to systems_path
    elsif @registrant.valid?
      registrants = Cart.decode_cart(cookies)
      registrants |= [@registrant]
      cookies[:registrants] = Cart.encode_cart(registrants)
      flash[:success] = "Ticket added to cart."
      redirect_to cart_systems_path
    else
      render :show
    end
  end

  def remove_from_cart
    registrants = Cart.decode_cart(cookies)
    deleted_registrants_cohort_id = nil
    registrants.delete_if do |registrant|
      if registrant.uuid == params[:uuid]
        deleted_registrants_cohort_id = registrant.system.cohort.id
        true
      else
        false
      end
    end
    cookies[:registrants] = Cart.encode_cart(registrants)
    redirect_to cohorts_cart_systems_path(:cohort_id => deleted_registrants_cohort_id)
  end

  def cart
    registrants = Cart.decode_cart(cookies)
    @structured_cart = Cart.structured_cart(registrants)
  end

  def cohorts_cart
    @cohort = Cohort.find_by(:id => params[:cohort_id])
    all_registrants = Cart.decode_cart(cookies)
    system_ids = @cohort.systems.map{ |system| system.id }
    @registrants = all_registrants.select{ |registrant| system_ids.include?(registrant.system_id) }
    redirect_to cohort_path(params[:cohort_id]) if @registrants.blank?
  end
end
