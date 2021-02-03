defmodule AVLtree do
# module for AVL trees
# the implementation
# a node
#   {:node, key, value, diff, left, right}
# empty branch
#   nil

    # the insert method to call
    def insert(tree, key, value) do
        case insrt(tree, key, value) do
            {:inc, q} -> q
            {:ok, q} -> q
        end
    end

    # tree is empty
    defp insrt(nil, key, value) do
        {:inc, {:node, key, value, 0, nil, nil}} 
    end

    # find the key in the root of the tree
    defp insrt({:node, key, _, f, a, b}, key, value) do
        {:ok, {:node, key, value, f, a, b}}
    end

    # tree is balanced going down the left branch
    # depth of left branch is either incremented or the same
    # indicate whether it was changed or not
    defp insrt({:node, rk, rv, 0, a, b}, kk, kv) when kk < rk do
        case insrt(a, kk, kv) do
            {:inc, q} ->
                {:inc, {:node, rk, rv, -1, q, b}}
            {:ok, q} ->
                {:ok, {:node, rk, rv, 0, q, b}}
        end
    end
    # going down a left branch but in a tree that has a deeper right branch
    # will not increase the total depth even if we increase the depth of the left branch
    defp insrt({:node, rk, rv, +1, a, b}, kk, kv) when kk < rk do
        case insrt(a, kk, kv) do
            {:inc, q} ->
                {:ok, {:node, rk, rv, 0, q, b}}
            {:ok, q} ->
                {:ok, {:node, rk, rv, +1, q, b}}
        end
    end
    # going down the left branch that is already longer than the right
    # here we rely on the rotate function
    defp insrt({:node, rk, rv, -1, a, b}, kk, kv) when kk < rk do
        case insrt(a, kk, kv) do
            {:inc, q} ->
                {:ok, rotate({:node, rk, rv, -2, q, b})}
            {:ok, q} ->
                {:ok, {:node, rk, rv, -1, q, b}}
        end
    end

    # right
    # tree is balanced going down the left branch
    defp insrt({:node, rk, rv, 0, a, b}, kk, kv) do
        case insrt(b, kk, kv) do
            {:inc, q} ->
                {:inc, {:node, rk, rv, +1, a, q}}
            {:ok, q} ->
                {:ok, {:node, rk, rv, 0, a, q}}
        end
    end
    # going down a right branch but in a tree that has a deeper left branch
    defp insrt({:node, rk, rv, -1, a, b}, kk, kv) do
        case insrt(b, kk, kv) do
            {:inc, q} ->
                {:ok, {:node, rk, rv, 0, a, q}}
            {:ok, q} ->
                {:ok, {:node, rk, rv, -1, a, q}}
        end
    end
    # going down the right branch that is already longer than the left
    defp insrt({:node, rk, rv, +1, a, b}, kk, kv) do
        case insrt(b, kk, kv) do
            {:inc, q} ->
                {:ok, rotate({:node, rk, rv, +2, a, q})}
            {:ok, q} ->
                {:ok, {:node, rk, rv, +1, a, q}}
        end
    end

    # rotations

    # single rotation to the right
    defp rotate({:node, xk, xv, -2, {:node, yk, yv, -1, a, b}, c}) do
        {:node, yk, yv, 0, a, {:node, xk, xv, 0, b, c}}        
    end
    # single rotation to the left
    defp rotate({:node, xk, xv, +2, a, {:node, yk, yv, +1, b, c}}) do
        {:node, yk, yv, 0, {:node, xk, xv, 0, a, b}, c}
    end

    # double rotations to the right
    # z has more on the left
    defp rotate({:node, xk, xv, -2, {:node, yk, yv, +1, a, {:node, zk, zv, -1, b, c}}, d}) do
        {:node, zk, zv, 0, {:node, yk, yv, 0, a, b}, {:node, xk, xv, +1, c, d}}
    end
    # z has more on the right
    defp rotate({:node, xk, xv, -2, {:node, yk, yv, +1, a, {:node, zk, zv, +1, b, c}}, d}) do
        {:node, zk, zv, 0, {:node, yk, yv, -1, a, b}, {:node, xk, xv, 0, c, d}}
    end
    # z is balanced
    defp rotate({:node, xk, xv, -2, {:node, yk, yv, +1, a, {:node, zk, zv, 0, b, c}}, d}) do
        {:node, zk, zv, 0, {:node, yk, yv, 0, a, b}, {:node, xk, xv, 0, c, d}}
    end
    # double rotations to the left
    # z has more on the right
    defp rotate({:node, xk, xv, +2, a, {:node, yk, yv, -1, {:node, zk, zv, +1, b, c}, d}}) do
        {:node, zk, zv, 0, {:node, xk, xv, -1, a, b}, {:node, yk, yv, 0, c, d}}
    end
    # z has more on the left
    defp rotate({:node, xk, xv, +2, a, {:node, yk, yv, -1, {:node, zk, zv, -1, b, c}, d}}) do
        {:node, zk, zv, 0, {:node, xk, xv, 0, a, b}, {:node, yk, yv, +1, c, d}}
    end
    # z is balanced
    defp rotate({:node, xk, xv, +2, a, {:node, yk, yv, -1, {:node, zk, zv, 0, b, c}, d}}) do
        {:node, zk, zv, 0, {:node, xk, xv, 0, a, b}, {:node, yk, yv, 0, c, d}}
    end

    def get(nil, _) do :no end
    def get({:node, key, val, _, _, _}, key) do {:ok, val} end
    def get({:node, k, _, _, l, r}, key) do
        cond do
            key < k ->
                get(l, key)
            true ->
                get(r, key)
        end
    end

    def to_list(tree) do to_list(tree, []) end
    def to_list(nil, list) do list end
    def to_list({:node, key, val, _, l, r}, agg) do
        agg = [{key, val} | agg]
        to_list(r, to_list(l, agg))
    end


end

IO.inspect(
    AVLtree.get(
        AVLtree.insert(
            {
                :node, 13, :s, -1, 
                {
                    :node, 10, :k, -1, 
                    {
                        :node, 5, :k, 0, 
                        {
                            :node, 4, :k, 0, nil, nil
                        },
                        {
                            :node, 6, :k, 0, nil, nil
                        }
                    },
                    {
                        :node, 11, :b, 0, nil, nil
                    }
                },
                {
                    :node, 15, :k, +1, nil,
                    {
                        :node, 16, :s, 0, nil, nil
                    }
                }
            },
            7, :new
        ), 17
    )
)
