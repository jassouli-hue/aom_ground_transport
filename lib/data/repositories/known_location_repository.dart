import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/known_location_model.dart';

class KnownLocationRepository {
  final AppDatabase _db;

  KnownLocationRepository(this._db);

  Stream<List<KnownLocationModel>> watchAll() =>
      _db.knownLocationDao.watchAllActive().map(
        (rows) => rows.map(_toModel).toList(),
      );

  Future<List<KnownLocationModel>> getAll() async {
    final rows = await _db.knownLocationDao.getAllActive();
    return rows.map(_toModel).toList();
  }

  Future<List<KnownLocationModel>> getAirports() async {
    final rows = await _db.knownLocationDao.getAirports();
    return rows.map(_toModel).toList();
  }

  Future<KnownLocationModel?> getById(int id) async {
    final row = await _db.knownLocationDao.getById(id);
    return row != null ? _toModel(row) : null;
  }

  Future<int> create({
    required String name,
    required String shortCode,
    required String city,
    required double latitude,
    required double longitude,
    bool isAirport = false,
  }) =>
      _db.knownLocationDao.insertLocation(KnownLocationsCompanion(
        name: Value(name),
        shortCode: Value(shortCode),
        city: Value(city),
        latitude: Value(latitude),
        longitude: Value(longitude),
        isAirport: Value(isAirport),
      ));

  Future<void> update(KnownLocationModel loc) =>
      _db.knownLocationDao.updateLocation(KnownLocationsCompanion(
        id: Value(loc.id),
        name: Value(loc.name),
        shortCode: Value(loc.shortCode),
        city: Value(loc.city),
        latitude: Value(loc.latitude),
        longitude: Value(loc.longitude),
        isAirport: Value(loc.isAirport),
        isActive: Value(loc.isActive),
      ));

  Future<void> delete(int id) => _db.knownLocationDao.softDelete(id);

  KnownLocationModel _toModel(KnownLocation row) => KnownLocationModel(
        id: row.id,
        name: row.name,
        shortCode: row.shortCode,
        city: row.city,
        latitude: row.latitude,
        longitude: row.longitude,
        isAirport: row.isAirport,
        isActive: row.isActive,
      );
}
