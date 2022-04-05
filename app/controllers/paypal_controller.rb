require 'paypal-sdk-rest'
include PayPal::SDK::REST
include PayPal::SDK::Core::Logging

class PaypalController < ApplicationController
  skip_before_action :verify_authenticity_token

  def checkout
    cohort = Cohort.find_by(:id => params["cohort_id"])
    registrants = JSON.parse(params["registrants"])
    registrants.map!{|registrant| Registrant.new(registrant)}
    systems_with_space = registrants.reject{|registrant| registrant.system.full? }
    invalid_registration = (systems_with_space-registrants) | (registrants-systems_with_space)
    unless invalid_registration.empty?
      invalid_systems = invalid_registration.map(&:system)
      flash[:warning] = "Unfortunately #{invalid_systems.map(&:title).to_sentence} has sold out! It has been removed from your cart."
      cookies[:registrants] = Cart.encode_cart(systems_with_space)
      render json: {success: false} and return
    end
    items = []
    registrants.each do |registrant|
      items << {
          :name => registrant.system.title,
          :sku => registrant.system.id,
          :price => registrant.system.cost,
          :currency => "CAD",
          :quantity => 1,
      }
    end

    total = items.map { |item| item[:price] }.sum

    PayPal::SDK::REST.set_config(
      :client_id => cohort.paypal_client_id,
      :client_secret => cohort.paypal_client_secret,
      ssl_options: { ca_file: nil })

    @payment = Payment.new({
    :intent =>  "sale",
    # ###Payer
    # A resource representing a Payer that funds a payment
    # Payment Method as 'paypal'
    :payer => { :payment_method =>  "paypal" },
    # ###Redirect URLs
    :redirect_urls => {
      :return_url => execute_url,
      :cancel_url => tickets_url
    },
    # ###Transaction
    # A transaction defines the contract of a
    # payment - what is the payment for and who
    # is fulfilling it.
    :transactions => [{
    # Item List
    :item_list => {:items => items},

    # ###Amount
    # Let's you specify a payment amount.
    :amount =>  {
      :total =>  total,
      :currency =>  "CAD" },
    :description =>  "Purchase of event tickets for Hometown 40k." }]})

    # Create Payment and return status
    if @payment.create
      registrants.each do |registrant|
        persisted_registrant = registrant.id.present? ? Registrant.find_by(:id => registrant.id) : Registrant.create(registrant.attributes)
        persisted_registrant.update(:payment_id => @payment.id)
      end
      render json: {success: true, paymentID: @payment.id}
    else
      render json: {success: false}
    end
  end

  def execute
    payment = PayPal::SDK::REST::Payment.find(params[:paymentID])
    if payment.execute(payer_id: params[:payerID])
      registrants = Registrant.where(:payment_id => params[:paymentID])
      registrants.each{ |registrant| registrant.update_attributes(paid: true) }
      cookies.delete(:registrants)
      registrant_groups = registrants.group_by{ |registrant| registrant.user.email }.values
      registrant_groups.each do |registrant_group|
        RegistrantMailer.registration_email(registrant_group).deliver_now
      end
      flash[:success] = "Payment successful."
    else
      render json: {msg: payment.error}
    end
  end
end
