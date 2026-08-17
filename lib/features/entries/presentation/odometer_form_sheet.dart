import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/app_database_providers.dart';
import 'package:odostat/core/format/formatters.dart';
import 'package:odostat/core/theme/app_colors.dart';

/// Bottom-sheet form to add/edit an odometer reading.
class OdometerFormSheet extends ConsumerStatefulWidget {
  const OdometerFormSheet({required this.vehicle, this.existing, super.key});

  final Vehicle vehicle;
  final OdometerReading? existing;

  static Future<void> show(
    BuildContext context, {
    required Vehicle vehicle,
    OdometerReading? existing,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => OdometerFormSheet(vehicle: vehicle, existing: existing),
    );
  }

  @override
  ConsumerState<OdometerFormSheet> createState() => _OdometerFormSheetState();
}

class _OdometerFormSheetState extends ConsumerState<OdometerFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _value;
  late final TextEditingController _note;
  late DateTime _date;

  OdometerReading? get _existing => widget.existing;
  bool get _isEdit => _existing != null;

  @override
  void initState() {
    super.initState();
    _value = TextEditingController(text: _existing?.value.toString() ?? '');
    _note = TextEditingController(text: _existing?.note ?? '');
    _date = _existing != null ? Fmt.intToDate(_existing!.date) : DateTime.now();
  }

  @override
  void dispose() {
    _value.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final dao = ref.read(odometerDaoProvider);
    final value = int.parse(_value.text.trim());
    final note = _note.text.trim().isEmpty ? null : _note.text.trim();

    if (_isEdit) {
      await dao.updateReading(
        _existing!.copyWith(
          date: Fmt.dateToInt(_date),
          value: value,
          note: Value(note),
        ),
      );
    } else {
      await dao.insertReading(
        OdometerReadingsCompanion.insert(
          date: Fmt.dateToInt(_date),
          vehicleId: widget.vehicle.id,
          value: value,
          note: Value(note),
        ),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset + bottomPadding),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEdit ? 'Kilometerstand bearbeiten' : 'Neuer Kilometerstand',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(14),
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Datum'),
                child: Text(Fmt.date(Fmt.dateToInt(_date))),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _value,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Kilometerstand',
                suffixText: 'km',
              ),
              validator: (v) {
                final n = int.tryParse((v ?? '').trim());
                if (n == null || n <= 0) return 'Ungültig';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _note,
              decoration: const InputDecoration(labelText: 'Notiz (optional)'),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _save,
              child: Text(_isEdit ? 'Speichern' : 'Hinzufügen'),
            ),
          ],
        ),
      ),
    );
  }
}
