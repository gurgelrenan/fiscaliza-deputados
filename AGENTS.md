# Repository Guidelines

## Project Structure & Module Organization

This Rails 7 application displays Brazilian deputies and their parliamentary expenses using Câmara dos Deputados open data.

- `app/models/` contains `Deputy`, `Expense`, `ExpenseType`, and `Provider`; controllers and ERB views live in their standard `app/` directories.
- `app/assets/` holds stylesheets; `app/javascript/` contains importmap-managed JavaScript and Stimulus controllers.
- `config/` contains routes, environments, and database configuration.
- `db/migrate/` holds migrations; `db/schema.rb` records the generated schema.
- `lib/tasks/` contains deputy and expense synchronization tasks.
- `spec/` contains model, request, and helper specs, FactoryBot factories, and shared support.

## Build, Test, and Development Commands

Use Ruby 3.0.0, Bundler, and a running PostgreSQL instance. Check local connection settings in `config/database.yml`.

- `bin/setup`: installs dependencies, prepares the database, clears logs and temporary files, and requests a server restart.
- `bin/rails server`: starts the local application.
- `bin/rails db:migrate`: applies migrations; commit the resulting schema changes.
- `bundle exec rspec`: runs all specs; append `spec/models/deputy_spec.rb` for a focused run.
- `bin/rails assets:precompile`: builds assets through Sprockets.
- `bin/rake sync_deputies`, then `bin/rake sync_expenses`: imports external data into the selected database. Deputies are currently filtered to Ceará (`CE`); expenses cover hard-coded years 2019–2022. Review these filters before importing.

## Coding Style & Naming Conventions

Use two-space indentation, `snake_case` filenames and methods, and `CamelCase` classes. Follow Rails singular model and plural controller/table conventions. Match surrounding quote style; application Ruby generally uses single quotes for plain strings. Keep database queries in models and presentation in views/helpers. No formatter or linter is configured.

## Testing Guidelines

Use RSpec Rails and FactoryBot. Name tests `*_spec.rb` under the matching `spec/` directory. Existing specs include pending placeholders; add behavioral assertions for changed code, including expense calculations and request responses. Stub external HTTP calls in synchronization tests. No coverage threshold is configured.

## Commit & Pull Request Guidelines

Recent commits use `[MAIN]` followed by a short summary, for example `[MAIN] Add basic style and show page`. Follow that pattern and keep changes focused. PRs should explain the change, link relevant issues, report tests and remaining pending examples, and include screenshots for UI changes. Call out migrations or import-filter changes.

## Security & Configuration

Keep credentials and database passwords out of source control. Use Rails encrypted credentials or environment variables such as `FISCALIZA_DEPUTADOS_DATABASE_PASSWORD`; never commit `config/master.key`.
