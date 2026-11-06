# Bibliotela · servidor mock

Servidor mock da API da Bibliotela (livros, séries e filmes). Cumpre o contrato do PDF **"Referência da API · Bibliotela"**: 13 rotas, JSON, token `Bearer`, dados próprios por sessão, latência simulada e os cabeçalhos `X-Delay-Ms` e `X-Fail`.

Usa **só as bibliotecas do próprio Dart** (`dart:io`, `dart:convert`), sem pacotes. O único pacote é o `test`, para os testes.

## Rodar

```bash
cd server
dart pub get
dart run bin/server.dart
```

O terminal fica preso mostrando `Listening on http://localhost:8080`. Deixe-o aberto: é o servidor. Para conferir, em **outro terminal**:

```bash
curl http://localhost:8080/health
```

Resposta esperada: `{"status":"ok","version":"0.1.0"}`.

No GitHub Codespaces, abra a aba **Ports**, encontre a porta **8080** e mude a visibilidade para **Public** (a cada reinício do Codespace) se o app for acessar o servidor pelo navegador.

### Variáveis de ambiente (opcionais)

| Variável | Padrão | Efeito |
| --- | --- | --- |
| `PORT` | `8080` | porta de escuta |
| `LATENCY_MIN_MS` | `300` | latência mínima por requisição |
| `LATENCY_MAX_MS` | `800` | latência máxima por requisição |

Exemplo, sem latência: `LATENCY_MIN_MS=0 LATENCY_MAX_MS=0 dart run bin/server.dart`.

## Testar

```bash
dart test
```

Os testes sobem o servidor numa porta livre e fazem requisições de verdade. Cobrem as 13 rotas, a validação, os filtros, a paginação, o resumo, o isolamento entre sessões, o CORS e os cabeçalhos de simulação.

## Credenciais de teste

| E-mail | Senha | Itens no seed |
| --- | --- | --- |
| `ana@bibliotela.dev` | `123456` | 45 |
| `bruno@bibliotela.dev` | `123456` | 15 |

Cada login recebe **uma cópia própria** do seed. O que uma sessão altera, outra não vê, e `POST /reset` devolve a sessão ao estado inicial.

## Rotas

| Verbo | Rota | Autenticação | Sucesso |
| --- | --- | --- | --- |
| GET | `/health` | não | 200 |
| POST | `/auth/login` | não | 200 |
| POST | `/auth/logout` | sim | 204 |
| GET | `/me` | sim | 200 |
| PUT | `/me` | sim | 200 |
| GET | `/genres` | sim | 200 |
| GET | `/items` | sim | 200 |
| GET | `/items/:id` | sim | 200 |
| POST | `/items` | sim | 201 |
| PUT | `/items/:id` | sim | 200 |
| DELETE | `/items/:id` | sim | 204 |
| GET | `/summary` | sim | 200 |
| POST | `/reset` | sim | 204 |

### Exemplos

```bash
# login: guarda o token
TOKEN=$(curl -s -X POST localhost:8080/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"ana@bibliotela.dev","password":"123456"}' | sed 's/.*"token":"\([^"]*\)".*/\1/')

# lista (filtros: year, status, type, genre, q, page, pageSize)
curl -s -H "Authorization: Bearer $TOKEN" 'localhost:8080/items?year=2026&status=done&type=book&pageSize=5'

# resumo do ano
curl -s -H "Authorization: Bearer $TOKEN" 'localhost:8080/summary?year=2026'

# cria um item
curl -s -X POST localhost:8080/items -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d '{"type":"book","title":"Duna","genre":"Ficção científica","status":"done","startedAt":"2026-08-12","finishedAt":"2026-09-06","rating":9,"pages":680,"author":"Frank Herbert"}'
```

### Simular lentidão e falhas

Valem em qualquer rota e são avaliados **antes** da autenticação.

```bash
curl -H 'X-Delay-Ms: 3000' localhost:8080/health      # exatamente 3 s de latência
curl -H 'X-Fail: 500' localhost:8080/health           # 500 internal
curl -H 'X-Fail: expired' localhost:8080/health       # 401 token_expired
curl -H 'X-Fail: timeout' localhost:8080/health       # segura 60 s e responde 504 em texto
```

## Regras que o servidor aplica

- **Datas de leitura** (`startedAt`, `finishedAt`) são só a data, `YYYY-MM-DD`, sem hora nem fuso. `addedAt` é ISO 8601 em UTC, gerado pelo servidor.
- **Nota:** inteiro de 1 a 10, só com status `done`.
- **Regras por status:** `want` não tem datas nem nota; `in_progress` exige `startedAt`; `done` exige `finishedAt` (`startedAt` e nota são opcionais). `startedAt` não pode ser depois de `finishedAt`.
- **O que não vale é descartado:** nota num item `want`, `pages` num filme etc. voltam `null` na resposta. Faltar o que é obrigatório, ou mandar valor inválido para um campo que vale, dá **422** com um `fields` por campo.
- **Texto vazio vira `null`** (`genre`, `note`, `author`, `avatarUrl`), e `title` perde os espaços das pontas.
- **Listagem:** primeiro os itens com data de leitura (do mais recente ao mais antigo; empate pelo `addedAt` mais novo) e depois os `want`. O filtro `year` mantém os `want`, que não têm data de leitura.
- **Resumo:** só entram itens `done` com `finishedAt` no ano. `byGenre` vai do maior para o menor; **em empate**, "sem gênero" (`null`) vem primeiro e depois a ordem alfabética (o contrato não define o desempate).
- **Rota inexistente:** com token válido, 404; sem token, 401.

## Estrutura

```text
server/
├── bin/server.dart          ponto de entrada (porta, latência)
├── lib/
│   ├── bibliotela_server.dart
│   └── src/
│       ├── config.dart      variáveis de ambiente
│       ├── errors.dart      ApiException e o formato único de erro
│       ├── genres.dart      gêneros, tipos e status aceitos
│       ├── models.dart      User e Item
│       ├── validation.dart  validação e normalização de item e perfil
│       ├── query.dart       filtros, ordenação e paginação de GET /items
│       ├── summary.dart     resumo do ano
│       ├── seed.dart        usuários e itens de exemplo
│       ├── session.dart     sessões: um seed por login
│       └── server.dart      roteamento, autenticação, simulação, CORS
└── test/server_test.dart
```
