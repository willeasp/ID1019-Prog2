_ = """
An environment is described by a list of mappings:
    The environment {x/foo, y/bar} could be represented as: 
    [{:x, :foo}, {:y, :bar}]


"""

defmodule Env do
    @doc """
    return an empty environment
    """
    def new() do [] end

    @doc """
    return an environment where the binding
    of the variable id to the structure str 
    has been added to the environment env
    """
    def add(id, str, env) do [{id, str} | remove([id], env)] end

    @doc """
    return either {id, str}, if the variable id was bound, or nil
    """
    def lookup(id, []) do nil end
    def lookup(id, [{id, str} | rest]) do {id, str} end
    def lookup(id, [_ | rest]) do lookup(id, rest) end

    @doc """
    returns an environment where all bindings for variables 
    in the list ids have been removed
    """
    def remove([], env) do env end
    def remove([id | ids], env) do
        remove(ids, rem(id, env, []))
    end
    def rem(id, [], agg) do agg end
    def rem(id, [{id, _} | rest], agg) do agg ++ rest end
    def rem(id, [h | rest], agg) do rem(id, rest, [h | agg]) end


    def test() do
        IO.inspect("Env test")
        env = new()
        env = add(:x, :foo, env)
        env = add(:y, :bar, env)
        env = add(:z, :zot, env)
        IO.inspect(env, label: "env")

        env = add(:z, :cool, env)
        IO.inspect(env, label: "env")


        IO.inspect(lookup(:x, env), label: "lookup success")
        IO.inspect(lookup(:k, env), label: "lookup fail")

        IO.inspect(rem(:x, env, []), label: "rem")
        IO.inspect(rem(:y, env, []), label: "rem")
        IO.inspect(rem(:z, env, []), label: "rem")

        IO.inspect(remove([:x, :z], env), label: "remove")

        IO.inspect(lookup(:foo, Env.add(:foo, 42, Env.new())), label: "TEST expected: {:foo, 42}, res")

    end
    
end

Env.test()


defmodule Eager do
    @doc """
    takes an expression and an environment and 
    returns either {:ok, str}, where str is a 
    data structure, or :error. An error is returned 
    if the expression can not be evaluated.
    """
    #this probably dos not work
    def eval_expr({:atm, id}, _) do {:ok, id} end
    def eval_expr({:var, _ }, []) do :error end
    def eval_expr({:var, id}, env) do
        case Env.lookup(id, env) do
            nil ->
                :error
            {_, str} ->
                {:ok, str}
        end
    end
    def eval_expr({:cons, a, b}, env) do
        case eval_expr(a, env) do
            :error ->
                :error
            {:ok, res1} ->
                case eval_expr(b, env) do
                    :error ->
                        :error
                    {:ok, res2} ->
                        {:ok, {res1, res2}}
                end
        end
    end
    def eval_expr_test() do
        IO.inspect(eval_expr({:atm, :a}, []), label: "{:ok, :a} ")
        IO.inspect(eval_expr({:var, :x},  [{:x, :a}]), label: "{:ok, :a} ")
        IO.inspect(eval_expr({:var, :x},  []), label: ":error ")
        IO.inspect(eval_expr({:cons, {:var, :x}, {:atm, :b}},  [{:x, :a}]), label: "{:ok, {:a, :b}} ")
        IO.inspect(eval_expr({:cons, {:atm, :a}, {:atm, :b}},  []), label: "{:ok, {:a, :b}} ")
    end


    @doc """
    A pattern matching will take a pattern, 
    a data structure and an environment and 
    return either {:ok, env}, where env is 
    an extended environment or the atom :fail
    """
    def eval_match(:ignore, _, env) do
        {:ok, env}
    end
    def eval_match({:atm, id}, _, env) do
        {:ok, env}
    end
    def eval_match({:var, id}, str, env) do
        case Env.lookup(id, env) do
            nil ->
                {:ok, [{id, str} | env]}
            {_, ^str} ->
                {:ok, env}
            {_, _} ->
                :fail
        end
    end
    def eval_match({:cons, hp, tp}, {:cons, hp2, tp2}, env) do
        case eval_match(hp, hp2, env) do
            :fail ->
                :fail
            {_, new_env} ->
                eval_match(tp, tp2, new_env)
        end
    end
    def eval_match(_, _, _) do
        :fail
    end
    def eval_match_test() do
        IO.inspect("eval_match test")
        IO.inspect(eval_match({:atm, :a}, :a, []), label: "{:ok, []} ")
        IO.inspect(eval_match({:var, :x}, :a, []), label: "{:ok, [{:x, :a}]} ")
        IO.inspect(eval_match({:var, :x}, :a, [{:x, :a}]), label: "{:ok, [{:x, :a}]} ")
        IO.inspect(eval_match({:var, :x}, :a, [{:x, :b}]), label: ":fail ")
        IO.inspect(eval_match({:cons, {:var, :x}, {:var, :x}}, {:cons, {:atm, :a}, {:atm, :b}}, []), label: ":fail ")
    end
end

Eager.eval_expr_test()
Eager.eval_match_test()

