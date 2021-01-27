defmodule Sort do
    @doc """
    Inserts the element at the right place in the list
    """
    def insert(elmt,[]) do [elmt] end
    def insert(elmt, ls) do
        P.rint("INSERT")
        [first | last] = ls
        if elmt < first do
            [elmt | ls]
        else
            [first | insert(elmt, last)]
        end
    end
    @doc """
    Insertion sort
    """
    def isort([]) do [] end
    def isort(ls) do
        P.rint("ISORT")
        [h | t] = ls
        insert(h, isort(t))
    end

    @doc """
    Merge sort
    """
    def msort(ls) do
        case ls do
            [x] -> [x]
            _ ->
                {h, t} = splut(ls, [], [])
                merge(msort(h), msort(t))
        end
    end

    def merge(ls, []) do ls end
    def merge(lsh, lst) do
        [f_h | resth] = lsh
        [f_t | restt] = lst
        if f_h < f_t do
            [f_h | merge(lst, resth)]
        else
            [f_t | merge(lsh, restt)]
        end
    end

    def msplit(lsplit) do
        len = round(length(lsplit)/2)
        Enum.split(lsplit, len)
    end


    @doc """
    Splitting functions from lesson with Johan
    """
    def split(lst) do
        case lst do
            [] -> {[],[]}
            [a] -> {[a],[]}
            [a,b] -> {[a],[b]}
            [a,b | tail] ->
                {one, two} = split(tail)
                {[a|one], [b|two]}
        end
    end

    def splat(lst) do splat(lst, [], []) end
    def splat(lst, sofar_one, sofar_two) do
        case lst do
            [] -> {sofar_one, sofar_two}
            [a] -> {[a|sofar_one], sofar_two}
            [a,b] -> {[a|sofar_one],[b|sofar_two]}
            [a,b | tail] -> splat(tail, [a|sofar_one], [b|sofar_two])
        end
    end

    def splut(lst) do splut(lst, [], []) end
    def splut(lst, sofar_one, sofar_two) do
        case lst do
            [] -> {sofar_one, sofar_two}
            [a | tail] -> splut(tail, sofar_two, [a|sofar_one])
        end
    end
    
end

defmodule P do
    def rint(msg) do
        IO.inspect(msg)
    end
end
