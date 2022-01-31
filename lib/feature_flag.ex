defmodule FeatureFlag do
  @moduledoc """
  Feature flag module to abstract [Launch Darkly SDK](
  https://github.com/launchdarkly/erlang-server-sdk).

  A client instance must be started for feature flag evaluation to work.
  We recommend a GenServer to start a client instance on application startup and then feel
  free to use `FeatureFlag.check/3` function to get feature flag value.

  ### Usage

      FeatureFlag.start_client("launch-darkly-secret-key")
      user = %FeatureFlag.User{key: "123abc", name: "John", email: "john@example.com"}
      FeatureFlag.check("admin-report", user)

  """

  @doc """
  Start a new client instance with default options given a Launch Darkly secret key.

  A client instance must be started for feature flag evaluation to work. If instance
  is already started, an error will be thrown.
  """
  @spec start_client(String.t()) :: :ok
  def start_client(secret_key) do
    :ok =
      :ldclient.start_instance(String.to_charlist(secret_key), %{
        http_options: %{
          tls_options: :ldclient_config.tls_basic_options()
        }
      })
  end

  @doc """
  Stop the default client instance.

  If no instances was started, an error will be thrown.
  """
  @spec stop_client() :: :ok
  def stop_client() do
    :ok = :ldclient.stop_instance()
  end

  @doc """
  Check given flag name for given user.

  `user` is a struct from `FeatureFlag.User` which implements all the user attributes from
  Launch Darkly documentation. See [Understanding user attributes](
  https://docs.launchdarkly.com/home/users/attributes#understanding-user-attributes)
  and `FeatureFlag.User` module for more details.

  ### Good to know
    * If flag name doesn't exists, the `default` value will be returned.
    * If given user doesn't exists, the feature flag default value will be returned.

  ### Usage

      user = %FeatureFlag.User{key: "123abc", email: "john.due@example.com"}
      FeatureFlag.check("feature-name", user)

  """
  @spec check(String.t(), FeatureFlag.User.t(), boolean()) ::
          boolean() | integer() | float() | binary() | list() | map()
  def check(flag_name, %FeatureFlag.User{} = user, default \\ false) do
    built_in_user =
      user
      |> Map.from_struct()
      |> :ldclient_user.new_from_map()

    :ldclient.variation(flag_name, built_in_user, default)
  end
end
