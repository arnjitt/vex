defmodule Vex.Board do
  use GenServer

  # Client API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def post(pid, message) do
    GenServer.cast(pid, {:post, message})
  end

  def read(pid) do
    GenServer.call(pid, :read)
  end

  # Sever Callbacks
  @impl true
  def init(:ok) do
    {:ok, []} # Initial state: empty list
  end

  @impl true
  def handle_cast({:post, message}, state) do
    {:noreply, [message | state]}
  end

  @impl true
  def handle_call(:read, _from, state) do
    {:reply, state, state}
  end
end
