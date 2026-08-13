import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/app_database_providers.dart';
import 'package:odostat/core/db/enums.dart';
import 'package:odostat/core/format/formatters.dart';
import 'package:odostat/core/theme/app_colors.dart';

/// Bottom-sheet form to add/edit a refuel (combustion) or charge (electric).
///
/// The UI adapts to [vehicle]'s propulsion: litres + fuel type + live €/l for
/// combustion, kWh + live €/kWh for electric.
class RefuelFormSheet extends ConsumerStatefulWidget {
  const RefuelFormSheet({required this.vehicle, this.existing, super.key});

  final Vehicle vehicle;
  final Refuel? existing;

  static Future<void> show(
    BuildContext context, {
    required Vehicle vehicle,
    Refuel? existing,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => RefuelFormSheet(vehicle: vehicle, existing: existing),
    );
  }

  @override
  ConsumerState<RefuelFormSheet> createState() => _RefuelFormSheetState();
}

class _RefuelFormSheetState extends ConsumerState<RefuelFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cost;
  late final TextEditingController _amount;
  late final TextEditingController _odometer;
  late final TextEditingController _note;
  late FuelType _fuelType;
  late DateTime _date;
  late bool _isFull;

  bool get _electric => widget.vehicle.propulsionType.isElectric;
  Refuel? get _existing => widget.existing;
  bool get _isEdit => _existing != null;

  @override
  void initState() {
    super.initState();
    _cost = TextEditingController(
      text: _existing != null ? Fmt.decimal2(_existing!.cost) : '',
    );
    _amount = TextEditingController(
      text: _existing != null ? Fmt.decimal2(_existing!.amount) : '',
    );
    _odometer = TextEditingController(
      text: _existing?.odometer?.toString() ?? '',
    );
    _note = TextEditingController(text: _existing?.note ?? '');
    _fuelType = _existing?.fuelType ??
        (_electric ? FuelType.electric : FuelType.e10);
    _date = _existing != null ? Fmt.intToDate(_existing!.date) : DateTime.now();
    _isFull = _existing?.isFull ?? true;
  }

  @override
  void dispose() {
    _cost.dispose();
    _amount.dispose();
    _odometer.dispose();
    _note.dispose();
    super.dispose();
  }

  /// Parses a German-formatted decimal ("1.234,56") or plain "1234.56".
  double? _parseNum(String raw) {
    final normalized = raw.trim().replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  double? get _unitPrice {
    final c = _parseNum(_cost.text);
    final a = _parseNum(_amount.text);
    if (c == null || a == null || a <= 0) return null;
    return c / a;
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
    final dao = ref.read(refuelDaoProvider);
    final cost = _parseNum(_cost.text)!;
    final amount = _parseNum(_amount.text)!;
    final odo = int.tryParse(_odometer.text.trim());
    final note = _note.text.trim().isEmpty ? null : _note.text.trim();

    if (_isEdit) {
      await dao.updateRefuel(
        _existing!.copyWith(
          date: Fmt.dateToInt(_date),
          cost: cost,
          amount: amount,
          fuelType: _fuelType,
          isFull: _isFull,
          odometer: Value(odo),
          note: Value(note),
        ),
      );
    } else {
      await dao.insertRefuel(
        RefuelsCompanion.insert(
          date: Fmt.dateToInt(_date),
          vehicleId: widget.vehicle.id,
          cost: cost,
          amount: amount,
          fuelType: _fuelType,
          isFull: Value(_isFull),
          odometer: Value(odo),
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
    final unit = _electric ? 'kWh' : 'l';
    final price = _unitPrice;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEdit
                    ? (_electric ? 'Ladevorgang bearbeiten' : 'Tankvorgang bearbeiten')
                    : (_electric ? 'Neuer Ladevorgang' : 'Neuer Tankvorgang'),
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amount,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                      ],
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: _electric ? 'Energie' : 'Menge',
                        suffixText: unit,
                      ),
                      validator: (v) {
                        final n = _parseNum(v ?? '');
                        if (n == null || n <= 0) return 'Ungültig';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cost,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                      ],
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'Kosten',
                        suffixText: '€',
                      ),
                      validator: (v) {
                        final n = _parseNum(v ?? '');
                        if (n == null || n <= 0) return 'Ungültig';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Live unit price.
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  price == null
                      ? '—'
                      : (_electric
                          ? Fmt.eurPerKwh(price)
                          : Fmt.eurPerLiter(price)),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (!_electric) ...[
                SegmentedButton<FuelType>(
                  segments: const [
                    ButtonSegment(value: FuelType.e5, label: Text('E5')),
                    ButtonSegment(value: FuelType.e10, label: Text('E10')),
                    ButtonSegment(value: FuelType.diesel, label: Text('Diesel')),
                  ],
                  selected: {_fuelType},
                  onSelectionChanged: (s) =>
                      setState(() => _fuelType = s.first),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _odometer,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Kilometerstand (optional)',
                  suffixText: 'km',
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_electric ? 'Voll geladen' : 'Vollgetankt'),
                value: _isFull,
                activeThumbColor: AppColors.accent,
                onChanged: (v) => setState(() => _isFull = v),
              ),
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
      ),
    );
  }
}
