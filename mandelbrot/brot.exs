defmodule Brot do

    @doc """
    given the complex number c and the maximum number of iterations m,
     return the value i at which |zi| > 2 or 0 if it does not for any i < m 
     i.e. it should always return a value in the range 0..(m-1).
    """
    def mandelbrot(c, m) do
        z0 = Cmplx.new(0, 0)
        i = 0
        test(i, z0, c, m)
    end

    defp test(i, zn, c, m) do
        cond do
            i == m ->
                0
            Cmplx.abs(zn) > 2 ->
                i
            true ->
                znext = Cmplx.add(Cmplx.sqr(zn), c)
                test(i+1, znext, c, m)
        end
    end

    def mand_test() do
        Brot.mandelbrot(Cmplx.new(0.8, 0), 30)
        Brot.mandelbrot(Cmplx.new(0.5, 0), 30)
        Brot.mandelbrot(Cmplx.new(0.3, 0), 30)
        Brot.mandelbrot(Cmplx.new(0.27, 0), 30)
        Brot.mandelbrot(Cmplx.new(0.26, 0), 30)
        Brot.mandelbrot(Cmplx.new(0.255, 0), 30)
    end

end