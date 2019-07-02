defmodule ExEnv do
  @moduledoc """

  Tool provides support of Elixir terms in system env variables.
  For security reasons only literals/terms are allowed in configs (no functions, macros, modules etc).

  """

  defmacro __using__([]) do
    quote do
      use Mix.Config
      require ExEnv

      Mix.Project.config()[:deps]
      |> Enum.each(fn dependency ->
        ExEnv.config(elem(dependency, 0))
      end)

      ExEnv.config(Mix.Project.config()[:app])
      ExEnv.config(:logger)
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

  defmacro config(otp_app_ast) do
    quote do
      otp_app = unquote(otp_app_ast)

      unless is_atom(otp_app) do
        "otp_app should be Erlang atom type, but got #{inspect(otp_app)}"
        |> raise
      end

      ExEnv.config(otp_app, "#{otp_app |> Atom.to_string() |> String.upcase()}_CONFIG")
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

  defmacro config(otp_app_ast, os_var_name_ast) do
    quote do
      otp_app = unquote(otp_app_ast)
      os_var_name = unquote(os_var_name_ast)

      unless is_atom(otp_app) do
        "otp_app should be Erlang atom type, but got #{inspect(otp_app)}"
        |> raise
      end

      unless String.valid?(os_var_name) do
        "os_var_name should be string, but got #{os_var_name}"
        |> raise
      end

      :ok = ExEnv.Utils.validate_otp_app(otp_app)

      os_var_name
      |> System.get_env()
      |> case do
        nil ->
          :ok

        config_string when is_binary(config_string) ->
          config_string
          |> Code.string_to_quoted()
          |> case do
            {:ok, config_ast} ->
              :ok = ExEnv.Utils.validate_config_ast(config_ast)
              {config_term, []} = Code.eval_quoted(config_ast)
              config(otp_app, config_term)

            {:error, error} ->
              "application #{otp_app} got error #{inspect(error)} while parse AST of #{config_string}"
              |> raise
          end
      end
    end
  end
end
