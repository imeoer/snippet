#!/usr/bin/env ruby

# A Matrix Class For Matrix Addition And Multiplication

require 'test/unit'

# Define Matrix Class
class Matrix
    attr_accessor :val

    def initialize(*para)
        case para.size
        # Matrix Init By M * N
        when 1
            val = para[0]
            col = val[0].size if val[0]
            unless val.all? {|row| row.size.eql?(col)}
                raise ArgumentError, "Matrix require equal number of every column"
            end
            @ary = val
        # Matrix Init From Array
        when 2
            @ary = Array.new(para[0]) {Array.new(para[1], 0)}
        else
            raise ArgumentError, "Matrix initial argument invalid"
        end
    end

    # Get Matrix Number Of Rows
    def rows
        @ary.size
    end

    # Get Matrix Number Of Columns
    def cols
        return 0 unless @ary[0]
        @ary[0].size
    end

    # For Print
    def to_s()
        @ary.to_s
    end

    # Get Matrix Rows
    def [](val)
        @ary[val]
    end

    # Matrix Addition
    def +(val)
        # A[m][n], B[m][n]
        if not (self.rows.eql?(val.rows) and self.cols.eql?(val.cols))
            raise ArgumentError, "Matrix Addition require equal number of rows and columns"
        end
        m = self.rows
        n = self.cols
        ret = Matrix.new(m, n)
        for j in 0..n - 1
            for i in 0..m - 1
                ret[i][j] = @ary[i][j] + val[i][j]
            end
        end
        ret
    end

    # Matrix Multiplication
    def *(val)
        # A[m][n], B[n][p]
        n = self.cols
        if not n.eql?(val.rows)
            raise ArgumentError, "Matrix Multiplication require equal number of multiplicand's columns and multiplier's rows"
        end
        m = self.rows
        p = val.cols
        ret = Matrix.new(m, p)
        # Should Be Faster If Using Strassen Algorithm
        for i in 0..m - 1
            for j in 0..p - 1
                for k in 0..n - 1
                    ret[i][j] += @ary[i][k] * val[k][j]
                end
            end
        end
        ret
    end
end

# Unit Test For Matrix Class
class TestMatrix < Test::Unit::TestCase
    def test_initialize
        assert_raise(ArgumentError) {Matrix.new([[1, 2], [3]])}
        Matrix.new(3, 4)
        Matrix.new([[1, 2], [3, 4]])
    end

    def test_addition
        a = Matrix.new([[1, 2], [3, 4]])
        b = Matrix.new([[5, 6], [7, 8]])
        c = Matrix.new([[5, 6]])
        assert_raise(ArgumentError) {a + c}
        a + b
    end

    def test_multiplication
        a = Matrix.new([[1, 2], [3, 4]])
        b = Matrix.new([[5, 6, 7], [8, 9, 10]])
        assert_raise(ArgumentError) {b * a}
        a * b
    end
end
