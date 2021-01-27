defmodule Deriv do
    @type literal() ::
        {:const, number()}  |
        {:const, atom()}    |
        {:var, atom()}

    @type expr() ::
        {:add, expr(), expr()}  |
        {:mul, expr(), expr()}  |
        literal()

    def deriv({:const, _}, _), do: {:const, 0}

    def deriv({:var, v}, v), do: {:const, 1}
    
    def deriv({:var, y}, _), do: {:var, y}
    
    def deriv({:mul, e1, e2}, v), do: {:add, {:mul, deriv(e1,v), e2}, {:mul, e1, deriv(e2,v)}}
    
    def deriv({:add, e1, e2}, v), do: {:add, deriv(e1,v), deriv(e2,v)}


    def beautify({:const, n}), do: n
    def beautify({:var, v}), do: v
    # def beauti({_, v}), do: v
    def beautify({:mul, e1, e2}), do: [beautify(e1), "*", beautify(e2)]
    def beautify({:add, e1, e2}), do: [beautify(e1), "+", beautify(e2)]

    
    def stringify(ls) do
        if ls == [] do
            ""
        else
            [x | y] = ls
            if is_list(x) do
                "(" <> stringify(x) <> stringify(y) <> ")"
            else
                "#{x} " <> stringify(y)
            end
        end
    end
    
end

# [1,2,3] => 1 2 3  [1, [2,[3]]] => 1 2 3

# {:add, {:add, {:mul, {:const, 2}, {:mul, {:var, :x}, {:var, :x} } }, {:mul, {:const, 3}, {:var, :x}}}, {:const, 5}}

# {:mul, {:const, 2}, {:mul, {:var, :x}, {:var, :x} } }

# 2x^2 + 3x + 5

# 4x + 3