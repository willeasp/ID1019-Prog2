defmodule Camera do
    defstruct pos: nil, corner: nil, right: nil, down: nil, size: nil

    def normal(size) do
        {width, height} = size
        d = width * 1.2
        h = width / 2
        v = height / 2
        corner = {-h, v, d}
        pos = {0, 0, 0}
        right = {1, 0, 0}
        down = {0, -1, 0}
        %Camera{pos: pos, corner: corner, right: right, down: down, size: size}
    end

    def ray(camera, col, row) do
        x = Vector.smul(camera.right, col)
        y = Vector.smul(camera.down, row)
        v = Vector.add(x, y)
        p = Vector.add(camera.corner, v)
        dir = Vector.normalize(p)
        %Ray{pos: camera.pos, dir: dir}
    end

end
