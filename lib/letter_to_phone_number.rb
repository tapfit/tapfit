module LetterToPhoneNumber

  def self.get_number_from_letter(char)
    two = ['a','A','b','B','c','C']
    three = ['d','D','e','E','f','F']
    four = ['g','G','h','H','i','I']
    five = ['j','J','k','K','l','L']
    six = ['m','M','n','N','o','O']
    seven = ['p','P','q','Q','r','R','s','S']
    eight = ['t','T','u','U','v','V']
    nine = ['w','W','X','x','y','Y','z','Z']
    if two.include?(char)
      return 2
    elsif three.include?(char)
      return 3
    elsif four.include?(char)
      return 4
    elsif five.include?(char)
      return 5
    elsif six.include?(char)
      return 6
    elsif seven.include?(char)
      return 7
    elsif eight.include?(char)
      return 8
    elsif nine.include?(char)
      return 9
    else
      return nil
    end
  end
end
