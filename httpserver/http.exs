defmodule HTTP do
    @doc """
    Parse a HTTP request and return the request, the headers and the body separately
    """
    def parse_request(r0) do
        {request, r1} = request_line(String.to_charlist(r0))
        {headers, r2} = headers(r1)
        {body, _} = message_body(r2)
        {request, headers, body}
    end

    @doc """
    Extract the URI and the http version from the request line
    """
    def request_line([?G, ?E, ?T, 32 | r0]) do
        {uri, r1} = request_uri(r0)
        {ver, r2} = http_version(r1)
        [13, 10 | r3] = r2
        {{:get, uri, ver}, r3}
    end

    @doc """
    Extract the URI coming after the GET
    """
    def request_uri([32 | r0]), do: {[], r0}
    def request_uri([c | r0]) do
        {rest, r1} = request_uri(r0)
        {[c | rest], r1}
    end

    @doc """
    Extract the http version
    """
    def http_version([?H, ?T, ?T, ?P, ?/, ?1, ?., ?1 | r0]) do
        {:v11, r0}
    end
    def http_version([?H, ?T, ?T, ?P, ?/, ?1, ?., ?0 | r0]) do
        {:v10, r0}
    end

    @doc """
    Extract a sequence of headers, header by header
    """
    def headers([13, 10 | r0]), do: {[], r0}
    def headers(r0) do
        {header, r1} = header(r0)
        {rest, r2} = headers(r1)
        {[header | rest], r2}
    end
    @doc """
    Extract an individual header
    """
    def header([13, 10 | r0]), do: {[], r0}
    def header([c | r0]) do
        {rest, r1} = header(r0)
        {[c | rest], r1}
    end

    @doc """
    Cheating by assuming everything that is left is a message body
    """
    def message_body(r), do: {r, []}
end