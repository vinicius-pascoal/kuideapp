# Mapeamento Figma → Flutter — KUIDE

Fonte: arquivo Figma `Rh0ArNre5RTbbiXQ70SoZM` (página `0:1`).

Este documento é a fonte de rastreabilidade da Etapa 0. Assets usados pelo
aplicativo deverão ser arquivos locais sob `assets/`; URLs temporárias do
Figma não devem ser incluídas em Dart, no `pubspec.yaml` ou em runtime.

## Situação da auditoria

- Consulta estrutural realizada: `153:2` (Home). O frame é vertical, de
  aproximadamente `434 × 2344 px`, com a área principal de conteúdo até cerca
  de `2106 px`.
- A cota do Figma MCP Starter foi atingida em `2026-10-20` após essa consulta.
  Por isso, os contextos de `88:807` e `99:236` e os binários exportáveis não
  puderam ser obtidos nesta execução. Não foram gravadas URLs temporárias nem
  arquivos vazios como se fossem assets válidos.
- A estrutura `assets/images`, `assets/icons` e `assets/illustrations` já foi
  criada. Os arquivos `.gitkeep` não são assets do produto.

## Tokens iniciais

Os valores abaixo combinam a inspeção de `153:2` com o roadmap. São iniciais:
confirmar em cada frame antes de transformá-los nos tokens definitivos do app.

| Categoria | Valor observado | Uso/observação |
| --- | --- | --- |
| Vinho de ação | `#7A1624` | SOS, títulos, navegação inferior e contornos de cards |
| Vinho de texto | `#7A1A28` | Variante indicada no roadmap; validar diferença visual por tela |
| Fundo creme | `#EFEFC9` | Fundo principal visível na Home |
| Fundo claro alternativo | `#EAE7CD` | Referência do roadmap; ainda não confirmado nos frames pendentes |
| Texto escuro | `#2F1B1A` | Corpo e rótulos |
| Texto claro | `#F5EEDB` / branco | Conteúdo sobre o card vinho |
| Card translúcido | `rgba(122,22,36,0.20)` | Atalhos da Home |
| Borda de card | `rgba(122,22,36,0.50)` | Atalhos da Home |
| Sombra | `3, 4, 4, rgba(0,0,0,0.25)` | Cards de atalho |
| Raio de card | `15 px` | Atalhos da Home |
| Tipografia | Source Serif Pro, Inter, Nunito | Home: títulos Source Serif Pro; dados/ações Inter; links auxiliares Nunito |
| Escala tipográfica observada | 10, 12, 13, 14, 16, 20, 36 px | Converter para `sp` e revisar com acessibilidade |

## Reutilização de assets e componentes

| Recurso | Evidência | Decisão |
| --- | --- | --- |
| Ícone de fundo circular dos atalhos | Repetido em seis atalhos da Home | Um único asset local reutilizável; não exportar seis cópias |
| Seta “ver todos” | Repetida em Acesso rápido e Próximos compromissos | Um único ícone `chevron_right.svg` (a exportar) |
| Ícone de medicamento no card e no atalho | Variantes visualmente relacionadas | Comparar SVGs antes de consolidar; não assumir igualdade |
| SOS | Camada nomeada `BOTÃO SOS` na Home | Exportar como `sos_button.svg`, se vetorial |
| Navegação inferior | Repetida entre rotas de primeiro nível | Implementar como widget; exportar cada ícone uma vez |

## Inventário de telas

| ID Figma | Área / frame | Destino Flutter | Tipo | Assets locais | Estado |
| --- | --- | --- | --- | --- | --- |
| `25:57` | Splash/logo | `SplashScreen` | rota | logo pendente | pendente de contexto/exportação |
| `88:807` | Login | `LoginScreen` | rota | logo/ilustrações pendentes | pendente: cota Figma |
| `77:4` | Entrar com Google (e-mail) | diálogo/estado de login Google | overlay | ícone Google pendente | pendente de contexto/exportação |
| `79:125` | Entrar com Google (senha) | diálogo/estado de login Google | overlay | ícone Google pendente | pendente de contexto/exportação |
| `153:246` | Criar conta | `RegisterScreen` | rota | pendentes | inventariado; contexto pendente |
| `153:334` | Onboarding: remédios | `OnboardingMedicinesScreen` | rota | pendentes | inventariado; contexto pendente |
| `153:383` | Onboarding: médicos | `OnboardingDoctorsScreen` | rota | pendentes | inventariado; contexto pendente |
| `153:424` | Onboarding: emergência | `OnboardingEmergencyScreen` | rota | pendentes | inventariado; contexto pendente |
| `153:2` | Home / SCROLL — backup original | `HomeScreen` | rota, conteúdo rolável | SOS, ícones de atalhos, setas, ícones de cards e nav pendentes | contexto inspecionado; exportação bloqueada |
| `99:236` | Acesso rápido | `QuickAccessScreen` | rota | ícones de atalhos pendentes | pendente: cota Figma |
| `103:227` | Saúde | `HealthHistoryScreen` | rota | ícones/gráficos pendentes | inventariado; contexto pendente |
| `168:279` | Medicamentos | `MedicationsScreen` | rota | ícones/receita pendentes | inventariado; contexto pendente |
| `200:483` | Adicionar medicamento | `AddMedicationScreen` | rota | ícones de formulário pendentes | inventariado; contexto pendente |
| `98:133` | Rotina completa | `RoutineScreen` | rota | ícones/calendário pendentes | inventariado; contexto pendente |
| `103:85` | Tarefas | `TasksScreen` | rota | ícones pendentes | inventariado; contexto pendente |
| `103:296` | Compromissos | `AppointmentsScreen` | rota | ícones pendentes | inventariado; contexto pendente |
| `163:239` | Próximo compromisso | `AddAppointmentScreen` ou modal | rota/overlay a confirmar | ícones pendentes | inventariado; contexto pendente |
| `103:370` | Compras | `ShoppingListScreen` | rota | ícones pendentes | inventariado; contexto pendente |
| `103:449` | Pessoas | `ContactsScreen` | rota | fotos/avatares e ícones pendentes | inventariado; contexto pendente |
| `116:663` | Pessoas.add | `AddContactSheet` | bottom sheet | ícones pendentes | inventariado; contexto pendente |
| `123:9` | Pessoas.add.pk | feedback de sucesso | overlay/estado | ilustração/ícone pendente | inventariado; contexto pendente |
| `123:409` | PESSOASTELA1 | `ContactsScreen` | variante de estado | reutiliza fotos/ícones de contatos | variante; não criar rota sem evidência |
| `124:2` | PESSOASTELA2 | `ContactsScreen` | variante de estado | reutiliza fotos/ícones de contatos | variante; não criar rota sem evidência |
| `124:314` | Ligar ANA | `MockCallScreen(contactId: ana)` | rota parametrizada | foto/ícones de chamada pendentes | variante de chamada |
| `124:370` | Ligar JOÃO | `MockCallScreen(contactId: joao)` | rota parametrizada | foto/ícones de chamada pendentes | variante de chamada |
| `124:464` | Ligar MARCELO | `MockCallScreen(contactId: marcelo)` | rota parametrizada | foto/ícones de chamada pendentes | variante de chamada |
| `124:515` | Ligar MARCELO / SAMU | `MockCallScreen(contactId: samu)` | rota parametrizada | ícones de chamada pendentes | variante de chamada; nunca chamada real |
| `97:7` | Central de emergência | `EmergencyScreen` | rota | ícones/ficha pendentes | inventariado; contexto pendente |
| `153:467` | Perfil | `ProfileScreen` | rota | avatar/ícones pendentes | inventariado; contexto pendente |

## Home `153:2`: medidas e estrutura observadas

- Largura de referência: `434 px`; usar como referência visual, não como
  largura fixa em Flutter.
- Cabeçalho: “BOM DIA” em 20 px (Nunito SemiBold), nome em 36 px (Source Serif
  Pro Bold) e botão SOS de aproximadamente `80 × 80 px`.
- Card de compromissos: aproximadamente `381 × 256 px`, iniciado a 25 px da
  margem esquerda; contém medicamento, consulta e CTA de rotina.
- Grade de acesso rápido: cards de `120 × 110 px`, raio 15 px, três colunas,
  com os primeiros cartões iniciando aproximadamente em x=30, 157 e 284.
- Os seis destinos são Medicamentos, Compromissos, Saúde, Compras, Tarefas e
  Contatos. O grid completo e a seção “Ainda falta hoje” continuam abaixo da
  primeira dobra.
- Há múltiplas camadas de fundo `Tela principal` e alvos de protótipo. Eles são
  composição do frame, não assets nem novas rotas.

## Itens para retomar após liberar a cota Figma

1. Consultar `88:807` e `99:236` com `get_design_context` e pedir screenshot.
2. Baixar os assets de cada um dos três frames com `download_assets` e gravá-los
   imediatamente em `assets/` com extensão correta e nomes semânticos.
3. Consultar os demais frames do inventário e preencher cada linha acima com
   medidas/tokens confirmados e lista final de assets.
4. Comparar hashes/conteúdo dos SVGs para consolidar ícones repetidos.
5. Declarar somente os arquivos reais no `pubspec.yaml` quando a implementação
   começar; manter a proibição de URLs Figma em runtime.

## Divergências e decisões abertas

- O arquivo mistura Inter, Source Serif Pro, Nunito e, segundo o roadmap,
  Inria Serif. A escolha por contexto deve ser confirmada frame a frame; não
  adotar uma fonte única globalmente.
- Os frames de login Google, confirmação de contato e chamadas são estados,
  overlays ou variantes conforme indicado acima, não rotas independentes por
  padrão.
- Nenhuma imagem, foto, logotipo ou SVG foi inferido/recriado enquanto a
  exportação está indisponível. Isso preserva a fidelidade e as permissões de
  uso para a retomada.
