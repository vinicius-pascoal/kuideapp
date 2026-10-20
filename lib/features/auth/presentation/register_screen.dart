import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/app_fields.dart';
import 'auth_validators.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();
  var _acceptedTerms = false;
  var _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aceite os termos fictícios para continuar.')),
      );
      return;
    }
    setState(() => _submitting = true);
    await ref.read(authSessionProvider.notifier).signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        );
    if (!mounted) return;
    context.go('/home');
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
                      Text('Criar conta', style: Theme.of(context).textTheme.displaySmall),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Use dados de demonstração. Nenhum cadastro real será criado.', style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: AppSpacing.xl),
                      AppTextField(label: 'Nome completo', controller: _nameController, validator: AuthValidators.name),
                      const SizedBox(height: AppSpacing.sm),
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
                      const SizedBox(height: AppSpacing.sm),
                      AppPasswordField(
                        label: 'Confirmar senha',
                        controller: _confirmationController,
                        validator: (value) => value != _passwordController.text ? 'As senhas não são iguais.' : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      CheckboxListTile(
                        value: _acceptedTerms,
                        onChanged: (value) => setState(() => _acceptedTerms = value ?? false),
                        title: const Text('Li e aceito os termos fictícios de uso.'),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      PrimaryButton(label: 'Criar conta', onPressed: _register, isLoading: _submitting),
                      const SizedBox(height: AppSpacing.sm),
                      SecondaryButton(label: 'Voltar para entrar', onPressed: () => context.go('/login')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
