# ROADMAP — KUIDE Flutter (protótipo com dados mockados)

> **Fonte visual:** [Figma ME-I / KUIDE](https://www.figma.com/design/Rh0ArNre5RTbbiXQ70SoZM/ME-I?node-id=0-1)  
> **Arquivo Figma:** `Rh0ArNre5RTbbiXQ70SoZM` — página `0:1`  
> **Objetivo:** transformar as interfaces do Figma em um aplicativo Flutter **navegável e funcional com dados locais simulados**, preservando o visual, os fluxos e a acessibilidade, sem backend ou autenticação reais.  
> **Status inicial:** planejamento concluído; desenvolvimento não iniciado neste documento.

---

## 1. Escopo e princípios de implementação

1. Usar **Flutter/Dart**, com prioridade para Android e iOS. Preservar o layout em telas de larguras diferentes, sem reproduzir os frames de 434 × 885,5 px como imagens estáticas ou posicionamentos absolutos rígidos.
2. Implementar os componentes reais de Flutter: textos selecionáveis quando apropriado, campos editáveis, listas, rolagem, abas, cartões, diálogos, validações e navegação.
3. **Não desenvolver** backend, banco de dados remoto, Firebase, endpoints HTTP, OAuth real, telefonia real ou agendamento de notificações do sistema nesta versão. Os fluxos que dependem dessas integrações devem ter alternativas locais **claramente simuladas**.
4. Usar modelos tipados, repositórios mockados assíncronos e estado reativo. Separar telas da origem dos dados para permitir substituição futura por API sem redesenhar as telas.
5. Manter fidelidade ao Figma em cores, fontes, hierarquia, ícones e assets. Não usar screenshots inteiros como background para falsificar a interface. Exportar e armazenar os **assets individuais** necessários no projeto, quando disponíveis.
6. Proteger a experiência de usuário: botões grandes, contraste adequado, textos escaláveis, textos sem truncamento, fluxos simples. O público retratado pelo design inclui pessoas idosas e familiares/cuidadores.
7. Priorizar o que está efetivamente desenhado. Onde não existir tela de uma ação, implementar um diálogo/sheet mínimo e coerente com os componentes existentes, documentando a adaptação.

### 1.1. O que significa “funcional com mocks”

- Login, cadastro, onboarding, adição e alteração de registros **mudam o estado local da aplicação**.
- Pesquisa, filtros, abas, marcação de tarefas e medicamentos funcionam com dados locais.
- Alterações refletem imediatamente nas telas relacionadas (ex.: medicamento incluído aparece em medicamentos e na rotina).
- Chamadas, botão do SAMU, envio de lista por WhatsApp, envio de histórico e login com Google usam uma **simulação visual**, sem realizar operação externa.
- Opcionalmente persistir mudanças de protótipo no dispositivo, com um botão para restaurar o conjunto de dados iniciais.

---

## 2. Inventário de telas do Figma

IDs fornecidos para solicitar contexto visual detalhado dos respectivos frames. Cada ID abaixo é um alvo verificável do design. Os IDs de frames duplicados representam estados/modalidades do fluxo, não necessariamente novas rotas.

| Área | Frame identificado | Node ID | Implementação pretendida |
|---|---|---|---|
| Entrada | Tela 1 (splash/logo) | `25:57` | SplashScreen |
| Entrada | tela 2 | `88:807` | LoginScreen |
| Entrada | Entrar com google (email) | `77:4` | Modal/estado de login Google simulado |
| Entrada | Entrar com google (senha) | `79:125` | Modal/estado de login Google simulado |
| Entrada | CRIAR CONTA | `153:246` | RegisterScreen |
| Onboarding | tela remedios (passo 1/3) | `153:334` | OnboardingMedicinesScreen |
| Onboarding | Tela medicos (passo 2/3) | `153:383` | OnboardingDoctorsScreen |
| Onboarding | Frame (passo 3/3) | `153:424` | OnboardingEmergencyScreen |
| Início | SCROLL — backup original | `153:2` | HomeScreen — **design completo da home** |
| Início | Acesso rápido | `99:236` | QuickAccessScreen |
| Saúde | saúde | `103:227` | HealthHistoryScreen |
| Saúde | medicamentos | `168:279` | MedicationsScreen |
| Saúde | MEDICAMENTOS.ADD | `200:483` | AddMedicationScreen |
| Rotina | Rotina completa | `98:133` | RoutineScreen |
| Rotina | Tarefas | `103:85` | TasksScreen |
| Compromissos | compromissos | `103:296` | AppointmentsScreen |
| Compromissos | pxmcompromisso | `163:239` | AddAppointmentScreen ou modal |
| Compras | COMPRAS | `103:370` | ShoppingListScreen |
| Contatos | PESSOAS | `103:449` | ContactsScreen |
| Contatos | PESSOAS.add | `116:663` | AddContactSheet |
| Contatos | PESSOAS.add.pk | `123:9` | Estado de sucesso ao incluir contato |
| Contatos | PESSOASTELA1 | `123:409` | Variação de ContactsScreen |
| Contatos | PESSOAStela2 | `124:2` | Variação de ContactsScreen |
| Contatos | LigarANA | `124:314` | MockCallScreen com Ana |
| Contatos | LigarJOAO | `124:370` | MockCallScreen com João |
| Contatos | LigarMARCELO | `124:464` | MockCallScreen com médico |
| Emergência | LigarMARCELO (conteúdo SAMU) | `124:515` | MockCallScreen com SAMU 192 |
| Emergência | Central de emergência | `97:7` | EmergencyScreen |
| Perfil | PERFIL | `153:467` | ProfileScreen |

**Observação:** o arquivo também possui frames auxiliares (`image`), menus duplicados, grupos e outros elementos de composição que não são rotas. Não criar páginas para esses elementos sem necessidade. O nome `SCROLL — backup original` se refere ao frame que contém o visual da home identificado durante a análise, devendo ser inspecionado cuidadosamente antes de começar a codificação.

### 2.1. Elementos específicos confirmados na home

- Saudação e nome de **Maria Santos**.
- Botão circular **SOS**.
- Card de compromissos e medicamento, incluindo **Losartana 50mg** e consulta com cardiologista.
- Acesso à rotina completa.
- Grade de atalhos: Medicamentos, Compromissos, Saúde, Compras, Tarefas, Contatos.
- Seção “Ainda falta hoje” e outros blocos abaixo da primeira dobra.
- Navegação inferior: **HOME, SAÚDE, ROTINA, PERFIL**.

### 2.2. Elementos confirmados nos módulos

- **Histórico de saúde:** abas Pressão / Glicemia / Peso, registro atual, histórico anterior e opção de enviar histórico ao médico.
- **Medicamentos:** horários, situação “Tomado” / “Tomar”, aviso de estoque baixo, receita médica e formulário de novo medicamento com dosagem, período, recorrência e estoque.
- **Tarefas:** abas Pendentes / Concluídas, agrupamento por períodos do dia e inclusão de tarefas.
- **Compras:** itens pendentes / no carrinho, quantidade, inserção de item e ação para compartilhar lista pelo WhatsApp.
- **Compromissos:** filtros Todos / Consultas / Exames e formulário de agendamento com data, horário, local, profissional e antecedência de aviso.
- **Pessoas importantes:** busca, filtros Todos / Família / Médicos, cadastro de contato, estado de sucesso e tela visual de chamada.
- **Emergência:** atalho para SAMU 192, contatos prioritários e ficha de saúde de emergência.
- **Perfil:** dados de Maria Santos, ficha de saúde, plano, tamanho de letra, volume de lembretes, cuidador vinculado, ajuda e saída.

---

## 3. Design system

### 3.1. Referências visuais iniciais

As seguintes referências foram constatadas em telas inspecionadas. **Não assumir que esgotam os tokens do arquivo**; confirmar no contexto individual de cada frame.

| Token proposto | Valor observado / orientação |
|---|---|
| Cor vinho principal | `#7A1624` — navegação inferior e ações de destaque |
| Cor vinho de texto | `#7A1A28` — títulos e destaques |
| Fundo claro | `#EAE7CD` e variantes creme, dependendo da tela |
| Creme secundário | `#EFEFC9` — textos claros e superfícies específicas |
| Texto escuro | `#2F1B1A` |
| Cartões | vinho translúcido sobre fundo claro, borda vinho translúcida e sombra discreta |
| Arredondamento | elevado em botões, cards, barras de busca e navegação inferior |
| Fontes observadas | **Inter**, **Source Serif Pro**, **Nunito** e **Inria Serif**, em contextos diferentes |
| Navegação inferior | barra vinho, quatro destinos e ícones brancos |

Em vez de aplicar uma única fonte universal, verificar os textos reais de cada seção. Cabeçalhos de algumas páginas usam Source Serif Pro; páginas com listas/formulários usam Inter; telas de autenticação incluem Nunito e outras fontes.

### 3.2. Tokens Flutter

Criar `AppColors`, `AppTypography`, `AppSpacing`, `AppRadii`, `AppShadows`, `AppTheme` e `AppIconography`, com os valores centralizados. Não espalhar hexadecimais e dimensões pelo código de cada tela.

### 3.3. Componentes reutilizáveis

- `KuideScaffold`: SafeArea, conteúdo rolável, slots para cabeçalho e bottom navigation.
- `AppBottomNavBar`: quatro abas, estado ativo e navegação persistente.
- `AppHeader`: botão voltar, título, ícone opcional.
- `PrimaryButton`, `SecondaryButton`, `DangerButton`, `IconActionButton`.
- `AppTextField`, `AppPasswordField`, `AppSearchField`, `AppDropdown`, `AppDateField`, `AppTimeField`.
- `AppCard`, `QuickAccessCard`, `SectionHeader`, `FilterTabBar`, `StatusChip`.
- `MedicationTile`, `TaskTile`, `AppointmentCard`, `ShoppingItemTile`, `ContactTile`, `HealthMeasurementCard`.
- `MockActionDialog`, `EmptyStateView`, `LoadingStateView`, `ErrorStateView`, `SuccessFeedback`.

Critério transversal: os componentes devem aceitar parâmetros/dados, ter callbacks reais e permitir teste isolado com `WidgetTester`.

---

## 4. Arquitetura sugerida

Usar organização **feature-first**, dividindo dados/modelos, regras e UI. Para protótipo, não aumentar a complexidade sem justificativa.

```text
kuide_flutter/
├── pubspec.yaml
├── README.md
├── ROADMAP.md
├── assets/
│   ├── images/
│   ├── icons/
│   └── illustrations/
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── app.dart
│   │   ├── router/app_router.dart
│   │   └── theme/
│   │       ├── app_theme.dart
│   │       ├── app_colors.dart
│   │       ├── app_typography.dart
│   │       └── app_spacing.dart
│   ├── core/
│   │   ├── mocks/mock_seed.dart
│   │   ├── mocks/mock_delay.dart
│   │   ├── storage/local_storage.dart
│   │   ├── utils/date_formatters.dart
│   │   └── constants/
│   ├── shared/
│   │   └── widgets/
│   │       ├── app_bottom_nav_bar.dart
│   │       ├── app_header.dart
│   │       ├── app_card.dart
│   │       └── app_buttons.dart
│   └── features/
│       ├── auth/
│       ├── onboarding/
│       ├── home/
│       ├── health/
│       ├── medications/
│       ├── routine/
│       ├── tasks/
│       ├── appointments/
│       ├── shopping/
│       ├── contacts/
│       ├── emergency/
│       └── profile/
└── test/
    ├── unit/
    ├── widget/
    └── golden/
```

Em cada feature usar, quando fizer sentido:

```text
features/medications/
├── data/
│   ├── medication_mock_repository.dart
│   └── medication_seed.dart
├── domain/
│   ├── medication.dart
│   └── medication_repository.dart
└── presentation/
    ├── providers/medications_provider.dart
    ├── screens/medications_screen.dart
    ├── screens/add_medication_screen.dart
    └── widgets/medication_tile.dart
```

### Dependências recomendadas

- `flutter_riverpod` — estado reativo e injeção de dependências.
- `go_router` — rotas, redirecionamentos de autenticação simulada e `StatefulShellRoute` para a barra inferior.
- `flutter_svg` — exibição de ícones SVG individuais exportados do Figma.
- `google_fonts` **ou** fontes locais licenciadas e corretamente declaradas — tipografia identificada no design.
- `intl` — datas, horas e formatação `pt_BR`.
- `shared_preferences` — **somente se** for desejável guardar alterações mockadas após reiniciar o app. Caso contrário, repositórios in-memory são suficientes.

Não adicionar Dio, Firebase, Google Sign-In, serviços de telefonia, banco de dados ou bibliotecas de notificações sem necessidade real.

---

## 5. Modelos e dados mockados

### 5.1. Entidades tipadas

- `AppUser`: id, nome, email, idade, foto, informações de acessibilidade, id do cuidador.
- `HealthProfile`: tipo sanguíneo, alergias, condições de saúde, plano, observações.
- `HealthMeasurement`: id, tipo (`pressure`, `glucose`, `weight`), valores e unidades, data/hora.
- `Medication`: id, nome, dosagem, forma, frequência, períodos, horários, estoque, alerta de estoque, ativo.
- `MedicationIntake`: id, medicamentoId, data/hora prevista, data/hora efetiva, status.
- `Task`: id, título, categoria, descrição, horário/período, data, concluída.
- `Appointment`: id, tipo, título, local, profissional opcional, data/hora, lembrete configurado.
- `ShoppingItem`: id, nome, quantidade, noCarrinho, posição.
- `Contact`: id, nome, relação, categoria, telefone, foto ou iniciais, destaque no início.
- `AuthSession` e `OnboardingProgress`: sessão fictícia e conclusão das etapas.
- `AccessibilityPreferences`: escala de texto e intensidade de avisos na interface simulada.

### 5.2. Seeds sugeridas, alinhadas às telas

| Entidade | Exemplos para seed |
|---|---|
| Perfil | Maria Santos, 72 anos; dados de demonstração |
| Medicamentos | Losartana 50 mg (manhã) e Atorvastatina 20 mg (noite) |
| Saúde | Pressão 120/80 mmHg e registros históricos 122/82, 118/79, 125/85, conforme frame |
| Tarefas | Comprar frutas; Regar as plantas; Tomar Losartana; Medir pressão; Conferir trancas |
| Compras | Leite desnatado, frutas, arroz integral, pão de fôrma, ovos, café, açúcar |
| Contatos | Ana (filha), João (filho), Dr. Marcelo e Maria Enfermeira |
| Compromissos | Consulta com cardiologista, exame de sangue, oftalmologista, ultrassonografia |
| Emergência | Contatos prioritários, tipo sanguíneo O+, alergia à penicilina, hipertensão |

**Importante:** o design contém datas pontuais e antigas em alguns exemplos. Para testes de fidelidade visual, criar uma configuração de **data de referência fixa**. Para uso cotidiano, permitir que a visualização “hoje” se baseie na data local. As informações clínicas são **apenas dados de demonstração**, não recomendações médicas nem prontuário real.

### 5.3. Contrato dos repositórios

```dart
abstract interface class MedicationRepository {
  Future<List<Medication>> findAll();
  Future<Medication> add(Medication medication);
  Future<void> update(Medication medication);
  Future<void> markTaken(String medicationId, DateTime date);
}
```

Usar interfaces equivalentes para tarefas, contatos, compras, compromissos, medições e perfil. As implementações `Mock*Repository` mantêm coleções locais e podem simular latência breve para estados de carregamento. Não exibir sucesso sem atualizar a fonte de estado.

---

## 6. Navegação e fluxo funcional

```text
Splash
 └─ Login
    ├─ Entrar (mock)
    │   └─ Home
    ├─ Google (mock de escolha/continuação de conta)
    │   └─ Home
    └─ Criar conta
        └─ Onboarding 1: medicamentos
            └─ Onboarding 2: médicos e consultas
                └─ Onboarding 3: emergência
                    └─ Home

AppShell (bottom navigation)
 ├─ Home
 │   ├─ SOS → Central de emergência → chamada simulada
 │   ├─ Acesso rápido → grade completa
 │   ├─ Medicamentos → adicionar / marcar como tomado
 │   ├─ Compromissos → adicionar
 │   ├─ Tarefas → adicionar / concluir
 │   ├─ Compras → adicionar / marcar no carrinho
 │   └─ Contatos → pesquisar / adicionar / chamada simulada
 ├─ Saúde → histórico / abas / registro
 ├─ Rotina → calendário e atividades do dia
 └─ Perfil → dados, preferências, ajuda, sair
```

Rotas sugeridas: `/splash`, `/login`, `/register`, `/onboarding/medications`, `/onboarding/doctors`, `/onboarding/emergency`, `/home`, `/quick-access`, `/health`, `/health/new`, `/medications`, `/medications/add`, `/routine`, `/tasks`, `/appointments`, `/appointments/add`, `/shopping`, `/contacts`, `/contacts/add`, `/emergency`, `/mock-call/:contactId`, `/profile`.

Manter selecionada a aba inferior de origem nas subrotas, conforme a organização visual do protótipo. Confirmar o comportamento dos links da home com as conexões do protótipo no Figma, quando existirem. Navegação de voltar deve respeitar a pilha e não duplicar páginas.

---

## 7. Etapas de execução para Codex

> **Regra de execução:** concluir e validar uma etapa antes de iniciar a seguinte. Ao fim de cada etapa, executar os comandos de análise/teste possíveis no ambiente, listar os arquivos modificados, registrar divergências com o Figma e **não** deixar controles sem ação silenciosamente.

### Etapa 0 — Auditoria e extração dos assets

**Objetivo:** preparar fontes de verdade para implementar as telas, sem depender de prints achatados.

- [ ] Acessar o arquivo Figma e inspecionar as telas do inventário acima.
- [ ] Usar os IDs de frame para obter layout, tokens e assets dos nós visíveis, especialmente Home `153:2`, Login `88:807` e Acesso rápido `99:236`.
- [ ] Exportar imagens, logotipo, fotos e SVGs individuais usados no design. Armazená-los em `assets/` por tipo com nomes semânticos.
- [ ] Verificar se um mesmo ícone aparece em múltiplos lugares para reutilizar o mesmo arquivo.
- [ ] Criar um arquivo `docs/figma-mapping.md`: ID Figma → tela/widget Flutter → assets → status.
- [ ] Registrar referências de tipografia e medidas; revisar inconsistências entre telas.
- [ ] Documentar elementos que são variantes/sobreposições versus rotas inteiras.

**Aceite:** mapa de telas rastreável, assets individuais locais e tokens iniciais descritos. **Não** usar URLs temporárias do Figma em runtime.

### Etapa 1 — Inicialização do projeto e arquitetura

- [ ] Criar projeto Flutter com nome/package apropriado, suporte Android/iOS e configuração de análise estática.
- [ ] Configurar as dependências recomendadas no `pubspec.yaml`.
- [ ] Criar `AppTheme`, tokens visuais e componentes base.
- [ ] Implementar `MaterialApp.router` e `GoRouter` com shell para as 4 abas.
- [ ] Criar contratos dos repositórios e providers do Riverpod.
- [ ] Criar states padrão: loading, empty, error e success.
- [ ] Configurar locale `pt_BR`, tratamento de teclado e SafeArea.

**Aceite:** `flutter analyze` e `flutter test` sem erros; navegação básica e shell funcional; configuração de tema centralizada.

### Etapa 2 — Componentes e fidelity baseline

- [ ] Criar botões, cartões, busca, campos, cabeçalhos, abas, listas, dialogs e bottom navigation reutilizáveis.
- [ ] Implementar variante da barra inferior do Figma com HOME / SAÚDE / ROTINA / PERFIL.
- [ ] Implementar estados pressed, disabled, selected, loading e foco.
- [ ] Criar uma tela de catálogo de widgets apenas para desenvolvimento, removível na distribuição final.
- [ ] Criar pelo menos um teste golden de card e outro da barra de navegação.

**Aceite:** componentes isolados reproduzem espaçamentos, cores, bordas e tipografia do design.

### Etapa 3 — Splash, login e cadastro

**Frames:** `25:57`, `88:807`, `77:4`, `79:125`, `153:246`.

- [ ] Implementar splash e transição para login.
- [ ] Criar campos de e-mail e senha, visibilidade da senha e validações locais.
- [ ] `Entrar` cria sessão mock e navega para home sem autenticar de verdade.
- [ ] Botão Google abre uma experiência mock explícita e segue para home; não solicitar permissões de conta.
- [ ] Implementar cadastro completo, confirmação de senha e aceite de termos fictícios.
- [ ] Login e cadastro exibem erros plausíveis e mensagens acessíveis.
- [ ] Criar rota de logout que limpa a sessão mock.

**Aceite:** todo o fluxo de entrada é navegável, com validações, sem rede e sem dados reais.

### Etapa 4 — Onboarding de três passos

**Frames:** `153:334`, `153:383`, `153:424`.

- [ ] Passo 1: adicionar/remover medicamentos contínuos e horários; permitir “Preencher depois”.
- [ ] Passo 2: médico principal e compromisso; permitir “Preencher depois”.
- [ ] Passo 3: tipo sanguíneo, alergias e contato familiar principal; concluir.
- [ ] Exibir progresso 1/3, 2/3, 3/3, navegação anterior e preservação dos dados ao avançar/voltar.
- [ ] Persistir os dados nos repositórios mockados e refletir no restante do app.

**Aceite:** concluir ou pular cada etapa chega à home, com informações preenchidas acessíveis nos módulos adequados.

### Etapa 5 — Home e acesso rápido

**Frames:** `153:2`, `99:236`.

- [ ] Implementar saudação “Bom dia, Maria Santos” (ou conforme hora do dispositivo, preservando modo de comparação com o Figma).
- [ ] Card de compromissos e medicação com ações reais de navegação.
- [ ] Botão SOS abre Central de emergência.
- [ ] Grade de atalhos (6 itens na Home; grade expandida no Acesso rápido).
- [ ] Campo de busca do Acesso rápido filtra os atalhos em tempo real.
- [ ] Implementar seções da Home abaixo da primeira dobra, com scroll vertical e estado derivado dos mocks.
- [ ] Bottom nav permaneça funcional em todas as telas principais.

**Aceite:** Home visualmente próxima ao Figma; todos os atalhos têm destino correto e dados sincronizados.

### Etapa 6 — Medicamentos e histórico de saúde

**Frames:** `168:279`, `200:483`, `103:227`.

- [ ] Lista de medicamentos do dia com nome, dose, horário e estado “Tomado/Tomar”.
- [ ] Marcar tomada; alternar estados e refletir na rotina/home.
- [ ] Novo medicamento: nome, dosagem, formato, período, horário, recorrência, controle de estoque e alerta.
- [ ] Validar dosagem, horário e campos obrigatórios, sem inventar orientação clínica.
- [ ] Histórico de saúde com abas Pressão, Glicemia e Peso; dados mockados por categoria.
- [ ] Exibir últimos registros, histórico anterior e formulário mínimo de nova medição.
- [ ] Botão “Enviar Histórico ao Médico” abre prévia simulada, sem enviar dados sensíveis.
- [ ] Notificações/alarme e receita médica permanecem **representações visuais**, sem integração com SO ou prontuário.

**Aceite:** os dados inseridos aparecem nas listas, os status podem mudar e os filtros funcionam; nenhuma solicitação médica é executada externamente.

### Etapa 7 — Rotina e tarefas

**Frames:** `98:133`, `103:85`.

- [ ] Criar seleção de dias da semana; navegar entre dias usando estado local.
- [ ] Listar compromissos e medicamentos vinculados às datas.
- [ ] Tela de tarefas com abas Pendentes/Concluídas e grupos por período.
- [ ] Permitir incluir, concluir, reabrir e, quando apropriado, remover tarefas.
- [ ] Atualizar contagens das abas a partir das coleções reais mockadas.
- [ ] Sincronizar a seção “Ainda falta hoje” da Home com tarefas/medicamentos.

**Aceite:** concluir tarefa altera imediatamente as contagens e a Home; a seleção de datas é consistente.

### Etapa 8 — Compromissos e compras

**Frames:** `103:296`, `163:239`, `103:370`.

- [ ] Compromissos: filtros Todos/Consultas/Exames; listagem por mês; ordenação por data e horário.
- [ ] Formulário de compromisso com tipo, nome, clínica, data, horário, médico opcional e opções visuais de aviso.
- [ ] Criar compromisso e mostrar na lista, na Home e na Rotina.
- [ ] Lista de compras com campo de adição, quantidade, abas Pendentes/No Carrinho e marcação individual.
- [ ] Atualizar contagens e estado entre abas.
- [ ] “Enviar Lista pelo WhatsApp” mostra prévia de compartilhamento fictício; não acionar WhatsApp sem decisão posterior.

**Aceite:** inclusão, filtros, classificação e marcação funcionam com consistência entre telas.

### Etapa 9 — Contatos, central de emergência e chamada simulada

**Frames:** `103:449`, `116:663`, `123:9`, `123:409`, `124:2`, `124:314`, `124:370`, `124:464`, `124:515`, `97:7`.

- [ ] Listar contatos; implementar busca e filtros Família/Médicos/Todos.
- [ ] Adicionar contato com nome, relação, telefone e sinalizador “mostrar na Home”.
- [ ] Exibir mensagem de confirmação, depois atualizar lista e filtros.
- [ ] Implementar tela visual de chamada com identificação, contador simulado, mute, viva-voz, teclado e botão desligar.
- [ ] Usar uma única `MockCallScreen` parametrizada, evitando duplicação para Ana, João, médico e SAMU.
- [ ] Central de emergência mostra contatos relevantes e dados da ficha de saúde mockada.
- [ ] “LIGAR AGORA” encaminha à **chamada simulada do SAMU 192**, com aviso de que nenhum contato real foi iniciado.

**Aceite:** funcionamento visual completo sem iniciar ligações reais. Não apresentar uma simulação de contato com serviços de emergência como se fosse efetiva.

### Etapa 10 — Perfil, ajustes e acessibilidade

**Frame:** `153:467`.

- [ ] Exibir perfil, idade, e-mail, ficha de saúde, plano, cuidador e preferências.
- [ ] Criar edição mock de dados pessoais, onde o Figma indica o controle.
- [ ] Configurar tamanho de letra e simulação do volume de lembretes.
- [ ] Garantir contraste, semântica para leitores de tela e áreas de toque confortáveis.
- [ ] Tela de ajuda simples/diálogo coerente com design.
- [ ] Logout funcional e retorno para tela de login.

**Aceite:** mudanças no perfil são refletidas em Home e contatos vinculados; preferências visuais têm efeito perceptível.

### Etapa 11 — Verificação visual, testes e entrega

- [ ] Comparar screenshots Flutter de cada tela com o frame correspondente do Figma na mesma área visível.
- [ ] Conferir espaçamentos, dimensões, fontes, assets, shadows, bordas, opacidade e ícones.
- [ ] Conferir layouts com zoom de fonte, teclado aberto, telas pequenas e alturas variadas.
- [ ] Validar rolagem, bottom nav, retorno, overlays, sheets, filtros e empty states.
- [ ] Testar repositórios mocks e providers; widget tests para formulários e navegação; goldens para telas principais.
- [ ] `dart format .`, `flutter analyze`, `flutter test`, `flutter build apk --debug` (se ambiente Android disponível).
- [ ] Criar `README.md` com como executar, rotas, dados demo, limitações de mocks e orientações de build.
- [ ] Gerar pacote de entrega com código-fonte e screenshots de validação.

**Aceite final:** fluxo completo do splash até os módulos funcionando sem rede e visual das telas consistente com os frames inspecionados. Integrações externas claramente marcadas como simuladas.

---

## 8. Regras de qualidade e cuidados especiais

### Acessibilidade

- Ações principais com área de toque confortável, tipicamente no mínimo 48 × 48 dp quando possível.
- Respeitar `MediaQuery.textScaler` sem quebrar cards, formulários ou rótulos.
- Usar `Semantics` para botões de ícone, estados de medicamento/tarefa e elementos SOS.
- Não comunicar estado apenas por cor: adicionar texto como “Tomado” ou “Pendente”.
- Contraste adequado para o vinho sobre fundos creme e vice-versa.

### Simulações que não podem ser confundidas com integrações reais

- Chamada/SAMU: **não liga**, não disca `tel:192` e não apresenta estado de conexão real.
- Google: **não autentica** em conta Google.
- Alarmes: **não cria** alarmes/notificações persistentes no sistema.
- Compartilhamentos: **não envia** informações a contatos ou aplicativos externos.
- Dados de saúde: demo local, sem aconselhamento ou envio real a médicos.

### Escopo fora do protótipo

Banco de dados remoto, gestão de usuário real, autenticação real, sincronização multiusuário, serviço de emergências, telemedicina, agendamento de notificações, infraestrutura de produção e publicação em lojas. Estes recursos são evolução futura e devem ser adicionados mediante decisão explícita.

---

## 9. Critérios globais de aceite

- [ ] Todos os frames do inventário estão mapeados para rotas, modais ou estados reutilizados.
- [ ] Não há botões “mortos”: todos navegam, modificam estado ou mostram uma simulação explícita.
- [ ] Não há asset do Figma carregado por URL temporária em produção.
- [ ] O nome de Maria Santos, a ficha e os dados editados mantêm consistência entre telas.
- [ ] Repositórios são substituíveis por implementações de API sem reescrever widgets.
- [ ] A navegação inferior funciona com pilhas de navegação consistentes.
- [ ] A aplicação funciona offline e não realiza requisições de rede necessárias ao fluxo.
- [ ] Os fluxos de emergência não executam chamadas reais.
- [ ] Testes e análise estática passam em ambiente Flutter configurado.
- [ ] Divergências inevitáveis com o Figma são documentadas, não omitidas.

---

## 10. Prompt inicial sugerido para o Codex

> Implemente o aplicativo **KUIDE** em **Flutter/Dart**, com base no `ROADMAP.md` e no Figma `https://www.figma.com/design/Rh0ArNre5RTbbiXQ70SoZM/ME-I?node-id=0-1`. O aplicativo deve ser funcional com repositórios mockados locais, Riverpod e GoRouter, sem backend, sem login Google real, sem ligações reais, sem compartilhamento real e sem notificações do sistema. Reproduza fielmente os frames, extraindo e armazenando assets individuais locais; não use screenshots inteiros como UI. **Trabalhe em uma única etapa por vez.** Comece pela **Etapa 0 (Auditoria e extração dos assets)**, produza `docs/figma-mapping.md`, identifique os recursos que não conseguir exportar e **pare ao concluir essa etapa** para validação. A cada etapa seguinte, preserve as funcionalidades já implementadas, execute `flutter analyze` e os testes disponíveis, e apresente um resumo de alterações e pendências.

---

## 11. Observações sobre a referência

- O arquivo tem telas com **fontes diferentes** e alguns frames desenhados como variações de estado; uma implementação coerente deve preservar essas decisões no limite do possível e reutilizar componentes reais.
- O arquivo inclui IDs e conteúdo de demonstração como Maria Santos, medicamentos, consultas e contatos. Dados fictícios podem ser usados como seeds, mas devem permanecer claramente marcados como demonstração.
- Imagens e fontes precisam ter permissões de uso compatíveis com o projeto antes de distribuição pública.
- Este documento é um roteiro de implementação construído após inspeção das estruturas e de contextos visuais do Figma. Não substitui a verificação frame a frame durante a codificação.
