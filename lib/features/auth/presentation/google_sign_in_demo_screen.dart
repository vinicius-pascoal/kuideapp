import 'package:flutter/material.dart';

class GoogleSignInDemoScreen extends StatefulWidget {
  const GoogleSignInDemoScreen({super.key});

  @override
  State<GoogleSignInDemoScreen> createState() => _GoogleSignInDemoScreenState();
}

class _GoogleSignInDemoScreenState extends State<GoogleSignInDemoScreen> {
  var _showConsent = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: _showConsent ? _GoogleConsent(onBack: () => setState(() => _showConsent = false)) : _AccountChooser(onSelected: () => setState(() => _showConsent = true)),
          ),
        ),
      ),
    ),
  );
}

class _AccountChooser extends StatelessWidget {
  const _AccountChooser({required this.onSelected});

  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const _GoogleMark(),
      const SizedBox(height: 24),
      const Text('Fazer login com o Google', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
      const SizedBox(height: 12),
      const Text('Use sua Conta do Google para continuar no KUIDE', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Color(0xFF5F6368))),
      const SizedBox(height: 30),
      const Divider(),
      _GoogleAccountTile(
        initials: 'MS',
        name: 'Maria Santos',
        email: 'maria.santos@exemplo.com',
        onTap: onSelected,
      ),
      const Divider(),
      ListTile(
        leading: const CircleAvatar(backgroundColor: Color(0xFFF1F3F4), child: Icon(Icons.person_add_alt_1_outlined, color: Color(0xFF3C4043))),
        title: const Text('Usar outra conta'),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demonstração: selecione a conta Maria Santos.'))),
      ),
      const Divider(),
      const SizedBox(height: 18),
      const Text('Esta é uma simulação. Nenhuma conta Google real será acessada.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Color(0xFF5F6368))),
    ],
  );
}

class _GoogleConsent extends StatelessWidget {
  const _GoogleConsent({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back))),
      const _GoogleMark(),
      const SizedBox(height: 22),
      const Text('Continuar no KUIDE', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
      const SizedBox(height: 10),
      const Text('Maria Santos\nmaria.santos@exemplo.com', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Color(0xFF3C4043))),
      const SizedBox(height: 30),
      const Text('O KUIDE receberá apenas as informações básicas do seu perfil:', style: TextStyle(fontSize: 15)),
      const SizedBox(height: 16),
      const _PermissionRow(icon: Icons.person_outline, label: 'Seu nome e endereço de e-mail'),
      const _PermissionRow(icon: Icons.info_outline, label: 'Informação usada somente nesta demonstração'),
      const SizedBox(height: 22),
      const Text('Nenhum dado é enviado para servidores externos.', style: TextStyle(fontSize: 12, color: Color(0xFF5F6368))),
      const SizedBox(height: 22),
      Align(
        alignment: Alignment.centerRight,
        child: FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFF1A73E8), foregroundColor: Colors.white),
          child: const Text('Continuar'),
        ),
      ),
    ],
  );
}

class _GoogleAccountTile extends StatelessWidget {
  const _GoogleAccountTile({required this.initials, required this.name, required this.email, required this.onTap});

  final String initials;
  final String name;
  final String email;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 6),
    leading: CircleAvatar(backgroundColor: const Color(0xFF7A1624), foregroundColor: Colors.white, child: Text(initials)),
    title: Text(name),
    subtitle: Text(email),
    onTap: onTap,
  );
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [Icon(icon, color: const Color(0xFF5F6368)), const SizedBox(width: 14), Expanded(child: Text(label))]),
  );
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) => const Text(
    'G',
    style: TextStyle(color: Color(0xFF4285F4), fontSize: 40, fontWeight: FontWeight.w700),
  );
}
