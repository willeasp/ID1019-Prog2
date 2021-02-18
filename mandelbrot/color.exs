defmodule Color do
    @doc """
    given a depth on a scale from zero to max gives us a color
    """
    def convert(depth, max) do
        f = depth/max
        a = f*4
        x = trunc(a)
        y = trunc(255 * (a - x))
        case x do
            0 -> {y, 0, 0}
            1 -> {255, y, 0}
            2 -> {255 - y, 255, 0}
            3 -> {0, 255, y}
            _ -> {0 ,255 - y, 255}
        end
    end
end