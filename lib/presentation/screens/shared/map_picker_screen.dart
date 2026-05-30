import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_theme.dart';

class LatLngResult {
  final double lat;
  final double lng;
  final String? address; // adresse courte (quartier + ville)
  final String? city;    // ville uniquement

  const LatLngResult(this.lat, this.lng, {this.address, this.city});
}

/// Reverse geocoding via Nominatim (OSM, gratuit, sans clé API).
Future<_NominatimResult?> _reverseGeocode(double lat, double lng) async {
  try {
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse'
      '?lat=$lat&lon=$lng&format=json&accept-language=fr&zoom=16',
    );
    final resp = await http
        .get(uri, headers: {'User-Agent': 'AOM-GT/1.0 (aom@groundtransport.ma)'})
        .timeout(const Duration(seconds: 6));
    if (resp.statusCode != 200) return null;
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return _NominatimResult.fromJson(data);
  } catch (_) {
    return null;
  }
}

class _NominatimResult {
  final String city;
  final String shortAddress; // ex: "Rue Ibnou Hazm, Hay Hassani, Casablanca"

  _NominatimResult({required this.city, required this.shortAddress});

  factory _NominatimResult.fromJson(Map<String, dynamic> json) {
    final addr = (json['address'] as Map<String, dynamic>?) ?? {};

    // Ville : essayer plusieurs clés Nominatim
    final city = addr['city'] as String? ??
        addr['town'] as String? ??
        addr['village'] as String? ??
        addr['municipality'] as String? ??
        addr['county'] as String? ??
        addr['state'] as String? ??
        '';

    // Adresse courte : route + quartier + ville
    final parts = <String>[];
    final road = addr['road'] as String?;
    final neighbourhood = addr['neighbourhood'] as String? ??
        addr['suburb'] as String? ??
        addr['quarter'] as String?;
    if (road != null) parts.add(road);
    if (neighbourhood != null) parts.add(neighbourhood);
    if (city.isNotEmpty) parts.add(city);

    return _NominatimResult(
      city: city,
      shortAddress: parts.isNotEmpty ? parts.join(', ') : (json['display_name'] as String? ?? ''),
    );
  }
}

/// Écran de sélection d'un point sur la carte (OpenStreetMap, sans API key).
class MapPickerScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final String title;

  const MapPickerScreen({
    super.key,
    this.initialLat,
    this.initialLng,
    this.title = 'Choisir un emplacement',
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late final MapController _mapController;
  LatLng? _selected;
  _NominatimResult? _geocodeResult;
  bool _geocoding = false;

  // Centre par défaut : Casablanca (Maroc)
  static const _defaultCenter = LatLng(33.5731, -7.5898);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    if (widget.initialLat != null && widget.initialLng != null) {
      _selected = LatLng(widget.initialLat!, widget.initialLng!);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        actions: [
          if (_selected != null)
            TextButton.icon(
              onPressed: _confirm,
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text('Confirmer',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selected ?? _defaultCenter,
              initialZoom: _selected != null ? 14 : 6,
              onTap: (tapPosition, point) async {
                setState(() {
                  _selected = point;
                  _geocodeResult = null;
                  _geocoding = true;
                });
                final result = await _reverseGeocode(point.latitude, point.longitude);
                if (mounted) {
                  setState(() {
                    _geocodeResult = result;
                    _geocoding = false;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.aom.ground_transport',
              ),
              if (_selected != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selected!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        color: AppColors.error,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Instruction en bas
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_selected == null)
                    const Row(
                      children: [
                        Icon(Icons.touch_app, color: AppColors.primary, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Appuyez sur la carte pour sélectionner',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_pin, color: AppColors.error, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${_selected!.latitude.toStringAsFixed(5)}, ${_selected!.longitude.toStringAsFixed(5)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Adresse reverse geocodée
                        if (_geocoding)
                          const Row(children: [
                            SizedBox(width: 14, height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2)),
                            SizedBox(width: 8),
                            Text('Recherche de l\'adresse…',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ])
                        else if (_geocodeResult != null) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.place, color: AppColors.primary, size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _geocodeResult!.shortAddress,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _confirm,
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text('Confirmer cet emplacement'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // Bouton recentrer sur Maroc
          Positioned(
            top: 12,
            right: 12,
            child: FloatingActionButton.small(
              heroTag: 'recenter',
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              onPressed: () {
                _mapController.move(
                  _selected ?? _defaultCenter,
                  _selected != null ? 14 : 6,
                );
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  void _confirm() {
    if (_selected != null) {
      Navigator.of(context).pop(
        LatLngResult(
          _selected!.latitude,
          _selected!.longitude,
          address: _geocodeResult?.shortAddress,
          city: _geocodeResult?.city,
        ),
      );
    }
  }
}
