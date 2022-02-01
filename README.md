# FeatureFlag

FeatureFlag is project to abstract the communication with [Launch Darkly SDK](https://github.com/launchdarkly/erlang-server-sdk).

## Installation

Add git repository `feature_flag` in your `mix.exs`:

```elixir
defp deps do
  [
    ...,
    {:feature_flag, git: "https://github.com/solfacil/feature-flag.git", tag: "0.0.1"}
  ]
end
```

For details about git repository in `deps`, read [Git options](https://hexdocs.pm/mix/1.12/Mix.Tasks.Deps.html#module-git-options-git).

## Usage

A client instance must be started for feature flag evaluation to work. We recommend a GenServer to start a client instance on application startup and then feel free to use `FeatureFlag.check/3` function to get feature flag value.

**Below is a suggestion how to use the lib**

Use `config/<env>.exs` to set the Launch Darkly secret key.

```elixir
config :my_app, :feature_flag, secret_key: "ld-secret-key"
```

Create a GenServer to start a client instance.

```elixir
defmodule MyApp.FeatureFlag do
  use GenServer

  @doc false
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: :feature_flag_instance)
  end

  @doc false
  def init(_) do
    secret_key = secret_key()
    FeatureFlag.start_client(secret_key)

    {:ok, %{}}
  end

  defp secret_key, do: Application.get_env(:my_app, :feature_flag)[:secret_key]
end

# add the new GenServer to your supervisor tree
defmodule MyApp.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      MyApp.FeatureFlag
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

Now you are ready to go. Use `FeatureFlag.check/3` to evaluate given flag value for given user.

```elixir
iex> user = %FeatureFlag.User{key: "123abc", name: "John", email: "john@example.com"}
iex> FeatureFlag.check("admin-report", user)
true
```
