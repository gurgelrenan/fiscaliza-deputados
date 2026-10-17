# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Inferred from the repository: people in Ceará who want to inspect the expenses reported by state deputies.

## Product Purpose

Inferred from the repository: make parliamentary expenses easier to inspect by showing deputy profiles, total expenses, individual transactions, and links to receipts.

## Positioning

The app brings deputy expense totals and receipt links together in one place. The repository currently describes imports for Ceará and 2019–2022; the importer scope may have changed independently and is not confirmed as the current public coverage.

## Capabilities and Constraints

- Lists deputies with recorded expenses, their photos, names, and aggregate expenses.
- Shows a deputy's party, Câmara profile link, highest expense, and dated expense rows with providers and receipt links.
- Built with Rails and ERB views. Expense and deputy data come from Câmara dos Deputados open data import tasks.
- The active data coverage and the intended audience are inferred and remain unconfirmed.

## Evidence on Hand

- Existing views: `app/views/deputies/index.html.erb` and `app/views/deputies/show.html.erb`.
- Existing models and controller: `app/models/deputy.rb`, `app/models/expense.rb`, and `app/controllers/deputies_controller.rb`.
- The app has real deputy photos, profile links, expense amounts, providers, dates, and receipt URLs when those records are present. Do not fabricate records or totals.

## Product Principles

- Make it easy to scan and compare recorded expenses.
- Keep receipt and official profile sources close to the facts they support.
- Never imply broader or newer data coverage than the records establish.
