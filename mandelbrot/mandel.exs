defmodule Mandel do

    def mandelbrot(width, height, x, y, k, depth) do
        trans = fn(w, h) ->
            Cmplx.new(x + k * (w - 1), y - k * (h - 1))
        end
        rows(width, height, trans, depth, [])
    end

    defp rows(w, h, trans, depth, ls) do
        pixel = fn(x, y) -> 
            c = trans.(x, y)
            d = Brot.mandelbrot(c, depth)
            Color.convert(d, depth)
        end
        for y <- 1..h, do: for(x <- 1..w, do: pixel.(x, y))
    end

    def mandelbrot2(width, height, x, y, k, depth) do
        trans = fn(w, h) ->
            Cmplx.new(x + k * (w - 1), y - k * (h - 1))
        end
        rows2(width, height, trans, depth, [])
    end
    defp rows2(w, h, trans, depth, ls) do
        pixel = fn(x, y) -> 
            c = trans.(x, y)
            d = Brot.mandelbrot(c, depth)
            Color.convert(d, depth)
        end
        Concur.pmap(1..h, fn y -> Concur.pmap(1..w, fn x -> pixel.(x, y) end) end)
    end

end