defmodule FeatureFlag.User do
  @moduledoc """
  For a list of all built-in user attributes LaunchDarkly supports, read
  [Understanding user attributes](
  https://docs.launchdarkly.com/home/users/attributes#understanding-user-attributes).

  For custom user attributes, read [Setting custom user attributes](
  https://docs.launchdarkly.com/home/users/attributes#setting-custom-user-attributes).

  Only `key` attribute are required.
  """

  @enforce_keys [:key]
  defstruct [
    :key,
    :secondary,
    :ip,
    :email,
    :name,
    :avatar,
    :first_name,
    :last_name,
    :country,
    :anonymous,
    :custom
  ]

  @type t :: %__MODULE__{
          key: String.t(),
          secondary: String.t(),
          ip: String.t(),
          email: String.t(),
          name: String.t(),
          avatar: String.t(),
          first_name: String.t(),
          last_name: String.t(),
          country: String.t(),
          anonymous: String.t(),
          custom: map()
        }
end
