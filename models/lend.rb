class Lend < ActiveRecord::Base
  belongs_to :library
  belongs_to :book

  validate :checkout_before_due, :checkout_before_checkin
  after_save :update_revenue, :extended

  # validation
  def checkout_before_due
    if !checkout.nil? && !due.nil?
      if checkout > due
        errors.add(:due, "due date must be after checkout")
      end
    end
  end

  # validation
  def checkout_before_checkin
    if !checkout.nil? && !checkin.nil?
      if checkout > checkin
        errors.add(:checkin, "checkin date must be after checkout")
      end 
    end
  end

  def overdue?
    if checkin.nil?
      due < Date.today
    else
      due < checkin
    end
  end

  def fees
    if overdue? && checkin
      (checkin - due) * library.late_fee
    end
  end

  def days
      due - checkout
  end

  private

  def update_revenue
    if overdue? && checkin
      library.revenue += fees
      library.save
    end
  end

end
