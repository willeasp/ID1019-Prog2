defmodule World do

    @background {0, 0, 0}
    @ambient {0.3, 0.3, 0.3}
    @depth 2
    @refraction 1

    defstruct objects: [], lights: [], background: @background, ambient: @ambient, depth: @depth, refraction: @refraction

end