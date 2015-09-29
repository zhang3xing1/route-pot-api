# require 'smarter_csv'
# # expense_1 = Expense.new(:pos1=>1, :pos2=>2, :car_distance=>58, :car_duration=>20, :bicycle_distance=>58, :bicycle_duration=>15, :foot_distance=>61, :foot_duration=>60)
# require 'matrix'

class Matrix
  public :"[]=", :set_element, :set_component
end

module Tms
  class ExpenseMatrix
    attr_accessor :matrix, :costs

    def initialize(csv_file)
      @costs = SmarterCSV.process(csv_file)
      @matrix_count =  costs.max { |a, b| a[:pos1] <=> b[:pos2] }.keep_if{|k,v| [:pos1, :pos2].include? k}.values.max + 1
      @matrix = Matrix.zero(@matrix_count)
    end

    def generate_matrix_by(key)
      @costs.each do |item|
        @matrix[item[:pos1], item[:pos2]] = item[key].to_s.rjust(5,'0')
      end
    end

    def to_a
      @matrix.to_a
    end

    def count
      @matrix_count
    end

  end


end
