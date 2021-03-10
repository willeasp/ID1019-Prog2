defmodule T do
#1
    def toggle([]) do [] end
    def toggle([x]) do [x] end
    def toggle([x, y | rest]) do
       [y, x | toggle(rest)]
    end


#2
    def push(x) do {:stack, [x]} end
    def push(x, {:stack, ls}) do {:stack, [x | ls]} end

    def pop({:stack, []}) do :no end
    def pop({:stack, [h | t]}) do
        {:ok, h, {:stack, t}}
    end


#3
    def flatten([]) do [] end
    def flatten([h | t]) do
        flatten(h) ++ flatten(t)
    end
    def flatten(x) do
        [x]
    end


#4
    def index(ls) do index(ls, 0) end
    def index([], h) do h end
    def index([head | tail], h) do
        cond do
            head > h ->
                index(tail, h+1)
            true ->
                h
        end
    end


#5
    @doc """
    tar ett träd, 
    om två löv är likadana, ersätt noden med ett löv
    om det bara finns ett löv, ersätt noden med ett löv
    """
    def compact(:nil) do :nil end
    def compact({:leaf, x}) do {:leaf, x} end
    def compact({:node, {:leaf, x}, {:leaf, x}}) do {:leaf, x} end
    def compact({:node, {:leaf, x}, {:leaf, y}}) do {:node, {:leaf, x}, {:leaf, y}} end
    def compact({:node, {:leaf, x}, :nil}) do {:leaf, x} end
    def compact({:node, :nil, {:leaf, x}}) do {:leaf, x} end
    def compact({:node, :nil, :nil}) do :nil end
    def compact({:node, left, right}) do
        compact({:node, compact(left), compact(right)})
    end



#6 
    # jaadu


#7
    # return a function that returns the number and a
    # function that provides the next number after that
    def next(n) do
        {:ok, n, fn() -> next(n+1) end}
    end

    # return a function that returns the next prime and another function
    def primes() do
        fn() -> 
            {:ok, 2, 
                fn() -> sieve(2, fn() -> next(3) end) end
            } 
        end
    end




#8
    @doc """
    Do not return any multiple of a number that has been counted
    Sieve skall returnera nästa primtal, och en funktion som genererar n
    nästa primtal efter det
    """
    def sieve(p, next) do
        {:ok, n, next} = next.()
        if rem(n, p) == 0 do
            sieve(p, next)
        else
            {:ok, n, fn -> sieve(n, fn -> sieve(p, next) end) end}
        end
    end

    def slappen(ls) do slappen(ls, []) end
    def slappen([], agg) do agg end
    def slappen([h | t], agg) do
        agg = slappen(t, agg)
        slappen(h, agg)
    end
    def slappen(x, agg) do [x | agg] end




#9
    def pmap(ls, f) do
        self = self()
        proc = Enum.map(ls, fn x -> spawn_link(fn -> send(self, {f.(x), self()}) end) end)
        Enum.map(proc, 
            fn pid -> 
                receive do 
                    {res, ^pid} -> res;
                    weird -> "weird: #{weird}"
                end
            end
        )
    end

end