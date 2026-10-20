# Analytics do Fiscaliza Deputados

## Ativação

O deploy está configurado para o projeto **677064**, na região **US Cloud**.
A chave de ingestão fica em `.kamal/secrets`, ignorado pelo Git. `config/deploy.yml` contém apenas o nome `POSTHOG_PROJECT_KEY` em `env.secret`.
Painel do projeto: https://us.posthog.com/project/677064.
Essa configuração passa a valer no site publicado após o próximo deploy.

Crie um projeto no PostHog e copie a **Project API Key** (`phc_...`) em Settings → Project.
Essa chave é pública e aparece no navegador. Não use uma Personal API Key no site.

Configure no ambiente do processo Rails:

```sh
export POSTHOG_PROJECT_KEY='phc_...'
export POSTHOG_API_HOST='https://us.i.posthog.com'
```

Para projetos da região EU, use `https://eu.i.posthog.com`. Reinicie o Rails depois de alterar essas variáveis.
Em produção, a presença da chave ativa a integração. `POSTHOG_ENABLED=false` desativa a coleta.
Em desenvolvimento, é necessário definir também `POSTHOG_ENABLED=true`; use um projeto separado para não misturar testes com visitantes reais.
O app não carrega `.env` automaticamente: exporte as variáveis no shell ou configure-as no gerenciador do processo.
Para o deploy Kamal, configure `POSTHOG_PROJECT_KEY` em `.kamal/secrets` (ou exporte a variável e use `POSTHOG_PROJECT_KEY=$POSTHOG_PROJECT_KEY` nesse arquivo). Host e ativação usam os padrões de `config/deploy.yml`, com sobrescrita pelo ambiente local. Não versione a chave.

O SDK JavaScript é carregado do CDN oficial. Navegações Turbo geram uma visualização ao concluir, incluindo voltar/avançar, sem contar previews do cache.
As interações são marcadas explicitamente. Autocapture, gravações de sessão, heatmaps e pesquisas estão desativados.
Um identificador anônimo persiste no localStorage para reconhecer o mesmo navegador em visitas futuras. Não há identificação por login.
Trocar de navegador, limpar o armazenamento ou bloquear o tracker afeta as contagens e a retenção.

## Eventos

| Evento | Quando acontece | Propriedades específicas |
| --- | --- | --- |
| `$pageview` | Cada página concluída pelo Turbo | `page` e contexto da página |
| `deputies_list_viewed` | Exibição da lista | `page=deputies_list`, `search_active`, `result_count` |
| `deputy_expenses_viewed` | Exibição das despesas de um deputado, inclusive filtros e meses | `deputy_id` (ID da Câmara), `deputy_name`, `political_party`, `month`, `expense_type_id` |
| `monthly_expenses_viewed` | Exibição das despesas de um mês válido | Mesmo contexto do deputado |
| `feature_used` | Interação com um recurso | `feature`, contexto da página e propriedades da ação |

Valores de `feature`: `search_deputies`, `clear_search`, `select_deputy`, `filter_expenses`, `clear_filters`, `view_month`, `view_all_months`, `sort_expenses` e `open_receipt`.
Busca registra o envio de um termo não vazio. O texto digitado não entra nos eventos; o parâmetro `q` também é removido das propriedades de URL e referrer antes do envio ao PostHog.
O filtro registra o envio do formulário, com o tipo selecionado; a visualização seguinte registra o estado aceito pelo servidor.
Comprovantes registram o clique (`expense_id`, `source`), sem afirmar que o documento externo carregou.
Ordenação inclui `sort`; seleção de mês inclui `month`. Nenhum campo de texto livre é coletado pelos eventos personalizados.

## Dashboard: Uso do Fiscaliza Deputados

Crie um dashboard privado com os relatórios abaixo. A integração do site envia os eventos; ela não cria relatórios na conta automaticamente.
Use inicialmente os últimos 30 dias, exceto retenção, que precisa de um período maior.

### 1. Quais deputados recebem mais consultas?

Crie um insight **Trends** com `deputy_expenses_viewed`, agregação **Unique users**, breakdown por `deputy_name`, visualização em barras.
Para distinguir nomes iguais, use `deputy_id`. A contagem por visitantes únicos evita que navegar por vários meses infle o ranking de audiência.
Uma segunda série com **Total count** mostra o volume de consultas, incluindo recargas e mudanças de filtro.

### 2. Quantas pessoas usam busca e filtros?

Crie **Trends** com `feature_used`, agregação **Unique users**, filtro `feature` igual a `search_deputies`, `filter_expenses` ou `view_month`, breakdown por `feature`.
Para a proporção de visitantes que usam o filtro, crie um funil `deputy_expenses_viewed` → `feature_used` com `feature=filter_expenses`, janela de 30 minutos.

Para encontrar buscas sem resultados, use `deputies_list_viewed` com `search_active=true` e `result_count=0`. O contador pertence à página de resultados, não ao evento de envio do formulário.

### 3. Quantas passam da lista para a consulta de despesas?

Crie **Funnels**, ordem sequencial, janela de conversão de 30 minutos:

1. `deputies_list_viewed`
2. `deputy_expenses_viewed`
3. `monthly_expenses_viewed`

A conversão da etapa 1 para a 2 responde à pergunta; a etapa 3 mede aprofundamento.
Entradas diretas na página do deputado aparecem no ranking, mas não entram nesse funil sem passar pela lista.
Para medir abertura de documentos, acrescente uma quarta etapa `feature_used` filtrada por `feature=open_receipt`.

### 4. Quais funcionalidades estão associadas ao retorno?

Crie um insight **Retention** para cada recurso (`search_deputies`, `filter_expenses`, `view_month`, `open_receipt`):

- Evento inicial: `feature_used`, filtrado pelo valor de `feature` apenas no evento inicial.
- Evento de retorno: `$pageview` sem filtro de recurso, para contar qualquer volta ao site.
- Intervalo: semanal, últimas oito semanas, retorno **On or after**.
- Compare com uma retenção geral `$pageview` → `$pageview` com os mesmos intervalos.

Não use um filtro global de `feature`, pois `$pageview` não tem essa propriedade.
Compare as semanas posteriores à semana zero. Os relatórios mostram associação entre uso e retorno, sem demonstrar que o recurso causou o retorno.
Os dados começam na ativação: não há histórico retroativo e as semanas futuras ainda não terão resultados.

## Verificação

```sh
bundle exec rspec spec/requests/analytics_spec.rb spec/requests/deputies_spec.rb
node --test spec/javascript/analytics_test.mjs
```

Em um projeto de teste com coleta habilitada, abra Live events no PostHog. Acesse a lista, selecione um deputado, envie um filtro, abra um mês e um comprovante.
Confira os nomes e propriedades acima; ao voltar/avançar, deve existir apenas um `$pageview` por navegação concluída.
O envio ao projeto real precisa da chave válida e de uma navegação no site publicado.

Referências: [SDK JavaScript](https://posthog.com/docs/libraries/js), [configuração](https://posthog.com/docs/libraries/js/config), [retenção](https://posthog.com/docs/product-analytics/retention).
