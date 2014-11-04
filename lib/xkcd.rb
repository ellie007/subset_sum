class Xkcd

  attr_reader :file, :menu, :prices

  def initialize(file = './data_file')
    @file = read_file(file)
    @menu = {}
    @prices
  end

  def find_combinations
    set_up.reverse.each do |permutation|
      total_bill = 0
      permutation.each_with_index do |quantity, i|
        next if total_bill > self.menu['total price']
        total_bill += (self.prices[i] * quantity)
      end
      p permutation if total_bill == self.menu['total price']
    end
  end

private

  def set_up
    create_menu && create_prices
    highest_possible_quantity = self.menu['total price'] / self.prices[0]
    total_items = self.prices.count
    find_repeated_permutations(highest_possible_quantity, total_items)
  end

  def read_file(file)
    File.read(file)
  end

  def create_menu
    self.file.each_line do |line|
      item = line.chomp.gsub(/[^A-Za-z\s]/, '')
      price = line.gsub(/[^\d]/, '').to_i
      @menu[item] = price unless item == ''
      @menu['total price'] = price if item == ''
    end
    self.menu
  end

  def create_prices
    @prices = @menu.values
    @prices.shift
    @prices = self.prices.sort
  end

  def find_repeated_permutations(highest_possible_quantity, total_items)
    (0..highest_possible_quantity).to_a.repeated_permutation(total_items).to_a
  end

end
