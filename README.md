# ExEnv

Tool provides support of Elixir terms in system env variables.
For security reasons only literals/terms are allowed in configs (no functions, macros, modules etc).
I very recommend to combine this tool with [BootEnv](https://github.com/coingaming/boot_env).

# Installation

```
mix archive.install hex ex_env 0.3.0 --force
```

# Usage

For every OTP application, default system variable name is **&lt;UPPER_CASE_OTP_APP&gt;_CONFIG**. Example:

### OS

```
export BEST_APP_CONFIG="                                          \
  [                                                               \
    {                                                             \
      BestApp.Repo,                                               \
      [                                                           \
        adapter: Ecto.Adapters.Postgres,                          \
        url: \"ecto://postgres:postgres@localhost/best_app\",     \
        pool_size: 10                                             \
      ]                                                           \
    },                                                            \
    {                                                             \
      BestApp.Endpoint,                                           \
      [                                                           \
        http: [port: 4001],                                       \
        server: true                                              \
      ]                                                           \
    },                                                            \
    {                                                             \
      :workers_pool_size,                                         \
      100                                                         \
    }                                                             \
  ]                                                               \
"
```

### config.exs

```elixir
use ExEnv # put this line to the bottom of file
```

### source code

```elixir
iex> Application.get_env(:best_app, :workers_pool_size)
100
iex> Application.get_env(:best_app, BestApp.Repo)
[
  adapter: Ecto.Adapters.Postgres,
  url: "ecto://postgres:postgres@localhost/best_app",
  pool_size: 10
]
```

### external applications

By default **use ExEnv** expression allows to use system-variable based configs for:

- main OTP application of project
- all project dependencies
- :logger OTP application

If you need to configure other OTP application - you can use **ExEnv.config** macro manually in **config.exs** (or other config) file

```elixir
use ExEnv
ExEnv.config(:other_app)
ExEnv.config(:other_app, "CUSTOM_ENV_VAR")
```
