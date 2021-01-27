defmodule Calc do
    @doc """
    Eval evaluates an expression
    """
    def eval({:int, n}) do n end
    def eval({:add, a, b}) do 
        eval(a) + eval(b)
    end
    def eval({:add, a, b}, bindings) do 
        eval(a, bindings) + eval(b, bindings)
    end
    def eval({:sub, a, b}) do
        eval(a) - eval(b)
    end
    def eval({:mul, a, b}) do
        eval(a) * eval(b)
    end
    def eval({:var, name}, bindings) do
        lookup(name, bindings)
    end
    @doc """
    Lookup matches a variable name to its value
    """
    def lookup(var, [{:bind, var, value} | _]) do value end
    def lookup(var, [_ | rest]) do lookup(var, rest) end
end