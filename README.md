# Bibliotela

O diário pessoal de **livros, séries e filmes**: o que você quer ler ou assistir, o que está lendo ou assistindo e o que já terminou, com nota, gênero e um resumo do ano.

Projeto do curso de Formação Mobile em Dart / Flutter. Autora: Maria Eduarda ([@dudaswc](https://github.com/dudaswc)).

## Como o repositório está organizado

```text
Bibliotela/
├── server/                  servidor mock da API (Dart puro, sem pacotes)
├── packages/
│   ├── core/                dominio e dados: modelos, Result, repositorios, cliente da API
│   └── design_system/       tokens, tema claro e escuro e os componentes
├── apps/
│   ├── mobile/              o app Bibliotela (telas no padrao MVVM + Coordinator + Factory)
│   └── catalog/             catalogo interativo do Design System
└── docs/                    referencia da API, Design System e arquitetura
```

Cada pasta é um projeto com o seu `pubspec.yaml`. O app depende de `core` e de `design_system` por caminho (`path:`); o catálogo depende só do `design_system`.

## Rodar

O repositório tem um `.devcontainer`: num Codespace novo, o Flutter e as dependências se instalam sozinhos. Num terminal comum, use o Flutter 3.47 ou mais novo.

**1. O servidor mock** (terminal 1)

```bash
cd server
dart pub get
dart run bin/server.dart
```

Ele fica em `http://localhost:8080`. Confira em outro terminal com `curl http://localhost:8080/health`. No Codespaces, deixe a porta **8080** como **Pública** (aba Ports) para o app acessá-la pelo navegador.

**2. O app** (terminal 2)

```bash
cd apps/mobile
flutter pub get
flutter run -d web-server --web-port=8000 --web-hostname=0.0.0.0 \
  --dart-define=API_BASE_URL=http://localhost:8080
```

No Codespaces, troque o valor de `API_BASE_URL` pelo endereço público da porta 8080 (o da aba Ports). Para rodar **sem servidor**, com os mesmos 45 itens de exemplo em memória:

```bash
flutter run -d web-server --web-port=8000 --web-hostname=0.0.0.0 --dart-define=API_MODE=memory
```

Login de teste: `ana@bibliotela.dev` / `123456` (ou `bruno@bibliotela.dev`).

**3. O catálogo do Design System**

```bash
cd apps/catalog
flutter run -d web-server --web-port=8000 --web-hostname=0.0.0.0
```

## Testar

```bash
bash scripts/test_all.sh
```

Roda, nesta ordem: o servidor, o `core`, o `design_system`, o catálogo e o app. Cada projeto também roda sozinho com `dart test` (server e core) ou `flutter test` (os demais).

## Documentação

- [`docs/arquitetura.md`](docs/arquitetura.md): o padrão das telas e as regras entre as camadas.
- `docs/bibliotela-api-referencia.pdf`: o contrato da API, com respostas reais capturadas do servidor.
- O Design System: `docs/bibliotela-design-system.pdf` (e o arquivo do Figma).

## Situação

| Parte | Estado |
| --- | --- |
| Servidor mock | pronto, 47 testes |
| Design System | pronto (Figma, pacote e catálogo) |
| Core (dominio e dados) | pronto |
| Tela de login | pronta, com sessão guardada no aparelho |
| Tela da biblioteca | iniciada: resumo do ano, lista por mês, carregando, vazio e erro |
| Busca e filtros, detalhe, novo item, edição, perfil | próximos passos |
