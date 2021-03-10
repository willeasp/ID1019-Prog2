defmodule T do
#1
    def drop(ls, n) do drop(ls, 1, n) end
    def drop([], i, n) do [] end
    def drop([h | t], i, n) do
        cond do
            i < n ->
                [h | drop(t, i+1, n)]
            true ->
                drop(t, 1, n)
        end
    end


#2
    def rotate(ls, 0) do ls end
    def rotate(ls, n) do rotate(ls, 1, n, []) end
    def rotate([h | t], i, n, agg) do
        IO.puts("took #{h}")
        agg = [h | agg]
        if i < n do
            rotate(t, i+1, n, agg)
        else
            :lists.append(t, :lists.reverse(agg))
        end
    end



#5

    def pascal(n) do pascal(n, 1, [1]) end
    def pascal(n, i, r) do
        if i < n do
            r = row(r)
            pascal(n, i+1, r)
        else
            r
        end
    end

    def row([h | t]) do
        [h | row(t, h)]
    end
    def row([], n) do [n] end
    def row([h | t], n) do
        [h + n | row(t, h)]
    end
    
end