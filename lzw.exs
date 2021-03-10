defmodule LZW do
    @alphabet 'abcdefghijklmnopqrstuvwxyz '

    def table(), do: table(@alphabet)

    def table(alphabet) do
        n = length(alphabet)
        words = Enum.map(alphabet, fn x -> [x] end)
        rest = Enum.to_list(1..n)
        map = List.zip([words, rest])
        next = n + 1
        {next, map}
    end

    def lookup_code({_, words}, word) do
        List.keyfind(words, word, 0)
    end

    def lookup_word({_, words}, code) do
        List.keyfind(words, code, 1)
    end

    def add({n, words}, word) do
        IO.puts("Adding #{word} as code #{n}")
        {n+1, [{word, n} | words]}
    end


    def encode([], _), do: []
    def encode([char | rest], table) do
        word = [char]
        {:found, code} = encode_word(word, table)
        encode(rest, word, code, table)
    end
    def encode([], _sofar, code, _table), do: [code]
    def encode([char | rest], sofar, code, table) do
        extended = sofar ++ [char]
        case encode_word(extended, table) do
            {:found, ext} ->
                encode(rest, extended, ext, table)

            {:notfound, updated} ->
                sofar = [char]
                {_, new_code} = encode_word(sofar, updated) 
                [code | encode(rest, sofar, new_code, updated)]
        end
    end

    def encode_word(word, table) do
        case lookup_code(table, word) do
            {_word, code} ->
                {:found, code}
            nil ->
                {:notfound, add(table, word)}
        end
    end


    def decode([], _), do: []
    def decode([code], table) do
        ## last code in the sequence
        {word, _code} = lookup_word(table, code)
        word
    end
    def decode([code | rest], table) do
        {word, _code} = lookup_word(table, code)
        updated = decode_update(rest, word, table)
        word ++ decode(rest, updated)
    end

    def decode_update([next | _], word, table) do
        char = case lookup_word(table, next) do
            {found, _code} ->
                IO.puts("found: #{found}, head: #{hd(found)}")
                hd(found)
            nil ->
                IO.puts("could not find the code #{next}")
                hd(word)
        end
        add(table, word ++ [char])
    end
end