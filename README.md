# Fiscaliza Deputados

Aplicação Rails para consultar deputados do Ceará e despesas parlamentares importadas da API de Dados Abertos da Câmara dos Deputados.

## Requisitos e execução local

- Ruby **4.0.7**, definido em `.ruby-version` e `.tool-versions`.
- Rails **8.1.4** e dependências fixadas em `Gemfile.lock`.
- PostgreSQL em execução. A configuração local padrão usa o socket e o usuário do sistema operacional.

Com asdf, instale a versão configurada e prepare o projeto:

```sh
asdf install
bundle install
bin/setup --skip-server
bin/dev
```

Acesse http://localhost:3000. `bin/setup` também inicia o servidor se você omitir `--skip-server`. Para conectar com outro usuário ou host PostgreSQL, ajuste `config/database.yml` ou defina `DATABASE_URL`. A opção `bin/setup --reset` apaga e recria os bancos locais; use-a somente quando puder descartar os dados.

## Importação de dados

```sh
bin/rake sync_deputies
bin/rake sync_expenses
```

Execute primeiro `sync_deputies`. Ambas as tarefas acessam a API externa e escrevem no banco do ambiente selecionado. O filtro atual busca deputados do Ceará (`CE`); as despesas abrangem os anos de 2019 a 2022. Confira `lib/tasks/` antes de mudar esses filtros ou importar para um banco com dados importantes.

## Testes e verificações

```sh
RAILS_ENV=test bin/rails db:prepare
bundle exec rspec
bin/rails zeitwerk:check
RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
```

Execute um spec específico passando seu caminho, por exemplo `bundle exec rspec spec/models/deputy_spec.rb`. Os testes de integração com a Câmara usam WebMock e não chamam a API real. Quatro specs antigos ainda estão pendentes.

## Framework e estrutura

O projeto usa Rails 8.1.4 com `config.load_defaults 8.1`. Propshaft compila os assets CSS; JavaScript usa Importmap, Turbo e Stimulus sem etapa npm. Os modelos, páginas, rotas e migrations históricas foram preservados. Estas migrations continuam usando `ActiveRecord::Migration[7.0]` para manter a semântica original.

Para atualizar um banco existente, faça backup e rode `bin/rails db:migrate`. Não use `db:reset` ou `db:schema:load` em um banco cujos dados queira manter. O endpoint `/up` fornece uma verificação de saúde da aplicação.

## Produção e configuração

Configure `DATABASE_URL` ou `FISCALIZA_DEPUTADOS_DATABASE_PASSWORD` e `SECRET_KEY_BASE`. Se os segredos estiverem nas credenciais Rails existentes, forneça a chave por `RAILS_MASTER_KEY`; não versione `config/master.key`. A configuração de produção força HTTPS e pressupõe um proxy que termina TLS. Action Cable usa Redis via `REDIS_URL` (o padrão aponta para `localhost:6379`); configure um Redis acessível no ambiente de produção. Jobs e cache usam os adaptadores em memória padrão.

### Deploy com Kamal

O deploy em `config/deploy.yml` usa a VPS `REDACTED` e o domínio `deputados.gurgelrenan.tech`. A imagem é publicada em `ghcr.io/gurgelrenan/fiscaliza-deputados`, na arquitetura `amd64`. PostgreSQL e Redis rodam como acessórios na rede Docker do Kamal, sem portas públicas. Os dados do PostgreSQL ficam no diretório persistente configurado no servidor.

Copie `.kamal/secrets.example` para `.kamal/secrets` e configure o token do GHCR e uma senha persistente para o banco. As credenciais criptografadas de produção estão em `config/credentials/production.yml.enc`; forneça a chave correspondente por `RAILS_MASTER_KEY` ou pelo arquivo local `config/credentials/production.key`. Nunca versione arquivos `.key` ou `.kamal/secrets`.

```sh
bin/kamal setup  # Primeiro deploy: prepara servidor, acessórios e aplicação.
bin/kamal deploy  # Deploys seguintes.
```

O hook `pre-deploy` configura o kamal-proxy sem publicar portas. O Traefik existente na VPS encaminha o domínio para esse proxy e emite o certificado pelo resolver `letsencrypt`, na entrypoint `websecure`. A configuração pressupõe Traefik com descoberta Docker e conectividade com a rede do Kamal. O container executa `db:prepare` antes de iniciar o servidor Rails; a importação dos dados é feita separadamente.
