defmodule Brudy do
    @handlers 1
    @name :brudy

    @doc """
    Knop off the server process, to be able to close it at will
    """
    def start(port) do start(port, @handlers) end
    def start(port, handlers) do
        Process.register(spawn(fn -> init(port, handlers) end), @name)
    end
    @doc """
    Kill the knopped off server process
    """
    def stop() do
        Process.exit(Process.whereis(@name), "Time to die!")
    end


    @doc """
    The procedure that will initualize the server, takes a port number
    (for example 8080), opens a listening socket and passes the socket to handler/1. 
    Once the request has been handled the socket will be closed
    """
    def init(port, handlers) do
        options = [:list, active: false, reuseaddr: true]

        case :gen_tcp.listen(port, options) do
            {:ok, listen} ->
                handler(listen)
                :gen_tcp.close(listen)
                :ok
            {:error, error} ->
                error
        end
    end

    @doc """
    Will listen to the socket for an incoming connection. Once
    a client has connected it will pass the connection ro request/1, 
    When the request is handled the connection is closed
    """
    def handler(listen) do handler(listen, 0) end
    def handler(listen, n) do
        # IO.puts("handler #{n}")
        case :gen_tcp.accept(listen) do
            {:ok, client} ->
                spawn(fn -> request(client) end)
                handler(listen, n+1)
            {:error, error} ->
                error
        end
    end

    @doc """
    will read the request from the client connection and parse it.
    It will then parse the request using your http parser and pass the request to reply/1.
    The reply is then sent back to the client.
    """
    def request(client) do
        recv = :gen_tcp.recv(client, 0)
        case recv do
            {:ok, str} ->
                parsing = HTTP.parse_request(str)
                response = reply(parsing)
                :gen_tcp.send(client, response)
            {:error, error} ->
                IO.puts("RUDY ERROR: #{error}")
        end
        :gen_tcp.close(client)
    end

    @doc """
    this is where we decide what to reply, how to turn the reply into
    a well fromed HTTP reply
    """
    def reply({{:get, uri, _}, _, _}) do
        :timer.sleep(10)
        HTTP.ok("Hello!")
    end
end