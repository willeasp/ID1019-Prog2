defmodule Bintree do
    # :nil # empty tree
    # {:leaf, value} # a leaf
    # {:node, value, left, right} # a node

    def member(_, :nil) do :no end
    def member(e, {:leaf, e}) do :yes end
    def member(_, {:leaf, _}) do :no end

    def member(e, {:node, e, _, _}) do :yes end
    def member(e, {:node, v, left, _}) when e < v do
        member(e, left)
    end
    def member(e, {:node, _, _, right})  do
        member(e, right)
    end
    

    def insert(e, :nil)  do  {:leaf, e}  end
    def insert(e, {:leaf, v}) when e < v  do  {:node, v, {:leaf, e}, :nil}   end
    def insert(e, {:leaf, v}) do  {:node, e, :nil, {:leaf, v}}   end
    def insert(e, {:node, v, left, right }) when e < v do
        {:node, v, insert(e, left), right }
    end
    def insert(e, {:node, v, left, right })  do
        {:node, v, left, insert(e, right)}
    end


    def delete(e, {:leaf, e}) do  :nil  end
    def delete(e, {:node, e, :nil, right}) do  right  end
    def delete(e, {:node, e, left, :nil}) do  left  end
    def delete(_e, {:node, _e, left, right}) do
        {:leaf, v} = reightmost(left)
        {:node, v, delete(v, left), right}
    end
    def delete(e, {:node, v, left, right}) when e < v do
        {:node, v,  delete(e, left),  right}
    end
    def delete(e, {:node, v, left, right})  do
        {:node, v,  left,  delete(e, right)}
    end


    def reightmost({:leaf, e}) do {:leaf, e} end
    def reightmost({:node, _, _ , right}) do  reightmost(right)  end


    # A key-value store
    # :nil                              # an empty tree
    # {:node, key, value, left, right}  # a node with a key (integer) and value (any)

    def lookup(x, {:node, x, value, _, _}) do {:ok, value} end
    def lookup(x, {:node, _, _, :nil, right}) do lookup(x, right) end
    def lookup(x, {:node, _, _, left, :nil}) do lookup(x, left) end
    def lookup(_, {:node, _, _, :nil, :nil}) do :no end
    def lookup(x, {:node, key, _, left, _}) when x < key do
        lookup(x, left)
    end
    def lookup(x, {:node, _, _, _, right}) do
        lookup(x, right)
    end


    def remove(x, {:node, x, _, :nil, :nil}) do :nil end
    def remove(x, {:node, x, _, :nil, right}) do right end
    def remove(x, {:node, x, _, left, :nil}) do left end
    def remove(x, {:node, x, _, left, right}) do
        {:node, key, val, _, _} = rightmost(left)
        {:node, key, val, remove(key, left), right}
    end
    def remove(x, {:node, key, _, left, right}) when x < key do
        {:node, key, remove(x, left), right}
    end
    def remove(x, {:node, key, _, left, right}) do
        {:node, key, left, remove(x, right)}
    end

    def rightmost({:node, key, v, left, :nil}) do {:node, key, v, left, :nil} end
    def rightmost({:node, _, _, _, right}) do rightmost(right) end


    def add({x, v}, :nil) do {:node, x, v, :nil, :nil} end
    def add({x, v}, {:node, x, _, left, right}) do {:node, x, v, left, right} end
    def add({x, v}, {:node, key, val, left, right}) when x < key do
        {:node, key, val, add({x, v}, left), right}
    end
    def add({x, v}, {:node, key, val, left, right}) do
        {:node, key, val, left, add({x, v}, right)}
    end
    

end


IO.inspect(

    Bintree.add({3, :new}, {
        :node,
        5,
        :five,
        {
            :node,
            3,
            :three,
            {
                :node,
                1,
                :one,
                :nil,
                :nil
            },
            :nil
        },
        {
            :node,
            7,
            :seven,
            {
                :node,
                6,
                :six,
                :nil,
                :nil
            },
            {
                :node,
                8,
                :eight,
                :nil,
                :nil
            }
        }
    })

)
