defmodule Trudy do
    @handlers 4
    @name :trudy

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
        Process.exit(Process.whereis(@name), :kill)
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
                Process.flag(:trap_exit, true)
                init_handlers(handlers, listen)
                supervise(listen, 1)
                :gen_tcp.close(listen)
                :ok
            {:error, error} ->
                error
        end
    end

    @doc """
    Recieve process death messages and start new processes.
    """
    def supervise(listen, id) do
        receive do
            {:EXIT, _pid, reason} ->
                IO.puts("Handler died because #{reason}")
                spawn_link(fn -> handler(listen, id) end)
                supervise(listen, id + 1)
            strange ->
                IO.puts("strange message: #{strange}")
                supervise(listen, id + 1)
        end
    end

    @doc """
    Initializes the handlers
    """
    def init_handlers(listen) do init_handlers(@handlers, listen) end
    def init_handlers(0, _) do :ok end
    def init_handlers(n, listen) do
        spawn_link(fn -> handler(listen, n - @handlers) end)
        init_handlers(n-1, listen)
    end


    @doc """
    Will listen to the socket for an incoming connection. Once
    a client has connected it will pass the connection ro request/1, 
    When the request is handled the connection is closed
    """
    def handler(listen, id) do
        flip_a_coin(id)
        case :gen_tcp.accept(listen) do
            {:ok, client} ->
                request(client, id)
                handler(listen, id)
            {:error, error} ->
                error
        end
    end

    def flip_a_coin(id) do
        if :rand.uniform(10) == 1 do
            Process.exit(self(), "OUCH from #{id}!")
        end
        :ok
    end

    @doc """
    will read the request from the client connection and parse it.
    It will then parse the request using your http parser and pass the request to reply/1.
    The reply is then sent back to the client.
    """
    def request(client, id) do
        recv = :gen_tcp.recv(client, 0)
        case recv do
            {:ok, str} ->
                parsing = HTTP.parse_request(str)
                response = reply(parsing, id)
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
    def reply({{:get, uri, ver}, headers, body}, id) do
        :timer.sleep(10)
        HTTP.ok("#{uri}\n#{body}")
    end
end