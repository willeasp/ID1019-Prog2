defmodule World do

    @background {0, 0, 0}
    @ambient {0.3, 0.3, 0.3}

    defstruct objects: [], lights: [], background: @background, ambient: @ambient

end