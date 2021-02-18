defmodule Cmplx do
    @type complex() :: {number(), number()}

    @doc """
    Return a new complex number
    """
    def new(r, i) do {r, i} end

     @doc """
     Add two complex numbers
     """
    def add({ar, ai}, {br, bi}) do {ar + br, ai + bi} end

    @doc """
    Calculate the square of a complex number
    """
    def sqr({x, y}) do
        x2 = :math.pow(x, 2)
        y2 = :math.pow(y, 2)
        r = x2 - y2
        i = 2 * x * y
        {r, i}
    end

    @doc """
    Calculate the absolute value of a complex number
    """
    def abs({x, y}) do
        x2 = :math.pow(x, 2)
        y2 = :math.pow(y, 2)
        :math.sqrt(x2 + y2)
    end


end