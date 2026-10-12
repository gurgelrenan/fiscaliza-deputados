# Fiscaliza Deputados

Aplicação Rails para consultar deputados do Ceará e suas despesas, importadas da API de Dados Abertos da Câmara dos Deputados.

## Requisitos

- Ruby **4.0.7** (fixado em `.ruby-version` e `.tool-versions`).
- Rails **8.1.4**, com dependências fixadas em `Gemfile.lock`.
- PostgreSQL em execução e um usuário com permissão para criar os bancos locais.

Com asdf: `asdf install`. Depois:

```sh
bundle install
bin/setup --skip-server
bin/dev
```

Abra http://localhost:3000. `bin/setup` sem `--skip-server` também inicia o servidor. A configuração padrão usa PostgreSQL via socket local e o usuário do sistema; ajuste `config/database.yml` ou use `DATABASE_URL` para outra conexão. Não use `bin/setup --reset` em bancos com dados que precisam ser mantidos.

## Importação

```sh
bin/rake sync_deputies
bin/rake sync_expenses
```

As tarefas escrevem no banco do ambiente selecionado e acessam a API externa. O comportamento original foi preservado: deputados filtrados por `CE` e despesas dos anos **2019–2022**. Revise `lib/tasks/` para alterar esse recorte; a atualização do framework não amplia a coleta automaticamente.

## Testes e verificação

```sh
RAILS_ENV=test bin/rails db:prepare
bundle exec rspec
bin/rails zeitwerk:check
RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
```

Para um teste específico: `bundle exec rspec spec/models/deputy_spec.rb`. RSpec usa FactoryBot e WebMock; os testes de importação não consultam a API real. Não aponte o ambiente de teste para um banco de produção. Alguns specs gerados originalmente continuam pendentes.

## Base atualizada

As configurações de aplicação, ambientes, Puma e scripts de desenvolvimento foram trazidas de uma aplicação nova Rails 8.1.4, com `config.load_defaults 8.1`. Models, migrations, rotas e páginas do projeto foram reaproveitados. Propshaft substitui Sprockets; JavaScript continua com Importmap, Turbo e Stimulus, sem etapa npm. O depurador agora é `debug`; a gem antiga `annotate` e seu hook automático foram removidos.

As migrations históricas continuam em `ActiveRecord::Migration[7.0]` para preservar sua semântica. Para um banco existente, faça backup e execute `bin/rails db:migrate`; não use `db:reset` nem `db:schema:load` sobre seus dados.

Em produção, configure `DATABASE_URL` ou `FISCALIZA_DEPUTADOS_DATABASE_PASSWORD` e forneça `SECRET_KEY_BASE` ou a chave das credenciais existentes via `RAILS_MASTER_KEY`. As credenciais criptografadas originais foram preservadas. A configuração nova exige HTTPS e pressupõe um proxy que termina TLS. O endpoint `/up` verifica a inicialização da aplicação. Action Cable mantém o adaptador Redis (`REDIS_URL`); jobs e cache usam os adaptadores em memória padrão.
