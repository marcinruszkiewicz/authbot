defmodule Authbot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AuthbotWeb.Telemetry,
      Authbot.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Authbot.PubSub},
      # Start the Endpoint (http/https)
      AuthbotWeb.Endpoint
      # Start a worker by calling: Authbot.Worker.start_link(arg)
      # {Authbot.Worker, arg}
    ]
    |> start_nostrum(Application.get_env(:authbot, :environment))

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Authbot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AuthbotWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp start_nostrum(children, :test), do: children
  defp start_nostrum(children, _env), do: children ++ [Authbot.BotConsumer]
end
