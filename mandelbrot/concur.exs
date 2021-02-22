defmodule Concur do
    @max 250

    def sleep() do
        :timer.sleep 150
    end
    def test1() do
        # method = fn -> :timer.sleep 15000 end
        for x <- 1..@max, do: Task.await(Task.async(fn -> sleep() end))
    end

    def test2() do
        for x <- 1..@max, do: sleep()
    end

    def bench() do
        IO.inspect(:timer.tc(fn -> test1() end))
        IO.inspect(:timer.tc(fn -> test2() end))
    end



    def pmap(collection, func) do
        collection
        |> Enum.map(&(Task.async(fn -> func.(&1) end)))
        |> Enum.map(&Task.await/1)
    end



    def cool() do
        h = 1000
        w = 1000
        for y <- 1..h, do: for(x <- 1..w, do: {x, y})
    end

    def test3() do
        cool = for x <- 1..5, do: for(y <- 1..5, do: {x, y})
        Enum.map(cool, fn x -> Enum.map(x, fn {a, b} -> {a+1, b+1} end) end)
    end

    def test4() do
        cool = for x <- 1..5, do: x
        Enum.map(cool, Task.async(fn x -> x+1 end))
    end

    def test5() do
        fun = fn x -> x+1 end
        pmap(1..5, fun)
    end
end