import '../domain/onboarding_draft.dart';

abstract interface class OnboardingRepository {
  Future<OnboardingDraft> load();
  Future<void> save(OnboardingDraft draft);
}

class MockOnboardingRepository implements OnboardingRepository {
  OnboardingDraft _draft = const OnboardingDraft();

  @override
  Future<OnboardingDraft> load() async => _draft;

  @override
  Future<void> save(OnboardingDraft draft) async {
    _draft = draft;
  }
}
