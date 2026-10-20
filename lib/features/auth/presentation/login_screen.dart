import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/app_fields.dart';
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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.favorite_rounded, color: AppColors.wine, size: 56),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Bem-vinda ao KUIDE', style: Theme.of(context).textTheme.displaySmall),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Organize os seus cuidados com tranquilidade.', style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: AppSpacing.xl),
                      AppTextField(
                        label: 'E-mail',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: AuthValidators.email,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppPasswordField(
                        label: 'Senha',
                        controller: _passwordController,
                        validator: AuthValidators.password,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      PrimaryButton(label: 'Entrar', onPressed: _signIn, isLoading: _submitting),
                      const SizedBox(height: AppSpacing.sm),
                      SecondaryButton(
                        label: 'Entrar com Google',
                        icon: Icons.account_circle_outlined,
                        onPressed: _submitting ? null : _continueWithGoogleMock,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextButton(
                        onPressed: () => context.go('/register'),
                        child: const Text('Ainda não tem uma conta? Criar conta'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const Text(
                        'Versão de demonstração: nenhum dado é enviado pela internet.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
