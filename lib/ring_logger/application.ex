defmodule RingLogger.Application do
  use Application

  def start(_type, _args) do
    children = [
      RingLogger.InitializeUserLogging
    ]

    opts = [strategy: :one_for_one, name: RingLogger.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
