defmodule Vector do

    def smul({x1, x2, x3}, s) do 
        {x1*s, x2*s, x3*s} 
    end

    def sub({x1, x2, x3}, {y1, y2, y3}) do 
        {x1-y1, x2-y2, x3-y3}
    end

    def add({x1, x2, x3}, {y1, y2, y3}) do
        {x1+y1, x2+y2, x3+y3}
    end

    def norm({x1, x2, x3}) do
        :math.sqrt(x1*x1 + x2*x2 + x3*x3)
    end

    def dot({x1, x2, x3}, {y1, y2, y3}) do
        x1*y1 + x2*y2 + x3*y3
    end

    def normalize(x) do
        n = norm(x)
        smul(x, 1/n)
    end

    def test() do
        IO.inspect(smul({1, 1, 1}, 3), label: "{3, 3, 3}")
        IO.inspect(sub({1, 1, 1}, {1, 1, 1}), label: "{0, 0, 0}")
        IO.inspect(add({1, 1, 1}, {1, 1, 1}), label: "{2, 2, 2}")
        IO.inspect(norm({3, 4, 0}), label: "5.0")
        IO.inspect(dot({2, 7, 1}, {8, 2, 8}), label: "38")
        IO.inspect(normalize({2, 0, 0}), label: "{1.0, 0, 0}")
    end

end

Vector.test()