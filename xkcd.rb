class Xkcd

  attr_reader :menu, :prices

  def initialize(file = './data_file')
    @file = read_file(file)
    @menu = {}
    set_up
  end

  def formatted_solution
    if find_combinations_matches.empty?
      puts "Sorry, no combination of dishes that equal that price."
    else
      puts "There is/are #{find_combinations_matches.count} combination(s) that total(s) to $#{self.menu['total price'].to_f / 100}.", ""
      find_combinations_matches.each_with_index do |combo, i|
        puts "Combo #{i + 1}: "
        combo.each_with_index do |num_of_food_items, i|
          next if num_of_food_items == 0
          food_item = self.menu.select {|k,v| v == self.prices[i] }.to_a.flatten
          puts "#{num_of_food_items} order(s) of #{food_item.first} ($#{food_item.last.to_f / 100}/per unit) totalling $#{(num_of_food_items * self.prices[i]).to_f / 100}."
        end
        puts
      end
    end
  end

private

  def find_combinations_matches
    possible_combinations = []
    create_repeated_permutations(@highest_possible_quantity, @total_items).each do |permutation|
      total_bill = 0
      permutation.each_with_index do |quantity, i|
        break if total_bill > self.menu['total price']
        total_bill += (self.prices[i] * quantity)
      end
      possible_combinations << permutation if total_bill == self.menu['total price']
    end
    possible_combinations
  end

  def set_up
    create_menu && create_prices
    @highest_possible_quantity = self.menu['total price'] / self.prices[0]
    @total_items = self.prices.count
  end

  def read_file(file)
    File.read(file)
  end

  def create_menu
    @file.each_line do |line|
      item = line.chomp.gsub(/[^A-Za-z\s]/, '')
      price = line.gsub(/[^\d]/, '').to_i
      @menu[item] = price unless item == ''
      @menu['total price'] = price if item == ''
    end
  end

  def create_prices
    @prices = @menu.values
    @prices.shift
    @prices = self.prices.sort
  end

  def create_repeated_permutations(highest_possible_quantity, total_items)
    (0..highest_possible_quantity).to_a.repeated_permutation(total_items).to_a
  end

end

Xkcd.new.formatted_solution
