defmodule Encode do
    @doc """
    Encode number to binary as list
    """
    def to_binary(0) do [0] end
    def to_binary(n) do
        to_binary(div(n,2)) ++ [rem(n,2)]
    end

    @doc """
    A better way to encode to binary
    """
    def to_better(n) do to_better(n, []) end
    def to_better(0, b) do b end
    def to_better(n, b) do 
        to_better(div(n,2), [rem(n,2) | b])
    end

    @doc """
    Binary to integer
    """
    def to_integer(x) do to_integer(x, 0) end
    def to_integer([], n) do n end
    def to_integer([x | r], n) do
        n = n + :math.pow(2, length(r)) * x
        to_integer(r, n)
    end
end
