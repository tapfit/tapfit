class PassDetail < ActiveRecord::Base

  @@class_based = 
    { 
      'instructions' => 
        'All you need to do is say your name to whomever is signing in fellow fitness enthusiasts to your class. TapFit has taken care of the rest. Enjoy your workout!',
      'fine_print' =>
        'This pass is good for the specific class purchased. 24-hour cancellation notice required for a full refund. For any questions or concerns, please email us at support@tapfit.co or call us at (888) 487 - 9301.'
    }

  @@gym_based = 
    {
      'instructions' =>
        'Show this pass to the front desk and mention your name. Walk in and enjoy your workout!',
      'fine_print' =>
        'This pass is good for the day purchased. 24-hour cancellation notice before the start of this pass is required. For any questions or concerns, please email us at support@tapfit.co or call us at (888) 487 - 9301.'
    }
  before_save :set_details

  def set_details
    # pass_type: 0 - class based facility
    # pass_type: 1 - gym based facility

    if (self.pass_type.nil?)
      self.pass_type = 0
    end

    if (self.instructions.nil?) 
      if self.pass_type == 0
        self.instructions = @@class_based['instructions']
      elsif self.pass_type == 1
        self.instructions = @@gym_based['instructions']
      end
    end

    if (self.fine_print.nil?)
      if self.pass_type == 0
        self.fine_print = @@class_based['fine_print']
      elsif self.pass_type == 1
        self.fine_print = @@gym_based['fine_print']
      end
    end
  end

end
