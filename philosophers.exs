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


defmodule Philosopher do
    @eat 100
    @delay 200
    @sleep 200
    @timeout 100

    def start(hunger, strength, right, left, name, ctrl, seed) do
        spawn_link(fn -> dream(hunger, strength, right, left, name, ctrl, seed) end)
    end

    def puts(msg, name) do
        col = case name do
            "Arendt" -> IO.ANSI.green()
            "Hypatia" -> IO.ANSI.red()
            "Simone" -> IO.ANSI.blue()
            "Elisabeth" -> IO.ANSI.yellow()
            "Ayn" -> IO.ANSI.white()
        end
        IO.puts("#{col}#{msg}")
    end


    def dream(0, strength, right, left, name, ctrl, seed) do
        puts("#{name} is full with #{strength} strength left!", name)
        send(ctrl, :done)
    end
    def dream(hunger, 0, right, left, name, ctrl, seed) do
        puts("#{name} died with #{hunger} hunger!", name)
    end
    def dream(hunger, strength, right, left, name, ctrl, seed) do
        sleep(seed)
        get_chopsticks(hunger, strength, right, left, name, ctrl, seed)
    end

    def get_chopsticks(hunger, strength, right, left, name, ctrl, seed) do
        # puts("#{name} is waiting for left chopstick!", name)
        case Chopstick.request(left) do
            :no -> dream(hunger, strength-1, right, left, name, ctrl, seed)
            :ok ->
                puts("#{name} received left chopstick!", name)
                delay(@delay)
                case Chopstick.request(right) do
                    :no -> dream(hunger, strength-1, right, left, name, ctrl, seed)
                    :ok ->
                        puts("#{name} received right chopstick!", name)
                        eat(hunger, strength, right, left, name, ctrl, seed)
                end
        end

        # puts("#{name} is waiting for right chopstick!", name)

    end

    def eat(hunger, strength, right, left, name, ctrl, seed) do
        puts("#{name} is eating, #{hunger - 1} hunger left", name)
        delay(@eat)

        Chopstick.return(left)
        Chopstick.return(right)

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

