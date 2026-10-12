# Repository Guidelines

## Project Structure

This Rails 8.1 app displays Brazilian deputies and parliamentary expenses from Câmara dos Deputados open data.

- `app/models/` defines deputies, expenses, providers, and expense types; controllers and ERB views follow the standard Rails layout.
- `app/assets/stylesheets/` contains CSS built with Propshaft. JavaScript uses Importmap, Turbo, and Stimulus under `app/javascript/`.
- `config/` holds routes, database settings, and environment configuration; `db/migrate/` holds migrations and `db/schema.rb` the current schema.
- `lib/tasks/` contains the external deputy and expense importers.
- `spec/` contains RSpec model, request, and helper tests, factories, and task coverage.

## Setup and Development

Use Ruby 4.0.7 (`.ruby-version`, `.tool-versions`), Bundler, and PostgreSQL. Install Ruby with `asdf install`; configure PostgreSQL in `config/database.yml` or with `DATABASE_URL`.

- `bundle install`: install locked dependencies.
- `bin/setup --skip-server`: prepare dependencies and databases, then clear temporary files.
- `bin/dev`: run the local Rails server; open `http://localhost:3000`.
- `bin/rails db:migrate`: apply migrations and update `db/schema.rb`.
- `bin/rails zeitwerk:check`: verify Rails autoloading.
- `RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile`: check the production asset build.

The importers access the Câmara API and write to the selected database: run `bin/rake sync_deputies` before `bin/rake sync_expenses`. Their current scope is Ceará (`CE`) and years 2019–2022; review `lib/tasks/` before changing or running imports against important data.

## Style and Testing

Use two-space Ruby indentation, `snake_case` filenames and methods, and `CamelCase` classes. Follow Rails naming and nearby code conventions. RSpec and FactoryBot are the test stack; name examples `*_spec.rb` in the matching `spec/` subdirectory. Run `bundle exec rspec` (or pass a spec path). Stub HTTP requests with WebMock rather than contacting the Câmara API. Four legacy specs remain pending; no coverage threshold or formatter is configured.

## Commits and Pull Requests

Keep commits focused and use a short descriptive subject. Repository hooks may add branch and `[MAIN]` prefixes. PRs should describe behavior and rationale, report verification results and pending specs, and call out migrations, deployment settings, or import-scope changes. Include screenshots for UI changes.

## Security and Configuration

Never commit secrets or `config/master.key`. Use encrypted Rails credentials or environment variables such as `DATABASE_URL`, `FISCALIZA_DEPUTADOS_DATABASE_PASSWORD`, `RAILS_MASTER_KEY`, and `REDIS_URL`. Production assumes HTTPS behind a TLS-terminating proxy.
