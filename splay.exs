defmodule Splay do
# implementation
# the empty tree
#   nil:  
# a node with a key, value and a left and right branch
#   {:node, key, value, left, right}:  

    # empty node
    def update(nil, key, value) do
        {:node, key, value, nil, nil}
    end
    # key found
    def update({:node, key, _, a, b}, key, value) do
        {:node, key, value, a, b}
    end
    def update({:node, rk, rv, zig, c}, key, value) when key < rk do
        # The general rule where we will do the Zig transformation.
        {:splay, _, a, b} = splay(zig, key)
        {:node, key, value, a, {:node, rk, rv, b, c}}
    end
    def update({:node, rk, rv, a, zag}, key, value) when key >= rk do
        # The general rule where we will do the Zag transformation.
        {:splay, _, b, c} = splay(zag, key)
        {:node, key, value, {:node, rk, rv, a, b}, c}
    end

    # splay

    # splay/2' takes a tree and a key and will return a tuple
    # {:splay, kv, a, b} where kv is the value of the key 
    # (:na if the key is not found) and a and b, the left and right sub-trees
    # empty
    defp splay(nil, _) do
        {:splay, :na, nil, nil}
    end
    # key found
    defp splay({:node, key, value, a, b}, key) do
        {:splay, key, a, b}
    end
    # left or right sub-tree is empty
    defp splay({:node, rk, rv, nil, b}, key) when key < rk do
        # Should go left, but the left branch empty.
        {:splay, :na, nil, {:node, rk, rv, nil, b}}
    end
    defp splay({:node, rk, rv, a, nil}, key) when key >= rk do
        # Should go right, but the right branch empty.
        {:splay, :na, {:node, rk, rv, a, nil}, nil}
    end
    # key is found at the root in the left or right sub-tree
    defp splay({:node, rk, rv, {:node, key, value, a, b}, c}, key) do
        # Found to the left.
        {:splay, key, a, {:node, rk, rv, b, c}}
    end
    defp splay({:node, rk, rv, a, {:node, key, value, b, c}}, key) do
        # Found to the right.
        {:splay, key, {:node, rk, rv, a, b}, c}
    end

    # zig-zag rules

    # Going down left-left, this is the so called zig-zig case. 
    defp splay({:node, gk, gv, {:node, pk, pv, zig_zig, c}, d}, key) 
            when key < gk and key < pk do
        {:splay, value, a, b} = splay(zig_zig, key)
        {:splay, value, a, {:node, pk, pv, b, {:node, gk, gv, c, d}}}
    end
    # Going down left-right, this is the so called zig-zag case. 
    defp splay({:node, gk, gv, {:node, pk, pv, a, zig_zag}, d}, key)
            when key < gk and key >= pk do
        {:splay, value, b, c} = splay(zig_zag, key)
        {:splay, value, {:node, pk, pv, a, b}, {:node, gk, gv, c, d}}
    end
    # going down right-left, this is the so called zag-zig case.
    defp splay({:node, gk, gv, a, {:node, pk, pv, zag_zig, d}}, key)
            when key >= gk and key < pk do
        {:splay, value, b, c} = splay(zag_zig, key)
        {:splay, value, {:node, gk, gv, a, b}, {:node, pk, pv, c, d}}
    end
    # going down right-right, this is the so called zag-zag case.
    defp splay({:node, gk, gv, a, {:node, pk, pv, b, zag_zag}}, key)
            when key >= gk and key >= pk do
        {:splay, value, c, d} = splay(zag_zag, key)
        {:splay, value, {:node, pk, pv, {:node, gk, gv, a, b}, c}, d}
    end

    # test
    def test() do
        insert = [{3, :c}, {5, :e}, {2, :b}, {1, :a}, {7, :g}, {4, :d}, {5, :e}]
        empty = nil
        List.foldl(insert, empty, fn({k, v}, t) -> update(t, k, v) end)
    end    
    
end

IO.inspect(
    Splay.update(
        Splay.update(
            Splay.update(
                Splay.update(
                    Splay.update(nil, 3, :c),
                    5, :e
                ),
                2, :b
            ),
            1, :a
        ),
        7, :g
    )
)

# {:node, 7, :g,
#     {:node, 1, :a, nil,
#         {:node, 5, :e, 
#             {:node, 2, :b, nil, 
#                 {:node, 3, :c, nil, nil
#                 }
#             }, nil
#         }
#     }, 
#     nil
# }


# {:node, 5, :e,
#     {:node, 4, :d,
#         {:node, 1, :a, nil, 
#             {:node, 3, :c, 
#                 {:node, 2, :b, nil, nil
#                 }, nil
#             }
#         }, nil
#     },
#     {:node, 7, :g, nil, nil}
# }