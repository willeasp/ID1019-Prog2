Code.require_file("avl.exs")

defmodule Huffman do

# frequency of characters
# {:freq, char, freq}

    def sample do
        'the quick brown fox jumps over the lazy dog
        this is a sample text that we will use when we build
        up a table we will only handle lower case letters and
        no punctuation symbols the frequency will of course not
        represent english but it is probably not that far off'
    end

    def text()  do
        'this is something that we should encode'
    end

    # def test do
    #     sample = sample()
    #     tree = tree(sample)
    #     encode = encode_table(tree)
    #     decode = decode_table(tree)
    #     text = text()
    #     seq = encode(text, encode)
    #     decode(seq, decode)
    # end

    def tree(sample) do
        cmp = fn {_, a}, {_, b} -> a < b end
        freq = Huffman.Help.isort(freq(sample), cmp)
        huffman(freq, cmp)
    end

    def freq(sample) do AVLtree.to_list(freq(sample, nil)) end
    def freq([], freq) do freq end
    def freq([char | rest], freq) do
        case AVLtree.get(freq, char) do
            :no ->
                freq(rest, AVLtree.insert(freq, char, 1))
            {:ok, x} ->
                freq(rest, AVLtree.insert(freq, char, x+1))
        end
    end

    # a leaf: {char, freq}
    # a node: {left, right}
    # {tree, freq}
    # combine the two lowest frequencies and combine into new node
    # {{c1, c2}, f1 + f2} and add the node to the remaining sequence
    def huffman([{c1, f1} = n1, {c2, f2} = n2 | rest], cmp) do
        huffman(
            Huffman.Help.insert(
                {{n1, n2}, f1+f2}, rest, cmp
            ), cmp
        )
    end
    def huffman([table], _) do table end

    def encode_table(tree) do encode_table(tree, [], []) end
    def encode_table({{l, r}, _}, agg, path) do
        left = encode_table(l, agg, [0 | path])
        encode_table(r, left, [1 | path])
    end
    def encode_table({c, _}, agg, path) do [{c, Huffman.Help.reverse(path)} | agg] end

    # create a list of zeros and 1s
    def encode([], _) do [] end
    def encode([c | t], table) do
        encode({c, table}) ++ encode(t, table)
    end
    def encode({c, [{c, path} | t]}) do path end
    def encode({c, [_ | t]}) do encode({c, t}) end


    def decode([], _)  do
        []
    end
    def decode(seq, table) do
        # IO.inspect("decode")
        {char, rest} = decode_char(seq, 1, table)
        [char | decode(rest, table)]
    end
    def decode_char(seq, n, table) do
        {code, rest} = Enum.split(seq, n)
        # IO.inspect({seq, n, code, rest}, label: "arg")

        case List.keyfind(table, code, 1) do
            {char, code} ->
                # IO.inspect({char, code, rest}, label: "result")
                {char, rest}
            nil ->
                decode_char(seq, n+1, table)
        end
    end


    # enco tries to be faster!
    # def enco([], _) do [] end
    # def enco(seq, tree) do
    #     {char, rest} = enco_char(seq, tree)
    #     [char | enco(rest, tree)]
    # end
    # def enco_table(tree) do enco_table(tree, [], []) end
    # def enco_table({{l, r}, _}, agg, path) do
    #     left = enco_table(l, agg, [0 | path])
    #     enco_table(r, left, [1 | path])
    # end
    # def enco_table({c, _}, agg, path) do [{c, Huffman.Help.reverse(path)} | agg] end


    # deco is smarter and goes down the tree using 0s and 1s
    # args: seq, tree
    def deco([], _) do [] end
    def deco(seq, tree) do
        {char, rest} = deco_char(seq, tree)
        [char | deco(rest, tree)]
    end
    def deco_char([h | t], {{l, r}, _}) do
        case h do
            0 -> 
                deco_char(t, l)
            1 -> 
                deco_char(t, r)
        end
    end
    def deco_char(rest, {c, _}) do {c, rest} end


    defmodule Help do
        @doc """
        Insertion sort
        """
        def isort([], _) do [] end
        def isort(ls, cmp) do
            [h | t] = ls
            insert(h, isort(t, cmp), cmp)
        end
        @doc """
        Inserts the element at the right place in the list
        """
        def insert(elmt,[], _) do [elmt] end
        def insert(elmt, ls, cmp) do
            [first | last] = ls
            if cmp.(elmt, first) do
                [elmt | ls]
            else
                [first | insert(elmt, last, cmp)]
            end 
        end

        def reverse(l) do
            reverse(l, [])
        end
        def reverse([], r) do r end
        def reverse([h | t], r) do
            reverse(t, [h | r])
        end
    end

    def read(file, n) do
        {:ok, file} = File.open(file, [:read])
        binary = IO.read(file, n)
        File.close(file)

        case :unicode.characters_to_list(binary, :utf8) do
            {:incomplete, list, _} ->
                list;
            list ->
                list
        end
    end
end

{time, text} = :timer.tc(Huffman, :read, ["text.txt", 10000000000])
IO.inspect({time/1000000, length(text)}, label: "text length")

# text = 'hello'

{time, tree} = :timer.tc(Huffman, :tree, [text])
IO.inspect({time/1000000, tree}, label: "tree")

# table = Huffman.encode_table(tree)
{time, table} = :timer.tc(Huffman, :encode_table, [tree])
IO.inspect({time/1000000, table, length(table)}, label: "table, length")

# encoding = Huffman.encode(text, table)
{time, encoding} = :timer.tc(Huffman, :encode, [text, table])
IO.inspect({time/1000000, length(encoding)}, label: "encoding")


{time, decoding} = :timer.tc(Huffman, :deco, [encoding, tree])
IO.inspect({time/1000000, decoding}, label: "decoding")



# {
#     {node
#         {
#             {node
#                 {99, 3}, leaf
#                 {
#                     {node
#                         {101, 1}, 
#                         {100, 2}
#                     }, 
#                     3
#                 }
#             }, 
#             6
#         }, 
#         {
#             {
#                 {98, 4}, 
#                 {97, 5}
#             }, 
#             9
#         }
#     }, 
#     15
# }