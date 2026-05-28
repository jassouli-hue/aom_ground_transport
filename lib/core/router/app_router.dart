import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/drivers/drivers_screen.dart';
import '../../presentation/screens/drivers/driver_form_screen.dart';
import '../../presentation/screens/vehicles/vehicles_screen.dart';
import '../../presentation/screens/vehicles/vehicle_form_screen.dart';
import '../../presentation/screens/passengers/passengers_screen.dart';
import '../../presentation/screens/passengers/passenger_form_screen.dart';
import '../../presentation/screens/locations/locations_screen.dart';
import '../../presentation/screens/locations/location_form_screen.dart';
import '../../presentation/screens/missions/missions_screen.dart';
import '../../presentation/screens/missions/mission_create_screen.dart';
import '../../presentation/screens/missions/mission_detail_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/drivers',
      builder: (context, state) => const DriversScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const DriverFormScreen(),
        ),
        GoRoute(
          path: ':id/edit',
          builder: (context, state) => DriverFormScreen(
            driverId: int.tryParse(state.pathParameters['id'] ?? ''),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/vehicles',
      builder: (context, state) => const VehiclesScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const VehicleFormScreen(),
        ),
        GoRoute(
          path: ':id/edit',
          builder: (context, state) => VehicleFormScreen(
            vehicleId: int.tryParse(state.pathParameters['id'] ?? ''),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/passengers',
      builder: (context, state) => const PassengersScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const PassengerFormScreen(),
        ),
        GoRoute(
          path: ':id/edit',
          builder: (context, state) => PassengerFormScreen(
            passengerId: int.tryParse(state.pathParameters['id'] ?? ''),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/locations',
      builder: (context, state) => const LocationsScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const LocationFormScreen(),
        ),
        GoRoute(
          path: ':id/edit',
          builder: (context, state) => LocationFormScreen(
            locationId: int.tryParse(state.pathParameters['id'] ?? ''),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/missions',
      builder: (context, state) => const MissionsScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const MissionCreateScreen(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) => MissionDetailScreen(
            missionId: int.parse(state.pathParameters['id']!),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page introuvable: ${state.uri}')),
  ),
);
