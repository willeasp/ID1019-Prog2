defmodule Conc do

    def test do
        for x <- 1..10, do: echo(x, self())
        recv()
    end

    def echo(number, callee) do
        send(callee, {:number, number})
    end

    def recv() do
        receive do
            {:number, value} ->
                IO.puts(value)
            x ->
                IO.puts(x)
        end
    end
end