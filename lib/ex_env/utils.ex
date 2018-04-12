defmodule ExEnv.Utils do

  @moduledoc """

  ExEnv general utilities.

  """

  @doc """

  Returns :ok if otp_app is acceptable, else raises exception.

  ## Example

    ```
    iex> ExEnv.Utils.validate_otp_app(:hello_world)
    :ok
    iex> ExEnv.Utils.validate_otp_app(:hello_123)
    ** (RuntimeError) invalid OTP application name hello_123
    ```

  """

  def validate_otp_app(otp_app) when is_atom(otp_app) do
    ~r/^([a-z]+[a-z0-9]*)(_[a-z]+[a-z0-9]*)*([a-z]+[a-z0-9]*)$/
    |> Regex.match?(Atom.to_string(otp_app))
    |> case do
      true ->
        :ok
      false ->
        "invalid OTP application name #{otp_app}"
        |> raise
    end
  end

  @doc """

  Returns :ok if config AST is acceptable, else raises exception.

  ## Example

    ```
    iex> ExEnv.Utils.validate_config_ast([foo: 123])
    :ok
    ```

  """

  def validate_config_ast(_) do
    #
    # TODO : implement validation!!!
    #
    :ok
  end

end
