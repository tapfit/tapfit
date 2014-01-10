
class Stats

  attr_accessor :most_recent_purchases, :total_purchases, :wow_purchase_total, :wow_purchase_total_percentage, :wow_purchase_amount, :wow_purchase_amount_percentage, :wow_register_total, :wow_register_total_percentage

  def initialize
    @total_purchases = Receipt.all.count + Credit.where("package_id IS NOT NULL").count
    @wow_purchase_total = get_week_purchase_total
    @wow_purchase_total_percentage = "#{sprintf("%.2f", get_wow_purchase_total_percentage)}%"
  end

  private

  def get_week_purchase_total
    total = Receipt.where("created_at BETWEEN ? AND ?", DateTime.now - 7.days, DateTime.now).count
    total = total + Credit.where("created_at BETWEEN ? AND ?", DateTime.now - 7.days, DateTime.now).where("package_id IS NOT NULL").count
    return total
  end 

  def get_wow_purchase_total_percentage
    total = Receipt.where("created_at BETWEEN ? AND ?", DateTime.now - 14.days, DateTime.now - 7.days).count
    total = total + Credit.where("created_at BETWEEN ? AND ?", DateTime.now - 14.days, DateTime.now - 7.days).where("package_id IS NOT NULL").count
    return ((@wow_purchase_total.to_f - total.to_f) / total.to_f) * 100 if total != 0
  end
end
