
class Stats

  attr_accessor :most_recent_purchases, :total_purchases, :total_amount_purchased, :wow_purchase_total, :wow_purchase_total_percentage, :wow_purchase_amount, :wow_purchase_amount_percentage, :total_registers, :wow_register_total, :wow_register_total_percentage, :start_date


  def initialize(start_date)
    @start_date = start_date
    puts @start_date
    @total_purchases = Receipt.where("created_at < ?", @start_date).count + Credit.where("created_at < ?", @start_date).where("package_id IS NOT NULL").count
    @total_amount_purchased = Receipt.where("created_at < ?", @start_date).sum('price') + Credit.joins(:package).where("package_id IS NOT NULL").where("credits.created_at < ?", @start_date).sum('packages.amount')
    @wow_purchase_total = get_week_purchase_total
    @wow_purchase_total_percentage = "#{sprintf("%.2f", get_wow_purchase_total_percentage)}%"
    @wow_purchase_amount = get_week_purchase_amount
    @wow_purchase_amount_percentage = "#{sprintf("%.2f", get_wow_purchase_amount_percentage)}%"
    @total_registers = User.where("created_at < ?", @start_date).count
    @wow_register_total = get_week_register_amount
    @wow_register_total_percentage = "#{sprintf("%.2f", get_wow_register_percentage)}%"
  end

  private

  def weeks_receipts
    return Receipt.where("created_at BETWEEN ? AND ?", @start_date - 7.days, @start_date)
  end

  def last_weeks_receipts
    return Receipt.where("created_at BETWEEN ? AND ?", @start_date - 14.days, @start_date - 7.days)
  end

  def weeks_packages
    return Credit.where("credits.created_at BETWEEN ? AND ?", @start_date - 7.days, @start_date).where("package_id IS NOT NULL")
  end

  def last_weeks_packages
    return Credit.where("credits.created_at BETWEEN ? AND ?", @start_date - 14.days, @start_date - 7.days).where("package_id IS NOT NULL")
  end

  def weeks_registers
    return User.where("created_at BETWEEN ? AND ?", @start_date - 7.days, @start_date)
  end

  def last_weeks_registers
    return User.where("created_at < ?", @start_date - 7.days)
  end

  def get_week_purchase_total
    total = weeks_receipts.count
    total = total + weeks_packages.count
    return total
  end 

  def get_wow_purchase_total_percentage
    total = last_weeks_receipts.count
    total = total + last_weeks_packages.count
    if total != 0
      return ((@wow_purchase_total.to_f - total.to_f) / total.to_f) * 100
    elsif @wow_purchase_total != 0
      return 100
    else
      return -100
    end
  end

  def get_week_purchase_amount
    amount = weeks_receipts.sum('price')
    amount = amount + weeks_packages.joins(:package).sum('packages.amount')
    return amount
  end

  def get_wow_purchase_amount_percentage
    amount = last_weeks_receipts.sum('price')
    amount = amount + last_weeks_packages.joins(:package).sum('packages.amount')
    if amount != 0
      return ((@wow_purchase_amount.to_f - amount.to_f) / amount.to_f) * 100
    elsif @wow_purchase_amount != 0
      return 100
    else
      return -100
    end
  end

  def get_week_register_amount
    total = weeks_registers.count
  end

  def get_wow_register_percentage
    this_total = weeks_registers.count
    last_total = last_weeks_registers.count
    if last_total != 0
      return ((this_total.to_f) / last_total.to_f) * 100
    else
      return -100
    end
  end
end
