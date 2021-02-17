defmodule Ray do

    # if you dont give the ray a position, it defaults to {0, 0, 0} (origo)
    # if you dont give the ray a direction, it defaults to {0, 0, 1} (straight into the picture)
    @doc """
    p = ray.pos     d = ray.dir
    %Ray{pos: p, dir: d}

    Note, access is lg(n) of number of properties, not ass efficient as tuples
    """
    defstruct pos: {0, 0, 0}, dir: {0, 0, 1}

end