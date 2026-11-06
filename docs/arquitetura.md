# Arquitetura do app

O app segue o padrão do curso: cada tela é uma **cena** com cinco arquivos, e as dependências entram pelo construtor.

## Uma cena

```text
lib/scenes/login/
├── login_factory.dart       monta a cena e injeta as dependencias
├── login_coordinator.dart   para onde a cena manda a pessoa
├── login_view_model.dart    estado e acoes (ChangeNotifier)
├── server_login.dart        de onde vem o dado (interface + versao offline + versao real)
└── login_view.dart          so desenha; le o view model
```

```text
server      = ServerLoginImpl(auth)
coordinator = DefaultLoginCoordinator(navigation)
viewModel   = LoginViewModel(server, coordinator)   // injecao de dependencia
view        = LoginView(viewModel)                  // injecao de dependencia
LoginFactory.make()  ->  uma tela pronta, com visual e logica
```

| Peça | Faz | Não faz |
| --- | --- | --- |
| **View** | desenha o estado do view model e repassa os toques | decidir nada, chamar o servidor, navegar |
| **ViewModel** | guarda o estado, valida, chama o `Server*` e o coordinator | conhecer widgets ou `BuildContext` |
| **Server\*** | esconde de onde vem o dado (repositório do `core`) | ter estado de tela |
| **Coordinator** | navegar para a próxima cena | ter lógica de tela |
| **Factory** | criar as peças e ligar umas às outras | ser usada fora da montagem |

Cada `Server*` tem duas versões: `Default*` (offline, para desenvolver e testar) e `*Impl` (o servidor de verdade). Trocar uma pela outra não muda nenhuma tela.

## As camadas e quem pode importar quem

```text
apps/mobile  ->  packages/core            (dominio e dados)
             ->  packages/design_system   (visual)
packages/core            nao importa nada do app nem do Flutter (Dart puro)
packages/design_system   nao conhece o dominio: recebe MediaType, nao Item
```

O app faz a ponte entre os dois pacotes em `library_presenter.dart`: o `core` fala `Item` e `ItemType`, o design system fala `MediaType` e `MediaStatus`.

## Decisões

- **Result em vez de exceção.** Os repositórios devolvem `Future<Result<T>>` e nunca lançam. O view model decide o que mostrar com `Ok` e `Failure`.
- **`AppError` com mensagem em português.** O que a pessoa lê vem do erro (`error.message`), nunca de uma exceção crua.
- **`LocalDate` para as datas de leitura.** `startedAt` e `finishedAt` são só o dia (`YYYY-MM-DD`). Como `DateTime` em UTC, terminar um livro às 23h viraria o dia seguinte.
- **O que não vale é descartado.** Uma nota num item "quero ler" ou páginas num filme voltam `null`, como no servidor (`Item.normalized()`). O repositório em memória faz o mesmo.
- **O repositório em memória é igual ao servidor:** mesmos filtros, ordem e validação. Por isso os testes do `core` conferem os mesmos números que o servidor devolve (resumo de 2026: 9 livros, 3.024 páginas, média 8,5).
- **Sessão guardada no aparelho** por `SharedPreferencesSessionStorage`. O `core` só conhece a interface `SessionStorage`.

## Criar uma cena nova

1. Crie `lib/scenes/<nome>/` com os cinco arquivos acima.
2. No `*_view_model.dart`, receba `Server*` e o coordinator pelo construtor.
3. Se a cena navega para outra, acrescente o método na interface `AppNavigation` e implemente em `AppRouter`.
4. Escreva o teste do view model (com um `Server*` falso) e o da view (com o `Default*`).

## Testes

- `core`: modelos, filtros, repositórios em memória e remotos (com um servidor falso no lugar da rede).
- `design_system`: componentes, contraste das cores e formatação.
- `apps/mobile`: view models com `Server*` falsos e telas com os dados de exemplo.
- Nos testes de tela o texto é reduzido (`TextScaler.linear(0.6)`) porque a fonte padrão do `flutter test` é bem mais larga que a de um celular.
