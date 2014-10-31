class Xkcd

  attr_reader :file, :prices

  def initialize(file = './data_file')
    @file = read_file(file)
    @prices = []
  end

  def find_combinations
    find_prices
    total_price = @prices.shift
    total_items = self.prices.count
    find_permutations(total_price, total_items)
  end

private

  def read_file(file)
    File.read(file)
  end

  def find_prices
    self.file.each_line { |line| @prices << line.gsub(/[^\d\.]/, '').to_f }
  end

  def find_permutations(total_price, total_items)
    i = 1
    while i <= total_items
      self.prices.permutation.to_a(i).each do |one_combination|
        if one_combination.reduce(:+) == total_price
          return one_combination
        end
      end
      i += 1
    end
    puts 'There were no matching combinations.'
  end

end
