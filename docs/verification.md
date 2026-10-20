# Verificação de entrega — Etapa 11

Data da revisão: 20 de outubro de 2026.

## Verificações realizadas

| Item | Resultado |
| --- | --- |
| Referências temporárias do Figma em código/runtime | Não encontradas em `lib/`, `assets/`, `test/` ou `pubspec.yaml` |
| Ações de chamada real (`tel:`) e launchers externos | Não encontradas |
| `git diff --check` | Passou |
| Mapeamento Figma → Flutter | Registrado em `docs/figma-mapping.md` |
| Cobertura de estados e providers locais | Testes de providers e widgets adicionados |

## Pendente de ambiente

O executável `flutter` não está disponível no `PATH` desta sessão. Por isso,
os comandos abaixo não puderam ser executados, nem foi possível gerar APK,
screenshots ou baselines golden:

```text
dart format .
flutter analyze
flutter test
flutter test --update-goldens
flutter build apk --debug
```

## Pendente de design

A cota da integração Figma foi atingida durante a Etapa 0. A Home foi
inspecionada, mas Login, Acesso rápido e os assets individuais ainda precisam
ser obtidos e exportados quando a cota for liberada. Isso impede a comparação
visual frame a frame e a entrega de assets definitivos locais. Nenhuma captura
de tela foi usada como interface.

## Próxima validação recomendada

1. Disponibilizar Flutter no `PATH` e executar os comandos listados acima.
2. Gerar os goldens e comparar o card/base de navegação.
3. Retomar a exportação dos assets do Figma, completar o mapping e substituir
os ícones Material provisórios pelos SVGs locais confirmados.
4. Capturar screenshots em Android/iOS e comparar cada rota com o frame Figma.
