import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/mock_action_dialog.dart';
import 'auth_validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _obscured = true;
  var _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    await ref.read(authSessionProvider.notifier).signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (!mounted) return;
    context.go('/home');
  }

  Future<void> _continueWithGoogleMock() async {
    await MockActionDialog.show(
      context,
      title: 'Entrada Google simulada',
      message: 'Nenhuma conta Google será acessada. Você continuará usando dados locais de demonstração.',
      confirmLabel: 'Continuar',
    );
    if (!mounted) return;
    await ref.read(authSessionProvider.notifier).signInWithGoogleMock();
    if (mounted) context.go('/home');
  }

  InputDecoration _fieldDecoration({
    required String label,
    Widget? suffixIcon,
  }) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.wineText),
        filled: true,
        fillColor: AppColors.cream,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.wineText, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.wine, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.error, width: 2.5),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.loginWine,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final headerHeight = (constraints.maxHeight * 0.27).clamp(205.0, 260.0).toDouble();

              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      children: [
                        SizedBox(
                          height: headerHeight,
                          child: const _LoginHeader(),
                        ),
                        _LoginPanel(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          obscured: _obscured,
                          submitting: _submitting,
                          emailDecoration: _fieldDecoration(label: 'E-mail'),
                          passwordDecoration: _fieldDecoration(
                            label: 'Senha',
                            suffixIcon: IconButton(
                              tooltip: _obscured ? 'Mostrar senha' : 'Ocultar senha',
                              color: AppColors.wineText,
                              onPressed: () => setState(() => _obscured = !_obscured),
                              icon: Icon(_obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            ),
                          ),
                          onSignIn: _signIn,
                          onGoogle: _submitting ? null : _continueWithGoogleMock,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.cream,
                border: Border.all(color: AppColors.cream, width: 3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_rounded, color: AppColors.wineText, size: 35),
            ),
            const SizedBox(height: 12),
            Text(
              'KUIDE',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.cream,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Seu cuidado, sempre perto.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.lightText),
            ),
          ],
        ),
      );
}

class _LoginPanel extends StatelessWidget {
  const _LoginPanel({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscured,
    required this.submitting,
    required this.emailDecoration,
    required this.passwordDecoration,
    required this.onSignIn,
    required this.onGoogle,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscured;
  final bool submitting;
  final InputDecoration emailDecoration;
  final InputDecoration passwordDecoration;
  final VoidCallback onSignIn;
  final VoidCallback? onGoogle;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 610),
        padding: const EdgeInsets.fromLTRB(34, 38, 34, 32),
        decoration: const BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(54)),
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Bem-vinda ao KUIDE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.wineText,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Entre para organizar seus cuidados com tranquilidade.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.darkText),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: AuthValidators.email,
                decoration: emailDecoration,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: passwordController,
                obscureText: obscured,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) => onSignIn(),
                validator: AuthValidators.password,
                decoration: passwordDecoration,
              ),
              const SizedBox(height: 28),
              PrimaryButton(label: 'Entrar', onPressed: onSignIn, isLoading: submitting),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Entrar com Google',
                icon: Icons.g_mobiledata_rounded,
                onPressed: onGoogle,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text('Ainda não tem uma conta? Criar conta'),
              ),
              const SizedBox(height: 28),
              Text(
                'Versão de demonstração: nenhum dado é enviado pela internet.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.darkText),
              ),
            ],
          ),
        ),
      );
}
