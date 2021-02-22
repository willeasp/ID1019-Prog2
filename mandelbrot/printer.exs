defmodule Printer do
    def demo() do
        small(-2.6, 1.2, 1.2)
    end

    def small(x0, y0, xn) do
        width = 960
        height = 540
        depth = 64
        k = (xn - x0) / width
        image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
        PPM.write("small.ppm", image)
    end

    #####################################
    # x0    -> controls where the x axis starts + zoom
    # y0    -> controls where the y axis starts + zoom
    # xn    -> controls length of steps
    # depth -> controls the "definition" of the mandelbrot set
    def awesome(0) do
        x0 = -2.6
        y0 = 1.2
        xn = 1.2
        width = 3840
        height = 2160
        depth = 200
        k = (xn - x0) / width
        image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
        PPM.write("awesome0.ppm", image)
    end
    def awesome(1) do
        x0 = -0.5
        y0 = 1.0
        xn = 1
        width = 1920
        height = 1080
        depth = 200
        k = (xn - x0) / width
        image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
        PPM.write("awesome1.ppm", image)
    end
    def awesome(2) do
        x0 = -0.5
        y0 = 1.1
        xn = 0.5
        width = 1920
        height = 1080
        depth = 200
        k = (xn - x0) / width
        image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
        PPM.write("awesome2.ppm", image)
    end
    def awesome(3) do
        x0 = -0.5
        y0 = 1.1
        xn = 0.5
        width = 3840
        height = 2160
        depth = 200
        k = (xn - x0) / width
        image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
        PPM.write("awesome3.ppm", image)
    end

    def speed1() do
        x0 = -0.5
        y0 = 1.1
        xn = 0.5
        width = 960
        height = 540
        depth = 1000
        k = (xn - x0) / width
        image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
        :ok
        # PPM.write("speedtest.ppm", image)
    end
    def speed2() do
        x0 = -0.5
        y0 = 1.1
        xn = 0.5
        width = 960
        height = 540
        depth = 1000
        k = (xn - x0) / width
        image = Mandel.mandelbrot2(width, height, x0, y0, k, depth)
        :ok
        # PPM.write("speedtest.ppm", image)
    end

    def bench() do
        {slow, _} = :timer.tc(fn -> speed1() end)
        {fast, _} = :timer.tc(fn -> speed2() end)
        difference = (slow - fast) / slow
        IO.inspect(difference, label: "concurrent faster by")
    end
end