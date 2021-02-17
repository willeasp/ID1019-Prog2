
defmodule Strucz do
    defstruct number: 0, color: :blue

    def test() do
        %Strucz{}
    end

    def number(%Strucz{number: 0}) do
        :correct
    end
    def number(str) do
        :wrong
    end

    def foldl([], agg, _) do agg end
    def foldl([h|t], agg, fun) do
        foldl(t, fun.(h, agg), fun)
    end
end