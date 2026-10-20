# KUIDE

Protótipo Flutter offline para organizar medicamentos, saúde, rotina,
compromissos, compras, contatos e preferências. Todos os dados são de
demonstração e permanecem em memória enquanto o aplicativo está aberto.

## Executar

Pré-requisito: Flutter SDK compatível com Dart `^3.13.5` e um dispositivo ou
emulador configurado.

```bash
flutter pub get
flutter run
```

Para validação local:

```bash
dart format .
flutter analyze
flutter test
flutter test --update-goldens
flutter build apk --debug
```

Os dois testes golden são inicialmente ignorados até que o Flutter esteja
disponível para gerar suas imagens de referência.

## Rotas principais

| Rota | Finalidade |
| --- | --- |
| `/splash` | Entrada e transição local para Login |
| `/login`, `/register`, `/logout` | Autenticação simulada e sessão local |
| `/onboarding/*` | Medicamentos, médico/compromisso e ficha de emergência |
| `/home`, `/health`, `/routine`, `/profile` | Quatro abas principais |
| `/quick-access` | Grade completa de atalhos com busca |
| `/medications`, `/medications/add` | Medicamentos e formulário local |
| `/appointments`, `/appointments/add` | Compromissos e inclusão |
| `/shopping`, `/tasks`, `/contacts`, `/contacts/add` | Módulos de listas locais |
| `/emergency`, `/mock-call/:contactId` | Emergência e chamadas somente simuladas |

Em debug, `/catalog` abre o catálogo de componentes.

## Dados e limitações

- Login, Google, receitas, envio de histórico, WhatsApp, alertas e chamadas são
  representações visuais locais. Nenhuma rede, conta externa, telefone,
  notificação de sistema ou dado médico real é usado.
- SAMU 192 abre apenas uma tela de chamada simulada e deixa essa condição clara.
- Alterações não usam persistência permanente; reiniciar o app restaura os
  seeds mockados.
- A escala de texto e o volume de lembretes são preferências locais. O volume
  não produz áudio e a escala é aplicada via `MediaQuery`.
- Fontes e assets finais do Figma ainda não foram exportados. Veja
  [`docs/figma-mapping.md`](docs/figma-mapping.md).

## Arquitetura

O projeto usa Flutter, Riverpod, GoRouter, `intl` e `flutter_svg`. A estrutura
é orientada por feature: cada módulo separa domínio, estado e apresentação
quando necessário. Repositórios e providers mockados mantêm o estado em
memória para futura substituição por APIs, sem mudar a interface.

## Segurança e acessibilidade

O app evita ações externas e usa textos explícitos para os fluxos simulados.
Os componentes base fornecem áreas de toque confortáveis, labels semânticos
para ações por ícone e suportam aumento de fonte.
