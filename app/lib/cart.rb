class Cart
  def self.badge_count(cookies)
    count = decode_cart(cookies).count
    return "cart-badge-max" if count > 5
    "cart-badge-#{count}"
  end

  def self.decode_cart(cookies)
    registrants = []
    unless cookies[:registrants].nil?
      JSON.parse(cookies[:registrants]).each do |registrant|
        registrants << Registrant.new(JSON.parse(registrant))
      end
    end
    registrants
  end

  def self.encode_cart(registrants)
    JSON.generate(registrants.map!{|registrant| registrant.to_json})
  end

  def self.structured_cart(registrants)
    cart = {}
    registrants.each do |registrant|
      cohort = registrant.system.cohort
      cart.merge!({cohort => [registrant]}){ |key, val1, val2| Array(val1) << val2.first }
    end
    cart
  end

  def self.registrants_total(registrants)
    registrants.sum { |registrant| registrant.system.cost }
  end
end
