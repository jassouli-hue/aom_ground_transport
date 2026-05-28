import '../../data/database/app_database.dart';

class SettingsService {
  final AppDatabase _db;

  SettingsService(this._db);

  Future<String> getCompanyName() async =>
      await _db.settingsDao.getValue('company_name') ?? 'AIR OCEAN MAROC';

  Future<double> getAverageSpeedKmh() async {
    final v = await _db.settingsDao.getValue('average_speed_kmh');
    return double.tryParse(v ?? '80') ?? 80.0;
  }

  Future<void> setAverageSpeedKmh(double speed) =>
      _db.settingsDao.setValue('average_speed_kmh', speed.toString());

  Future<int?> getBaseLocationId() async {
    final v = await _db.settingsDao.getValue('base_location_id');
    return int.tryParse(v ?? '');
  }

  Future<void> setBaseLocationId(int id) =>
      _db.settingsDao.setValue('base_location_id', id.toString());

  Future<bool> isPinEnabled() async =>
      (await _db.settingsDao.getValue('pin_enabled')) == 'true';

  Future<void> setPinEnabled(bool enabled) =>
      _db.settingsDao.setValue('pin_enabled', enabled.toString());

  Future<String?> getPinCode() =>
      _db.settingsDao.getValue('pin_code');

  Future<void> setPinCode(String pin) =>
      _db.settingsDao.setValue('pin_code', pin);

  Future<bool> verifyPin(String input) async {
    final stored = await getPinCode();
    return stored == input;
  }
}
