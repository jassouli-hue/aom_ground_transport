import 'package:drift/drift.dart';
import '../app_database.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<Setting?> getByKey(String key) =>
      (select(settings)..where((s) => s.key.equals(key))).getSingleOrNull();

  Future<String?> getValue(String key) async {
    final row = await getByKey(key);
    return row?.value;
  }

  Future<void> setValue(String key, String value) async {
    final entry = SettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(DateTime.now()),
    );
    // ON CONFLICT(key) — la contrainte UNIQUE est sur key, pas sur id
    await into(settings).insert(
      entry,
      onConflict: DoUpdate(
        (old) => entry,
        target: [settings.key],
      ),
    );
  }

  Future<List<Setting>> getAll() => select(settings).get();
}
