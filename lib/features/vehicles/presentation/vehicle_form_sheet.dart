import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/app_database_providers.dart';
import 'package:odostat/core/db/enums.dart';
import 'package:odostat/core/format/formatters.dart';
import 'package:odostat/core/theme/app_colors.dart';

/// Bottom-sheet form to create or edit a [Vehicle].
///
/// Pass [existing] to edit; omit to create. Returns nothing — writes go
/// straight through the DAO and the list updates reactively.
class VehicleFormSheet extends ConsumerStatefulWidget {
  const VehicleFormSheet({this.existing, super.key});

  final Vehicle? existing;

  static Future<void> show(BuildContext context, {Vehicle? existing}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => VehicleFormSheet(existing: existing),
    );
  }

  @override
  ConsumerState<VehicleFormSheet> createState() => _VehicleFormSheetState();
}

class _VehicleFormSheetState extends ConsumerState<VehicleFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _mileage;
  late PropulsionType _propulsion;
  late DateTime _acquired;
  late bool _archived;

  Vehicle? get _existing => widget.existing;
  bool get _isEdit => _existing != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: _existing?.name ?? '');
    _mileage = TextEditingController(
      text: _existing != null ? _existing!.initialMileage.toString() : '',
    );
    _propulsion = _existing?.propulsionType ?? PropulsionType.combustion;
    _acquired = _existing != null
        ? Fmt.intToDate(_existing!.acquisitionDate)
        : DateTime.now();
    _archived = _existing?.isArchived ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _mileage.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _acquired,
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _acquired = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final dao = ref.read(vehicleDaoProvider);
    final mileage = int.tryParse(_mileage.text.trim()) ?? 0;

    if (_isEdit) {
      await dao.updateVehicle(
        _existing!.copyWith(
          name: _name.text.trim(),
          propulsionType: _propulsion,
          acquisitionDate: Fmt.dateToInt(_acquired),
          initialMileage: mileage,
          isArchived: _archived,
        ),
      );
    } else {
      await dao.insertVehicle(
        VehiclesCompanion.insert(
          name: _name.text.trim(),
          propulsionType: _propulsion,
          acquisitionDate: Fmt.dateToInt(_acquired),
          initialMileage: Value(mileage),
          isArchived: Value(_archived),
        ),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEdit ? 'Fahrzeug bearbeiten' : 'Neues Fahrzeug',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name fehlt' : null,
            ),
            const SizedBox(height: 16),
            SegmentedButton<PropulsionType>(
              segments: const [
                ButtonSegment(
                  value: PropulsionType.combustion,
                  label: Text('Verbrenner'),
                  icon: Icon(Icons.local_gas_station_rounded),
                ),
                ButtonSegment(
                  value: PropulsionType.electric,
                  label: Text('Elektro'),
                  icon: Icon(Icons.bolt_rounded),
                ),
              ],
              selected: {_propulsion},
              onSelectionChanged: (s) => setState(() => _propulsion = s.first),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(14),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Erwerbsdatum',
                      ),
                      child: Text(Fmt.date(Fmt.dateToInt(_acquired))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _mileage,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Start-km',
                      suffixText: 'km',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Archiviert'),
              subtitle: const Text('Ausblenden, Daten bleiben erhalten'),
              value: _archived,
              activeThumbColor: AppColors.accent,
              onChanged: (v) => setState(() => _archived = v),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _save,
              child: Text(_isEdit ? 'Speichern' : 'Anlegen'),
            ),
          ],
        ),
      ),
    );
  }
}
