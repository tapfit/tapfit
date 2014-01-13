
class Stats

  attr_accessor :most_recent_purchases, :total_purchases, :total_amount_purchased, :wow_purchase_total, :wow_purchase_total_percentage, :wow_purchase_amount, :wow_purchase_amount_percentage, :total_registers, :wow_register_total, :wow_register_total_percentage


  def initialize
    @total_purchases = Receipt.all.count + Credit.where("package_id IS NOT NULL").count
    @total_amount_purchased = Receipt.all.sum('price') + Credit.joins(:package).where("package_id IS NOT NULL").sum('packages.amount')
    @wow_purchase_total = get_week_purchase_total
    @wow_purchase_total_percentage = "#{sprintf("%.2f", get_wow_purchase_total_percentage)}%"
    @wow_purchase_amount = get_week_purchase_amount
    @wow_purchase_amount_percentage = "#{sprintf("%.2f", get_wow_purchase_amount_percentage)}%"
    @total_registers = User.all.count
    @wow_register_total = get_week_register_amount
    @wow_register_total_percentage = "#{sprintf("%.2f", get_wow_register_percentage)}%"
  end

  private

  def self.weeks_receipts
    return Receipt.where("created_at BETWEEN ? AND ?", DateTime.now - 7.days, DateTime.now)
  end

  def self.last_weeks_receipts
    return Receipt.where("created_at BETWEEN ? AND ?", DateTime.now - 14.days, DateTime.now - 7.days)
  end

  def self.weeks_packages
    return Credit.where("credits.created_at BETWEEN ? AND ?", DateTime.now - 7.days, DateTime.now).where("package_id IS NOT NULL")
  end

  def self.last_weeks_packages
    return Credit.where("credits.created_at BETWEEN ? AND ?", DateTime.now - 14.days, DateTime.now - 7.days).where("package_id IS NOT NULL")
  end

  def self.weeks_registers
    return User.where("created_at BETWEEN ? AND ?", DateTime.now - 7.days, DateTime.now)
  end

  def self.last_weeks_registers
    return User.where("created_at BETWEEN ? AND ?", DateTime.now - 14.days, DateTime.now - 7.days)
  end

  def get_week_purchase_total
    total = Stats.weeks_receipts.count
    total = total + Stats.weeks_packages.count
    return total
  end 

  def get_wow_purchase_total_percentage
    total = Stats.last_weeks_receipts.count
    total = total + Stats.last_weeks_packages.count
    return ((@wow_purchase_total.to_f - total.to_f) / total.to_f) * 100 if total != 0
  end

  def get_week_purchase_amount
    amount = Stats.weeks_receipts.sum('price')
    amount = amount + Stats.weeks_packages.joins(:package).sum('packages.amount')
    return amount
  end

  def get_wow_purchase_amount_percentage
    amount = Stats.last_weeks_receipts.sum('price')
    amount = amount + Stats.last_weeks_packages.joins(:package).sum('packages.amount')
    return ((@wow_purchase_amount.to_f - amount.to_f) / amount.to_f) * 100 if amount != 0
  end

  def get_week_register_amount
    total = Stats.weeks_registers.count
  end

  def get_wow_register_percentage
    this_total = Stats.weeks_registers.count
    last_total = Stats.last_weeks_registers.count
    return ((this_total.to_f - last_total.to_f) / last_total.to_f) * 100 if last_total != 0
  end
end
