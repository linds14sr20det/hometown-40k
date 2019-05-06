class TicketsController < ApplicationController
  before_action :authenticate_user!, only: [:add_to_cart]

  def index
    @cohort = Cohort.find_by(id: params[:cohort_id])
    @tickets = @cohort.systems.order(:start_date, :title) unless @cohort.nil? || @cohort.inactive?
    redirect_to find_cohorts_path if @tickets.blank?
  end

  def show
    @ticket = System.find(params[:id])
    @registrant = Registrant.new(:system_id => @ticket.id)
  end

  def add_to_cart
    @ticket = System.find(params["id"])
    unless @ticket.cohort.active? && @ticket.cohort.registration_open?
      redirect_to tickets_path and return
    end
    @registrant = Registrant.find_by(user_id: current_user.id, system_id: params["id"], paid: false)
    @registrant ||= current_user.registrants.create(:system_id => params["id"], :paid => false, :uuid => SecureRandom.uuid)
    if @ticket.full?
      flash[:warning] = "Unfortunately that system has sold out!"
      redirect_to tickets_path
    elsif @registrant.valid?
      registrants = Cart.decode_cart(cookies)
      registrants |= [@registrant]
      cookies[:registrants] = Cart.encode_cart(registrants)
      flash[:success] = "Ticket added to cart."
      redirect_to cart_tickets_path
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
    redirect_to cohorts_cart_tickets_path(:cohort_id => deleted_registrants_cohort_id)
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
  end
end
