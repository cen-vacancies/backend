[
  locals_without_parens: [assert_schema: 2],
  import_deps: [:ecto, :ecto_sql, :phoenix, :open_api_spex],
  subdirectories: ["priv/*/migrations"],
  plugins: [Styler, TailwindFormatter, Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
]
