---
name: Fiscaliza Deputados
description: Transparência das despesas parlamentares do Ceará.
colors:
  paper: "#f2ead8"
  paper-light: "#f8f3e8"
  ink: "#25251f"
  ink-soft: "#5d5b51"
  green: "#193d35"
  green-hover: "#245448"
  red: "#b5422d"
  line: "#c9c0ad"
  line-strong: "#a99f89"
  focus: "#a43b28"
  gold: "#f2d66c"
typography:
  display:
    fontFamily: "Roboto Slab, Georgia, serif"
    fontSize: "clamp(2rem, 4vw, 3.25rem)"
    fontWeight: 600
    lineHeight: 1.08
    letterSpacing: "-0.025em"
  body:
    fontFamily: "DM Sans, Helvetica Neue, sans-serif"
    fontSize: "16px"
    fontWeight: 400
    lineHeight: 1.55
rounded:
  focus: "2px"
spacing:
  compact: "6px"
  small: "12px"
  medium: "20px"
  large: "30px"
  page: "58px"
components:
  site-header:
    backgroundColor: "{colors.green}"
    textColor: "{colors.paper-light}"
    height: "78px"
  profile-highlight:
    backgroundColor: "{colors.paper-light}"
    textColor: "{colors.green}"
    padding: "17px 20px 16px"
  text-link:
    textColor: "{colors.green}"
    typography: "14px DM Sans, Helvetica Neue, sans-serif; 700"
---

# Design System: Fiscaliza Deputados

## Overview

**Creative North Star: “Cordel de prestação de contas”**

Uma interface de consulta pública com a clareza de um registro editorial e o calor do papel impresso. A influência do cordel aparece na paleta de papel, tinta verde e acento vermelho; tabelas e dados mantêm leitura direta e familiar.

**Key Characteristics:**
- Papel creme, tinta escura e verde profundo
- Tipografia serifada nos títulos e sem serifa nos dados
- Traços finos e alinhamentos editoriais em vez de cartões decorativos

## Colors

A paleta combina papel quente, tinta escura, verde institucional e pequenos acentos vermelhos e dourados.

### Primary
- **Verde profundo** (#193d35): cabeçalho, links e números de despesa em destaque.
- **Vermelho xilogravura** (#b5422d): faixa de identidade e pequenos sublinhados de valor.

### Secondary
- **Papel** (#f2ead8): fundo principal.
- **Papel claro** (#f8f3e8): área de destaque para a maior despesa.
- **Tinta** (#25251f): texto principal.
- **Tinta suave** (#5d5b51): instruções e metadados.
- **Dourado** (#f2d66c): estado ativo de navegação e detalhe de marca.

## Typography

Roboto Slab dá personalidade aos títulos. DM Sans mantém navegação, metadados e valores legíveis em listas densas. Valores usam numerais tabulares.

## Layout

O conteúdo usa largura máxima de 1160px, margens laterais de 32px no desktop e 18px em telas menores. Abaixo de 760px, a lista de deputados vira linhas empilhadas e as despesas apresentam rótulos por célula. A tabela desktop mantém rolagem horizontal quando necessário.

## Elevation & Depth

A composição é plana. Diferencie regiões por cor de superfície, linhas finas e espaço; não use sombras para elevar tabelas ou áreas informativas.

## Shapes

As superfícies e retratos mantêm cantos retos. Bordas finas separam linhas. O foco de teclado usa contorno de 3px com afastamento de 4px e cantos de 2px.

## Components

- **Cabeçalho:** fundo verde, marca à esquerda, navegação à direita e faixa vermelha inferior.
- **Listas e despesas:** tabelas sem caixas externas, linhas horizontais e valores alinhados à direita.
- **Destaque de perfil:** superfície papel claro, maior valor em verde e link para o comprovante.
- **Links:** texto sublinhado, com mudança para vermelho no hover.

## Do's and Don'ts

- Preserve a hierarquia: títulos editoriais; dados em tabelas escaneáveis.
- Mantenha o contraste alto e o foco visível para navegação por teclado.
- Use vermelho em detalhes curtos, nunca como fundo de grandes áreas de texto.
- Evite sombras, cartões arredondados, gradientes e ícones decorativos.
