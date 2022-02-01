defmodule FeatureFlag.Server do
  @moduledoc """
  Module helper to start a new SDK instance. If no `:secret_key` option are given,
  an error will be thrown.

  ### Usage

      defmodule MyApp.Application do
        @moduledoc false

        use Application

        def start(_type, _args) do
          children = [
            {FeatureFlag.Server, [secret_key: "sdk-123"]}
          ]

          opts = [strategy: :one_for_one, name: MyApp.Supervisor]
          Supervisor.start_link(children, opts)
        end
      end

  """

  use GenServer

  @doc false
  def start_link(args) when is_list(args) do
    GenServer.start_link(__MODULE__, args, name: :feature_flag_server)
  end

  @doc false
  def init(args) do
    args
    |> find_secret_key!()
    |> FeatureFlag.start_client()

    {:ok, %{}}
  end

  defp find_secret_key!(args) do
    case Keyword.get(args, :secret_key) do
      nil ->
        raise "Failed to initialize #{__MODULE__} due to missing :secret_key option"

      secret_key ->
        secret_key
    end
  end
end
