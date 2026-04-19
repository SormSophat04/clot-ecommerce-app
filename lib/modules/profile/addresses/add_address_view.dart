import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({super.key});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  GoogleMapController? _mapController;
  LatLng _pickedLocation = const LatLng(11.5564, 104.9282);
  bool _isLoadingLocation = false;
  
  final _streetCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Auto-fill form initially using the default or last known location immediately
    _updateAddressFromLocation(_pickedLocation);
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    if (!mounted) return;
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoadingLocation = false);
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoadingLocation = false);
        return;
      } 

      Position position = await Geolocator.getCurrentPosition();
      
      if (mounted) {
        setState(() {
          _pickedLocation = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });

        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_pickedLocation, 16),
        );
        
        _updateAddressFromLocation(_pickedLocation);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _updateAddressFromLocation(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        if (mounted) {
          setState(() {
             String street = '';
             if (placemark.street != null && !placemark.street!.contains('+')) {
                street = placemark.street!;
             } else {
                street = '${placemark.subThoroughfare ?? ''} ${placemark.thoroughfare ?? ''}'.trim();
             }
             
             _streetCtrl.text = street.isNotEmpty ? street : placemark.name ?? '';
             _cityCtrl.text = placemark.locality ?? placemark.subAdministrativeArea ?? '';
             _stateCtrl.text = placemark.administrativeArea ?? '';
             _zipCtrl.text = placemark.postalCode ?? '';
          });
        }
      }
    } catch (e) {
      debugPrint("Geocoding failed: $e");
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final inputFillColor =
        theme.inputDecorationTheme.fillColor ?? colorScheme.surfaceContainerHighest;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: inputFillColor,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16.sp,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Add Address',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            
            // Interactive Map section
            Container(
              height: 250.h,
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _pickedLocation,
                        zoom: 15,
                      ),
                      onMapCreated: (controller) => _mapController = controller,
                      onCameraMove: (position) {
                        _pickedLocation = position.target;
                      },
                      onCameraIdle: () {
                        _updateAddressFromLocation(_pickedLocation);
                      },
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                    ),
                    
                    // Center fixed marker
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.h), 
                        child: Icon(
                          Icons.location_on_rounded,
                          size: 40.sp,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),

                    // Locate me floating button
                    Positioned(
                      bottom: 12.h,
                      right: 12.w,
                      child: GestureDetector(
                        onTap: _isLoadingLocation ? null : _determinePosition,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: colorScheme.surface.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: colorScheme.onSurface.withValues(alpha: 0.1),
                                ),
                              ),
                              child: _isLoadingLocation
                                ? SizedBox(
                                    width: 20.sp, 
                                    height: 20.sp, 
                                    child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.primary)
                                  )
                                : Icon(Icons.my_location_rounded, size: 20.sp, color: colorScheme.primary),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16.h),

            // Form Fields
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                children: [
                  _CustomTextField(
                    controller: _streetCtrl,
                    label: 'Street Address',
                    hintText: 'Enter street address',
                    fillColor: inputFillColor,
                  ),
                  SizedBox(height: 16.h),
                  _CustomTextField(
                    controller: _cityCtrl,
                    label: 'City',
                    hintText: 'Enter city',
                    fillColor: inputFillColor,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: _CustomTextField(
                          controller: _stateCtrl,
                          label: 'State',
                          hintText: 'Enter state',
                          fillColor: inputFillColor,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _CustomTextField(
                          controller: _zipCtrl,
                          label: 'Zip Code',
                          hintText: 'Enter zip code',
                          fillColor: inputFillColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Save Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save Address',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final Color fillColor;

  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 15.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            ),
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 15.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class AddAddressBinding extends Bindings {
  @override
  void dependencies() {}
}
