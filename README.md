# Bibliotela · Catálogo do Design System

![Flutter](https://img.shields.io/badge/Flutter-3.19%2B-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS%20%7C%20Web-0F6E8C)
![Temas](https://img.shields.io/badge/temas-claro%20%7C%20escuro-1F2328)

Aplicativo Flutter criado para documentar, visualizar e testar os componentes do **Design System da Bibliotela**, o app de livros, séries e filmes. A tela inicial funciona como um índice: ao escolher uma categoria, o aplicativo mostra todos os componentes relacionados, as variações e os estados de interação.

## Objetivo

O projeto transforma o Design System criado no Figma em um catálogo interativo. Ele facilita a consulta aos componentes, demonstra os comportamentos e mantém uma referência visual para designers e desenvolvedores.

O aplicativo não é o app da Bibliotela. Seu foco é demonstrar os elementos reutilizáveis que o app vai usar: botões, campos, cards, seletores, carregamento de tela, rótulos e os tokens.

## Design no Figma

[Adicione aqui o link do arquivo do Figma]

As categorias, os nomes dos componentes, os estados e os tokens deste catálogo são os mesmos do arquivo do Figma: uma página por categoria.

## Funcionalidades

- Página inicial com as categorias do Design System;
- Galeria de cada categoria, com os componentes, as variações e os estados rotulados;
- Componentes de verdade (campos digitáveis, controle segmentado, chips, nota em estrelas com meia estrela, chip de ano com menu, abas, diálogo);
- **Tema claro e escuro**, com o botão de alternar no topo de cada tela;
- **Telas de exemplo** de carregamento (esqueletos que viram a lista), vazio e erro (com "Tentar novamente");
- Tokens: cores nos dois temas, tipografia, espaçamento, raios e sombras;
- Organização modular por responsabilidade;
- Exemplo de aplicação de ViewModel e Factory;
- Suporte às plataformas Android, iOS e Web.

## Categorias do catálogo

| Categoria | Componentes demonstrados |
| --- | --- |
| Ações | Button (primário, secundário, texto, perigo), IconButton, FAB |
| Navegação | TopBar, BottomTabs, YearChip e YearMenu |
| Campos e filtros | TextField, PasswordField, SearchField, Dropdown, DateField, TextArea |
| Seletores e controles | SegmentedControl, FilterChip, StarRating, StarRatingInput, StatusChip |
| Cards e conteúdo | ItemTile, ListCard, SummaryCard, GenreBar, MediaCover, Avatar, NoteCard, DetailRow |
| Feedback e carregamento | Spinner, Skeleton, StateView, ConfirmDialog, InlineMessage e telas de exemplo |
| Rótulos e texto | SectionHeader, FieldLabel, FieldMessage, Caption |
| Tokens | Cores, tipografia, espaçamento e raios, sombras |

## Estados representados

Os estados são aplicados de acordo com o comportamento de cada componente:

- **Padrão:** aparência de repouso;
- **Pressionado:** resposta visual durante o toque (sobreposição de 12%, ou fundo `primaryContainer`);
- **Foco:** campo ativo, com borda `primary` e anel de 3;
- **Preenchido:** campo que já tem conteúdo;
- **Selecionado / Não selecionado:** opção ativa em `primaryContainer`, com texto `primary`;
- **Desabilitado:** indisponível (opacidade de 60 a 70% ou fundo `track`);
- **Carregando:** spinner dentro do botão; esqueletos nas telas;
- **Erro:** borda `error` e mensagem abaixo do campo.

## Arquitetura

O projeto separa elementos compartilhados, componentes e telas de demonstração:

```text
lib/
├── app.dart
├── main.dart
├── common/
│   ├── ds.dart                 (exporta a base do Design System)
│   ├── models/                 (estados, tipo e status do item, dados de exemplo)
│   ├── theme/                  (cores, tema, tipografia, espaçamento, raios, sombras)
│   ├── utils/                  (formatação em português: 3.480, 7,8, 06 set)
│   └── widgets/                (seção de amostra, rótulo de estado, alternar tema)
├── components/
│   ├── action_button/          (widget + view model + factory)
│   ├── actions/                (IconButton, FAB)
│   ├── navigation/             (TopBar, BottomTabs, YearChip)
│   ├── inputs/                 (campos)
│   ├── selectors/              (segmentado, chips, estrelas, status)
│   ├── content/                (cards e conteúdo)
│   ├── feedback/               (spinner, esqueletos, estado de tela, diálogo, mensagem)
│   └── labels/                 (títulos de seção, rótulos, mensagens, legendas)
└── screens/
    ├── home/                   (tela inicial e definição das categorias)
    └── samples/                (uma galeria por categoria + telas de exemplo)
test/
```

### Camadas principais

- `common`: estados, tema, tokens e widgets compartilhados;
- `components`: implementação dos componentes reutilizáveis (nenhum lê uma cor direto: tudo passa por `context.colors`);
- `screens/home`: tela inicial e definição das categorias;
- `screens/samples`: apresentação dos componentes de cada categoria;
- `app.dart`: configuração global do aplicativo (temas claro e escuro);
- `main.dart`: ponto de entrada.

### ViewModel e Factory

O botão demonstra a separação sugerida na arquitetura inicial:

```text
action_button/
├── action_button.dart
├── action_button_factory.dart
└── action_button_view_model.dart
```

- O **ViewModel** reúne os dados e as regras de apresentação (rótulo, variante, estado, tamanho, ícone);
- A **Factory** oferece configurações prontas do componente;
- O **Widget** fica responsável pela renderização.

## Tokens

Os nomes são os mesmos das variáveis do Figma (coleção **Cor**, com os modos Claro e Escuro).

| Token | Claro | Escuro | Uso |
| --- | --- | --- | --- |
| `background` | `#F8F6F3` | `#16181D` | fundo das telas |
| `surface` | `#FFFFFF` | `#1F2228` | cartões, campos, abas |
| `border` | `#E3DFD8` | `#2C3038` | bordas e divisórias |
| `track` | `#ECE9E4` | `#2C3038` | trilhos e esqueletos |
| `onSurface` | `#1F2328` | `#ECEAE6` | texto principal |
| `onSurfaceMuted` | `#6B7075` | `#9AA0A6` | texto secundário |
| `primary` | `#0F6E8C` | `#7DB8D0` | botão, aba ativa, links |
| `primaryContainer` | `#DCEEF4` | `#1F3A47` | seleção e chips ativos |
| `error` | `#B5473E` | `#E0877E` | erro e perigo |

Cores de status (`want`, `progress`, `done`), de tipo (`book`, `series`, `movie`) e das estrelas (`starFilled`, `starEmpty`) completam a paleta. O fundo suave de chips e capas é a própria cor a 14% sobre `surface` (`AppColorPalette.soft`).

A nota é um inteiro de 1 a 10 mostrado como estrelas (nota ÷ 2, com meia estrela): 8 = 4 estrelas, 9 = 4,5 estrelas.

## Executar no GitHub Codespaces

O arquivo `.devcontainer/` instala o Flutter sozinho quando o Codespace é criado.

1. Crie um repositório, envie o conteúdo desta pasta e abra um Codespace nele;
2. Espere a criação terminar (a primeira vez demora alguns minutos, enquanto o Flutter é instalado);
3. No terminal:

```bash
flutter pub get
flutter run -d web-server --web-port=8000 --web-hostname=0.0.0.0
```

4. Abra a aba **Ports**, encontre a porta **8000** e clique no ícone de globo para abrir o catálogo.

Se o Flutter não estiver no `PATH` (Codespace criado antes do `.devcontainer`), rode `bash .devcontainer/setup.sh` e abra um terminal novo.

## Executar no FlutLab

1. Acesse [flutlab.io](https://flutlab.io) e entre na sua conta;
2. Escolha a opção de importar um projeto Flutter por arquivo `.zip`;
3. Envie o arquivo do projeto e aguarde a instalação das dependências;
4. Clique em **Run** para abrir o Web Preview.

O pacote tem `android/`, `ios/`, `web/` e `pubspec.yaml` na raiz, como o importador exige. O catálogo foi escrito para Flutter 3.19 ou superior e evita APIs muito recentes.

## Executar localmente

### Pré-requisitos

- Flutter 3.19 ou superior;
- Dart 3.3 ou superior;
- Android Studio, VS Code ou IntelliJ com suporte ao Flutter.

```bash
flutter pub get
flutter run -d chrome
```

## Qualidade do código

Análise estática:

```bash
flutter analyze
```

Testes:

```bash
flutter test
```

O que os testes cobrem:

- a tela inicial mostra as 8 categorias e abre uma delas;
- **todas as categorias renderizam inteiras, nos dois temas, numa tela de celular**, sem estourar o layout;
- formatação em português (milhar, vírgula decimal, datas) e o texto da nota ("9 de 10 · 4,5 estrelas");
- **contraste das cores (WCAG)** nos dois temas: o teste falha se uma troca de cor quebrar a acessibilidade;
- comportamento dos componentes: botão desabilitado e carregando, estrelas com meia estrela, controle segmentado, item da lista, resumo do ano.

## Decisões de projeto

- **Fonte:** a do sistema, como na Carteira. A Inter do Figma pode ser empacotada como asset, definindo `fontFamily` no tema.
- **Rótulo dos campos:** fica acima do campo, como no Figma (e não flutuando dentro da borda).
- **Ajustes de contraste:** cores de status no tema claro, ícones de livro e série no escuro e a estrela cheia no claro foram ajustados em relação ao primeiro protótipo, para atender o contraste mínimo.
- **Status do item:** `MediaStatus.inProgress` corresponde a `in_progress` no contrato da API.

## Tecnologias

- Flutter;
- Dart;
- Material 3;
- Figma;
- GitHub Codespaces.

## Próximas evoluções

- Extrair `common` e `components` para o pacote `bibliotela_design_system`, usado pelo app;
- Empacotar a fonte Inter;
- Gerar os tokens a partir de um arquivo exportado do Figma;
- Adicionar uma tela de documentação técnica para cada componente;
- Publicar uma demonstração Web.

## Autoria

Projeto acadêmico desenvolvido por **Maria Eduarda** como implementação prática de um Design System em Flutter.
