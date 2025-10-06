defmodule Vex.Board do
  use GenServer

  # Client API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def post(pid, recipient_id, message) do
    encrypted_msg = Vex.Crypto.encrypt(message) # Encrypt before storing msg
    GenServer.cast(pid, {:post, recipient_id, encrypted_msg})
  end

  def read(pid, recipient_id) do
    GenServer.call(pid, {:read, recipient_id})
  end

  # Sever Callbacks
  @impl true
  def init(:ok) do
    {:ok, %{}} # Initial state: empty list
  end

  @impl true
  def handle_cast({:post, recipient_id, encrypted_msg}, state) do
    #Add message to recipient's list
    current_messages = Map.get(state, recipient_id, [])
    new_messages = [encrypted_msg | current_messages]
    new_state = Map.put(state, recipient_id, new_messages)

    {:noreply, new_state}
  end

  @impl true
  def handle_call({:read, recipient_id}, _from, state) do
    recipient_messages = Map.get(state, recipient_id, [])
    decrypted_messages = Enum.map(recipient_messages, &Vex.Crypto.decrypt/1)

    {:reply, decrypted_messages, state}
  end

  # TESTING RECIPIENT-SPECIFIC MESSAGING
  @impl true
  def handle_call({:peek_encrypted, recipient_id}, _from, state) do
    recipient_messages = Map.get(state, recipient_id, [])
    {:reply, recipient_messages, state}
  end

  # TESTING ENCRYPTION
  def peek_encrypted(pid, recipient_id) do
    GenServer.call(pid, :peek_encrypted, recipient_id)
  end
end
