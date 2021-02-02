defmodule Avl do
    def tree() do nil end

    def insert(tree, key, value) do 
        AVLtree.insert(tree, key, value) 
    end

    def depth(tree, key) do depth(tree, key, 0) end
    def depth(nil, _, _) do :fail end
    def depth({:node, key, _, _, _, _}, key, d) do d end
    def depth({:node, k, _, _, left, right}, key, d) do
        cond do
            key < k -> depth(left, key, d+1)
            true    -> depth(right, key, d+1)
        end
    end

    def max_depth(tree) do max_depth(tree, 0) end
    def max_depth(nil, d) do d-1 end
    def max_depth({:node, _, _, _, left, right}, d) do
        l = max_depth(left, d + 1)
        r = max_depth(right, d + 1)
        cond do
            l > r -> l
            true -> r
        end
    end
end

defmodule Bst do
    def tree() do :nil end

    def insert(tree, key, value) do
        Bintree.add(tree, key, value)
    end

    def depth(tree, key) do depth(tree, key, 0) end
    def depth(nil, _, _) do :fail end
    def depth({:node, key, _, _, _}, key, d) do d end
    def depth({:node, k, _, left, right}, key, d) do
        cond do
            key < k -> depth(left, key, d+1)
            true    -> depth(right, key, d+1)
        end
    end

    def max_depth(tree) do max_depth(tree, 0) end
    def max_depth(nil, d) do d-1 end
    def max_depth({:node, _, _, left, right}, d) do
        l = max_depth(left, d + 1)
        r = max_depth(right, d + 1)
        cond do
            l > r -> l
            true -> r
        end
    end
end

defmodule Test do

    def avl(size) do avltest(Avl.tree(), sequence(size, 100)) end
    def avltest(tree, [e, rest]) do
        Avl.insert(tree, e, :k)
    end

    defp sequence(0, _), do: []
    
    defp sequence(i, t), do: [:rand.uniform(t) | sequence(i - 1, t)]
end


# IO.inspect(
#     Bst.depth(
#         {
#         :node,
#         5,
#         :five,
#         {
#             :node,
#             3,
#             :three,
#             {
#                 :node,
#                 1,
#                 :one,
#                 :nil,
#                 :nil
#             },
#             :nil
#         },
#         {
#             :node,
#             7,
#             :seven,
#             {
#                 :node,
#                 6,
#                 :six,
#                 :nil,
#                 :nil
#             },
#             {
#                 :node,
#                 8,
#                 :eight,
#                 :nil,
#                 {:node, 9, :k, nil, nil}
#             }
#         }
#     },
#     8
#     )
# )

# IO.inspect(
#     Avl.max_depth(
#         {
#             :node, 10, :k, -1, 
#             {
#                 :node, 5, :k, 0, 
#                 {
#                     :node, 4, :k, 0, nil, nil
#                 },
#                 {
#                     :node, 6, :k, 0, nil, {:node, 7, :k, 0, nil, nil}
#                 }
#             },
#             {
#                 :node, 11, :k, 0, nil, nil
#             }
#         }
#     )
# )