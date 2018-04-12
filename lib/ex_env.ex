defmodule ExEnv do
  @moduledoc """

  Tool provides support of Elixir terms in system env variables.
  For security reasons only literals/terms are allowed in configs (no functions, macros, modules etc).

  """

  defmacro __using__([]) do
    quote do
      use Mix.Config
      require ExEnv
    end
  end

  @doc """

  Works as Mix.Config.Config macro.
  Gets single argument, name of otp_app (atom).
  Infers config system variable name from otp_app argument:
  capitalize name and adds _CONFIG postfix.

  ## Example

    ```
    # reads, validates and evaluates BEST_APP_CONFIG system variable
    ExEnv.config(:best_app)
    ```

  """
  defmacro config(otp_app) when is_atom(otp_app) do
    os_var_name = "#{otp_app |> Atom.to_string |> String.upcase}_CONFIG"
    quote do
      ExEnv.config(unquote(otp_app), unquote(os_var_name))
    end
  end

  @doc """

  Works as &ExEnv.config/1 macro, but
  second argument is explicit system variable name.

  ## Example

    ```
    # reads, validates and evaluates MY_FAVORITE_APP_DATA system variable
    ExEnv.config(:best_app, "MY_FAVORITE_APP_DATA")
    ```

  """

  defmacro config(otp_app, os_var_name) when is_atom(otp_app) and is_binary(os_var_name) do
    :ok = ExEnv.Utils.validate_otp_app(otp_app)
    quote do
      unquote(os_var_name)
      |> System.get_env
      |> case do
        nil ->
          :ok
        config_string when is_binary(config_string) ->
          config_string
          |> Code.string_to_quoted
          |> case do
            {:ok, config_ast} ->
              config_ast
              |> Keyword.keyword?
              |> case do
                true ->
                  :ok = ExEnv.Utils.validate_config_ast(config_ast)
                  {config_term, []} = Code.eval_quoted(config_ast)
                  config(unquote(otp_app), config_term)
                false ->
                  "application #{unquote(otp_app)} got not keyword list AST from #{config_string}"
                  |> raise
              end
            {:error, error} ->
              "application #{unquote(otp_app)} got error #{inspect error} while parse AST of #{config_string}"
              |> raise
          end
      end
    end
  end

end
