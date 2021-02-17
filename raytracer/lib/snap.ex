defmodule Snap do
    def snap(num) do
        camera = Camera.normal({800, 600})

        obj1 = %Sphere{radius: 140, pos: {0, 0, 700}, color: {1.0, 0.0, 0.0}}
        obj2 = %Sphere{radius: 50, pos: {200, 0, 600}, color: {0.0, 1.0, 0.0}}
        obj3 = %Sphere{radius: 50, pos: {-80, 0, 400}, color: {0.0, 0.0, 1.0}}
        obj4 = %Sphere{radius: 40, pos: {150, 80, 800}, color: {1.0, 1.0, 0.0}}
        

        image = Tracer.tracer(camera, [obj1, obj2, obj3, obj4])
        PPM.write("snap#{num}.ppm", image)

    end
end