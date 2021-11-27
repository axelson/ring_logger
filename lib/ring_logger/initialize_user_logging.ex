defmodule RingLogger.InitializeUserLogging do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    {:ok, [], {:continue, :init}}
  end

  @impl GenServer
  def handle_continue(:init, state) do
    Process.group_leader(self(), get_iex_group_leader())
    RingLogger.attach()

    {:noreply, state}
  end

  defp get_iex_group_leader do
    if user = Process.whereis(:user) do
      case :group.interfaces(user) do
        # Old or no shell
        [] ->
          nil

        # Get current group from user_drv
        [user_drv: user_drv] ->
          case :user_drv.interfaces(user_drv) do
            [] -> nil
            [current_group: group] -> group
          end
      end
    end
  end
end
