import 'package:flutter_test/flutter_test.dart';
import 'package:aom_ground_transport/data/models/mission_model.dart';

void main() {
  group('URL WhatsApp — logique pure', () {
    test('construction URL wa.me correcte', () {
      const phone = '+212661924588';
      const message = 'Bonjour test';
      final clean = phone.replaceAll(RegExp(r'[\s\-()]'), '');
      final encoded = Uri.encodeComponent(message);
      final url = 'https://wa.me/$clean?text=$encoded';

      expect(url, startsWith('https://wa.me/+212661924588'));
      expect(url, contains('text='));
    });

    test('nettoyage numéro supprime espaces et tirets', () {
      final dirty = '+212 661-924 588';
      final clean = dirty.replaceAll(RegExp(r'[\s\-()]'), '');
      expect(clean, '+212661924588');
      expect(clean, isNot(contains(' ')));
      expect(clean, isNot(contains('-')));
    });

    test('numéro sans indicatif reste inchangé', () {
      const phone = '0661924588';
      final clean = phone.replaceAll(RegExp(r'[\s\-()]'), '');
      expect(clean, '0661924588');
    });

    test('message vide génère URL minimale', () {
      const phone = '+212600000000';
      const message = '';
      final clean = phone.replaceAll(RegExp(r'[\s\-()]'), '');
      final encoded = Uri.encodeComponent(message);
      final url = 'https://wa.me/$clean?text=$encoded';
      expect(url, contains('wa.me'));
    });
  });

  group('MissionModel.statusLabel', () {
    DateTime fakeDate() => DateTime(2024, 1, 1, 8, 0);

    MissionModel makeMission(String status) => MissionModel(
          id: 1,
          reference: 'AOM-TEST',
          type: 'DEPART',
          driverId: 1,
          driverName: 'Youssef',
          driverPhone: '+212661924588',
          vehicleId: 1,
          vehicleBrand: 'Mercedes',
          vehiclePlate: 'AOM-001',
          destinationId: 1,
          destinationName: 'GMMB',
          destinationCity: 'Benslimane',
          scheduledAt: fakeDate(),
          status: status,
          returnToBase: true,
          createdAt: fakeDate(),
          passengers: const [],
          steps: const [],
          driverWhatsappStatus: 'NON_ENVOYE',
        );

    test('PLANIFIEE → Planifiée', () {
      expect(makeMission('PLANIFIEE').statusLabel, 'Planifiée');
    });

    test('EN_COURS → En cours', () {
      expect(makeMission('EN_COURS').statusLabel, 'En cours');
    });

    test('TERMINEE → Terminée', () {
      expect(makeMission('TERMINEE').statusLabel, 'Terminée');
    });

    test('ANNULEE → Annulée', () {
      expect(makeMission('ANNULEE').statusLabel, 'Annulée');
    });
  });

  group('MissionModel.typeLabel', () {
    DateTime fakeDate() => DateTime(2024, 1, 1);

    MissionModel makeMission(String type) => MissionModel(
          id: 1,
          reference: 'AOM-TEST',
          type: type,
          driverId: 1,
          driverName: 'Test',
          driverPhone: '',
          vehicleId: 1,
          vehicleBrand: 'Test',
          vehiclePlate: 'TEST',
          destinationId: 1,
          destinationName: 'Test',
          destinationCity: 'Test',
          scheduledAt: fakeDate(),
          status: 'PLANIFIEE',
          returnToBase: false,
          createdAt: fakeDate(),
          passengers: const [],
          steps: const [],
          driverWhatsappStatus: 'NON_ENVOYE',
        );

    test('DEPART → Départ', () {
      expect(makeMission('DEPART').typeLabel, 'Départ');
    });

    test('ARRIVEE → Arrivée', () {
      expect(makeMission('ARRIVEE').typeLabel, 'Arrivée');
    });
  });
}
