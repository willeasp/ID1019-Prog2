
defprotocol Object do
    @doc """
    All objects in the world should provide a function 
    that can determine if it intersects with a ray
    """
    def intersect(object, ray)

    @doc """
    Object should give information about the normal at a position
    """
    def normal(object, ray, pos)

end