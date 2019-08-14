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
    ~r/^([a-z]+[a-z0-9]*)(_[a-z]+[a-z0-9]*)*$/
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
    iex> quote do [foo: 123] end |> ExEnv.Utils.validate_config_ast
    :ok
    iex> quote do [1, 2, 3] end |> ExEnv.Utils.validate_config_ast
    :ok
    iex> quote do %{hello: "world"} end |> ExEnv.Utils.validate_config_ast
    :ok
    iex> quote do {:hello, "world"} end |> ExEnv.Utils.validate_config_ast
    :ok
    iex> quote do {:hello, "world", 123} end |> ExEnv.Utils.validate_config_ast
    :ok
    iex> quote do [{Hello.World, [foo: "bar"]}] end |> ExEnv.Utils.validate_config_ast
    :ok
    iex> quote do %Date{year: 1990, month: 1, day: 1} end |> ExEnv.Utils.validate_config_ast
    :ok

    iex> {:__aliases__, [], [Foo, "Bar"]} |> ExEnv.Utils.validate_config_ast
    ** (RuntimeError) wrong submodule "Bar" name in AST chunk {:__aliases__, [], [Foo, "Bar"]}

    iex> quote do Foo.bar("hello") end |> ExEnv.Utils.validate_config_ast
    ** (RuntimeError) invalid or unsafe config AST {{:., [], [{:__aliases__, [alias: false], [:Foo]}, :bar]}, [], ["hello"]}
    ```

  """

  def validate_config_ast(list) when is_list(list) do
    list
    |> Enum.each(&(:ok = validate_config_ast(&1)))
  end

  def validate_config_ast({:%{}, _, pairs}) when is_list(pairs) do
    pairs
    |> Enum.each(fn {key, value} ->
      :ok = validate_config_ast(key)
      :ok = validate_config_ast(value)
    end)
  end

  def validate_config_ast({:%, _, ast}) do
    :ok = validate_config_ast(ast)
  end

  def validate_config_ast({el1, el2}) do
    :ok = validate_config_ast(el1)
    :ok = validate_config_ast(el2)
  end

  def validate_config_ast({:{}, _, values}) do
    values
    |> Enum.each(&validate_config_ast/1)
  end

  def validate_config_ast(ast = {:__aliases__, _, submodules = [_ | _]}) do
    submodules
    |> Enum.each(fn sub ->
      unless is_atom(sub) do
        "wrong submodule #{inspect(sub)} name in AST chunk #{inspect(ast)}"
        |> raise
      end
    end)
  end

  def validate_config_ast(data)
      when is_atom(data) or
             is_binary(data) or
             is_number(data) do
    :ok
  end

  def validate_config_ast(ast) do
    "invalid or unsafe config AST #{inspect(ast)}"
    |> raise
  end
end
