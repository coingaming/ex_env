# ExEnv

Tool provides support of Elixir terms in system env variables.
For security reasons only literals/terms are allowed in configs (no functions, macros, modules etc).

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
use Mix.Config
config :best_app, ExEnv.get("BEST_APP_CONFIG")
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