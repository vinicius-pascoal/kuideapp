import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/filter_tab_bar.dart';
import '../domain/appointment.dart';
import 'appointment_provider.dart';

class AppointmentsScreen extends ConsumerStatefulWidget { const AppointmentsScreen({super.key}); @override ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState(); }
class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen> {
  var _filter = 0;
  @override
  Widget build(BuildContext context) {
    final all = ref.watch(appointmentsProvider);
    final items = switch (_filter) { 1 => all.where((a) => a.type == AppointmentType.consultation).toList(), 2 => all.where((a) => a.type == AppointmentType.exam).toList(), _ => all };
    return Scaffold(
      body: SafeArea(child: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        AppHeader(title: 'Compromissos', onBack: () => context.pop()), const SizedBox(height: AppSpacing.md),
        FilterTabBar(labels: const ['Todos', 'Consultas', 'Exames'], selectedIndex: _filter, onSelected: (value) => setState(() => _filter = value)), const SizedBox(height: AppSpacing.lg),
        ..._groupedByMonth(items),
        if (items.isEmpty) const Center(child: Padding(padding: EdgeInsets.all(AppSpacing.lg), child: Text('Nenhum compromisso neste filtro.'))),
      ])),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => context.push('/appointments/add'), icon: const Icon(Icons.add), label: const Text('Adicionar')),
    );
  }

  List<Widget> _groupedByMonth(List<Appointment> items) {
    final widgets = <Widget>[];
    var previousMonth = -1;
    var previousYear = -1;
    for (final appointment in items) {
      if (appointment.dateTime.month != previousMonth || appointment.dateTime.year != previousYear) {
        widgets.add(Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: Text(_monthLabel(appointment.dateTime), style: Theme.of(context).textTheme.titleLarge)));
        previousMonth = appointment.dateTime.month;
        previousYear = appointment.dateTime.year;
      }
      widgets.add(_AppointmentCard(appointment: appointment));
    }
    return widgets;
  }
}
class _AppointmentCard extends StatelessWidget { const _AppointmentCard({required this.appointment}); final Appointment appointment;
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: AppCard(tint: false, child: ListTile(contentPadding: EdgeInsets.zero, leading: Icon(appointment.type == AppointmentType.consultation ? Icons.person_outline : Icons.science_outlined, color: AppColors.wine), title: Text(appointment.title), subtitle: Text('${_date(appointment.dateTime)} • ${appointment.clinic}${appointment.doctor == null ? '' : '\n${appointment.doctor}'}'), trailing: Text(appointment.type.label))));
}
String _date(DateTime value) => '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')} às ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
String _monthLabel(DateTime value) => const ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'][value.month - 1] + ' de ${value.year}';
