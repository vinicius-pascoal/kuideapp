abstract final class AuthValidators {
  static String? name(String? value) {
    if (value == null || value.trim().length < 2) {
      return 'Informe seu nome completo.';
    }
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Informe seu e-mail.';
    if (!email.contains('@') || !email.contains('.')) {
      return 'Informe um e-mail válido.';
    }
    return null;
  }

  static String? password(String? value) {
    if ((value ?? '').length < 6) return 'A senha deve ter pelo menos 6 caracteres.';
    return null;
  }
}
