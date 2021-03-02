defmodule Chopstick do
    def start do
        spawn_link(fn -> available() end)
    end

    def available() do
        receive do
            {:request, from} -> 
                send(from, :granted)
                gone()
            :quit -> :ok
        end
    end
    def gone() do
        receive do
            :return -> available()
            :quit -> :ok
        end
    end
    def request(stick) do
        send(stick, {:request, self()})
        receive do
            :granted -> :ok
        end
    end
    def request(stick, timeout) do
        send(stick, {:request, self()})
        receive do
            :granted ->
                :ok
            after timeout ->
                :no
        end
    end
    def return(stick) do
        send(stick, :return)
    end
    def quit(stick) do
        send(stick, :quit)
    end


end 

defmodule Choppy do
    def start do
        spawn_link(fn -> available() end)
    end

    def available() do
        IO.inspect(self(), label: "#{IO.ANSI.white()}stick available")
        receive do
            {:request, from} -> 
                send(from, :granted)
                gone(from)
            :quit -> :ok
        end
    end
    def gone(from) do
        IO.inspect(self(), label: "#{IO.ANSI.white()}stick gone")
        receive do
            {:return, ^from} -> available()
            :quit -> :ok
        end
    end
    def request(stick, timeout) do
        send(stick, {:request, self()})
        receive do
            :granted ->
                :ok
            after timeout ->
                :no
        end
    end
    def return(stick, from) do
        send(stick, {:return, from})
    end
end

defmodule ChoppyAsync do
    def start do
        spawn_link(fn -> available() end)
    end

    def available() do
        IO.inspect(self(), label: "#{IO.ANSI.white()}stick available")
        receive do
            {:request, from} -> 
                send(from, :granted)
                gone(from)
            :quit -> :ok
        end
    end
    def gone(from) do
        IO.inspect(self(), label: "#{IO.ANSI.white()}stick gone")
        receive do
            {:return, ^from} -> available()
            :quit -> :ok
        end
    end
    def request(stick) do
        send(stick, {:request, self()})
    end
    def collect(timeout) do
        receive do
            :granted ->
                :ok
            after timeout ->
                :no
        end
    end
    def return(stick, from) do
        send(stick, {:return, from})
    end
end

defmodule Philosopher do
    @eat 1500
    @delay 1000
    @sleep 2000
    @timeout 10000

    def start(hunger, strength, right, left, name, ctrl, seed) do
        spawn_link(fn -> dream(hunger, strength, right, left, name, ctrl, seed) end)
    end

    def puts(msg, name) do
        col = case name do
            "Arendt" -> IO.ANSI.green()
            "Hypatia" -> IO.ANSI.red()
            "Simone" -> IO.ANSI.blue()
            "Elisabeth" -> IO.ANSI.yellow()
            "Ayn" -> IO.ANSI.cyan()
        end
        IO.puts("#{col}#{msg}")
    end


    def dream(0, strength, right, left, name, ctrl, seed) do
        puts("is full with #{strength} strength left!", name)
        send(ctrl, :done)
    end
    def dream(hunger, 0, right, left, name, ctrl, seed) do
        puts("died with #{hunger} hunger!", name)
    end
    def dream(hunger, strength, right, left, name, ctrl, seed) do
        puts("is sleeping... zzz.. ", name)
        sleep(seed)
        puts("woke up!", name)
        get_chopsticks(hunger, strength, right, left, name, ctrl, seed)
    end

    def get_chopsticks(hunger, strength, right, left, name, ctrl, seed) do
        # puts("requests left chopstick", name)
        # case Choppy.request(left, @timeout) do
        #     :no -> 
        #         puts("did not receive left chopstick!", name)
        #         Choppy.return(left, self())
        #         dream(hunger, strength-1, right, left, name, ctrl, seed)
        #     :ok ->
        #         puts("received left chopstick!", name)
        #         delay(@delay)
        #         puts("requests right chopstick", name)
        #         case Choppy.request(right, @timeout) do
        #             :no -> 
        #                 puts("did not receive right chopstick!", name)
        #                 Choppy.return(left, self())
        #                 Choppy.return(right, self())
        #                 dream(hunger, strength-1, right, left, name, ctrl, seed)
        #             :ok ->
        #                 puts("received right chopstick!", name)
        #                 eat(hunger, strength, right, left, name, ctrl, seed)
        #         end
        # end

        puts("requests both chopsticks", name)
        ChoppyAsync.request(left)
        ChoppyAsync.request(right)
        case ChoppyAsync.collect(@timeout) do
            :no -> 
                puts("did not receive first chopstick!", name)
                ChoppyAsync.return(left, self())
                ChoppyAsync.return(right, self())
                dream(hunger, strength-1, right, left, name, ctrl, seed)
            :ok ->
                puts("received first chopstick!", name)
                delay(@delay)
                case ChoppyAsync.collect(@timeout) do
                    :no -> 
                        puts("did not receive second chopstick!", name)
                        ChoppyAsync.return(left, self())
                        ChoppyAsync.return(right, self())
                        dream(hunger, strength-1, right, left, name, ctrl, seed)
                    :ok ->
                        puts("received both chopsticks!", name)
                        eat(hunger, strength, right, left, name, ctrl, seed)
                end
        end
    end

    def eat(hunger, strength, right, left, name, ctrl, seed) do
        puts("is eating, #{hunger - 1} hunger left", name)
        delay(@eat)

        ChoppyAsync.return(left, self())
        ChoppyAsync.return(right, self())

        dream(hunger - 1, strength, right, left, name, ctrl, seed)
    end

    def sleep(t) do
        :timer.sleep(:rand.uniform(t))
    end

    def delay(t) do
        :timer.sleep(t)
    end
end



defmodule Dinner do
    def start(n, seed), do: spawn(fn -> init(n, seed) end)
    def start(), do: spawn(fn -> init(10, 1234) end)
    def start_async(), do: spawn(fn -> init_async(10, 1234) end)

    def init(n, seed) do
        c1 = Chopstick.start()
        c2 = Chopstick.start()
        c3 = Chopstick.start()
        c4 = Chopstick.start()
        c5 = Chopstick.start()
        ctrl = self()
        Philosopher.start(n, 5, c1, c2, "Arendt",    ctrl, seed + 1)
        Philosopher.start(n, 5, c2, c3, "Hypatia",   ctrl, seed + 2)
        Philosopher.start(n, 5, c3, c4, "Simone",    ctrl, seed + 3)
        Philosopher.start(n, 5, c4, c5, "Elisabeth", ctrl, seed + 4)
        Philosopher.start(n, 5, c5, c1, "Ayn",       ctrl, seed + 5)
        wait(5, [c1, c2, c3, c4, c5])
    end
    def init_async(n, seed) do
        c1 = ChoppyAsync.start()
        c2 = ChoppyAsync.start()
        c3 = ChoppyAsync.start()
        c4 = ChoppyAsync.start()
        c5 = ChoppyAsync.start()
        ctrl = self()
        Philosopher.start(n, 5, c1, c2, "Arendt",    ctrl, seed + 1)
        Philosopher.start(n, 5, c2, c3, "Hypatia",   ctrl, seed + 2)
        Philosopher.start(n, 5, c3, c4, "Simone",    ctrl, seed + 3)
        Philosopher.start(n, 5, c4, c5, "Elisabeth", ctrl, seed + 4)
        Philosopher.start(n, 5, c5, c1, "Ayn",       ctrl, seed + 5)
        wait(5, [c1, c2, c3, c4, c5])
        # wait(2, [c1, c2])
    end
    
    def wait(0, chopsticks) do
        IO.puts("finished")
        Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
    end

    def wait(n, chopsticks) do
        # IO.puts("wait #{n}")
        receive do
            :done ->
                wait(n - 1, chopsticks)
            :abort ->
                IO.puts("ABORT")
                Process.exit(self(), :kill)
        end
    end

    def abort() do
        Process.exit(self(), :kill)
    end
end

