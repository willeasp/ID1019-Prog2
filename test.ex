defmodule Test do
  def double(n) do
    n * 2
  end
  def rect_area(a,b) do
    a * b
  end
  def square(a) do
    rect_area(a,a)
  end
  def tak(ls) do
    [x | _] = ls
    x
  end
  def drp(ls) do
    [_ | x] = ls
    x
  end
  def len(ls) do
    [_ | x] = ls
    case x do
      [] -> 1
      _ -> 1 + len(x)
    end
  end
  def sum(ls) do
    [x | y] = ls
    case y do
      [] -> x
      _ -> x + sum(y)
    end
  end
  def append(l, ls) do
    x = l ++ ls
    x
  end

  def duplicate([]) do [] end
  def duplicate(ls) do
      [x | y] = ls
      [x | duplicate(y)]
  end

  def add(x, []), do: [x]
  def add(x, [x]), do: [x]
  def add(x, [head | tail]) do
    case tail do
      [] -> [x, head]
      _ -> [head | add(x, tail)]
    end
  end

  def remove(_, []), do: []
  def remove(x, [x | tail]), do: remove(x, tail)
  def remove(x, [head | tail]) do
    [head | remove(x, tail)]
  end


  def unique([]) do [] end
  def unique([x]) do [x] end
  def unique([head | tail]) do
     [head | remove(head, unique(tail))]
  end

  @doc """
  Using y-combinator lambda expression
  """
  def fibonacci(n) do
      fib = fn n, f ->
        case n do
            0 -> 0
            1 -> 1
            _ -> f.(n-1, f) + f.(n-2, f)
        end
      end
      fib.(n, fib)
  end



  @doc """
  A bad reverse method thing
  """
  def nreverse([]) do [] end

  def nreverse([h | t]) do
    r = nreverse(t)
    append(r, [h])
  end

  @doc """
  A better reverse method
  """
  def reverse(l) do
    reverse(l, [])
  end
  def reverse([], r) do r end
  def reverse([h | t], r) do
    reverse(t, [h | r])
  end

  @doc """
  Benching the reverse methods
  """
  def bench() do
    ls = [16,32,64,128,256,512]
    n = 1000
    # bench is a closure; a function with an environment
    bench = fn(l) ->
      seq = Enum.to_list(1..l)
      tn = time(n, fn -> nreverse(seq) end)
      tr = time(n, fn -> reverse(seq) end)
      :io.format("length: ~10w nrev:   ~8w us   rev: ~8w us~n", [l, tn, tr])
    end

    # We use library function Enum.each that will call
    # bench(l) for each element l in ls
    Enum.each(ls, bench)
  end

  # time the execution time of a function
  def time(n, fun) do
    start = System.monotonic_time(:milliseconds)
    loop(n, fun)
    stop = System.monotonic_time(:milliseconds)
    stop - start
  end

  # apply the function n times
  def loop(n, fun) do
    if n == 0 do
      :ok
    else
      fun.()
      loop(n-1, fun)
    end
  end
end

defmodule Recursion do
  @doc """
  Compute the product between of n and m.

  product of n and m :
    if n is 0
      then ...
    otherwise
      the result ...
  """
  def prod(m,n) do
    case m do
      0 -> 0
      1 -> n
      _ -> n + prod(n, m-1)
    end
  end

  def fib(n) do
    case n do
      0 -> 0
      1 -> 1
      _ -> fib(n-1) + fib(n-2)
    end
  end
end

defmodule Curry do
    def getcash(card, pin, request) do
        100
    end

    def get_cash(card) do
        fn(pin) -> 
            fn(request) -> 
                card + pin + request
            end
        end
    end

end