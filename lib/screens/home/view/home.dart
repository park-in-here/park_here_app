// ignore_for_file: deprecated_member_use, undefined_hidden_name, unnecessary_null_comparison, curly_braces_in_flow_control_structures

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'package:park_in_here/screens/home/controller/home_controller.dart';
import 'package:park_in_here/screens/home/model/search_loc_model.dart'
    hide Location;
import 'package:park_in_here/screens/park_details/view/park_details.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<LocDatas> filteredResults = [];
  bool showSuggestions = false;
  late AnimationController _controller;
  late Animation<double> opacityAnim;
  HomeController contrlr = Get.put(HomeController());
  LatLng? currentLocation;
  bool vehicleSelected = false;
  bool locSelected = false;

  GetStorage store = GetStorage();
  late final MapController mapController;
  bool _mapReady = false;
  bool _parksLoading = false;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _searchController.addListener(_onSearchChanged);
    _getCurrentLocation();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Loop back and forth

    opacityAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  double calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    ); // returns distance in meters
  }

  String formatDistanceAndTime(double distanceInMeters,
      {double speedKmph = 40}) {
    if (distanceInMeters <= 0) return '?';

    final distanceKm = distanceInMeters / 1000;
    final timeHours = distanceKm / speedKmph;
    final timeMinutes = (timeHours * 60).round();

    final distanceText = distanceInMeters < 1000
        ? '${distanceInMeters.toStringAsFixed(0)}m'
        : '${distanceKm.toStringAsFixed(2)}km';

    final timeText = timeMinutes < 1 ? '<1min' : '${timeMinutes}min';

    return '$distanceText : $timeText';
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    // Check service
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    // Check permissions
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Get location
    final locData = await location.getLocation();
    final fetchedLocation =
        LatLng(locData.latitude ?? 0.0, locData.longitude ?? 0.0);

    setState(() {
      currentLocation = fetchedLocation;
    });

    // Fetch nearby places
    await contrlr.getNearby(
      currentLocation!.latitude.toString(),
      currentLocation!.longitude.toString(),
    );

    // Ensure map has built before moving the camera
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mapController != null) {
        mapController.move(currentLocation!, 12.0);
        log('Map moved to: ${currentLocation!.latitude}, ${currentLocation!.longitude}');
      }
    });
  }

  void _onSearchChanged() async {
    log('Search query: ${_searchController.text}');
    final query = _searchController.text.toLowerCase();
    if(query.length >1){
await contrlr.getLocations(query);
    }
    

    if (query.isEmpty) {
      setState(() {
        filteredResults.clear();
        showSuggestions = false;
      });
    } else {
      log('Filtering results for query: $query');
      final results = contrlr.locations;
      setState(() {
        filteredResults = results;
        showSuggestions = true;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) => SafeArea(
              child: Scaffold(
                backgroundColor:
                    _parksLoading == true ? Colors.grey : Colors.white,
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    // MAP
                    if (currentLocation != null)
                      FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          center: currentLocation!,
                          zoom: 12.0,
                          interactiveFlags:
                              InteractiveFlag.all & ~InteractiveFlag.rotate,
                          onMapReady: () {
                            setState(() {
                              _mapReady = true;
                            });
                          },
                        ),
                        children: [
                          TileLayer(
                            backgroundColor:
                                _parksLoading ? Colors.grey : Colors.white,
                            urlTemplate:
                                'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.parkin.park_in_here',
                          ),
                          MarkerLayer(
                            markers: [
                              if (currentLocation != null && !_parksLoading)
                                Marker(
                                  point: currentLocation!,
                                  width: 80,
                                  height: 80,
                                  child: Image.asset(
                                    'assets/images/current_loc.png',
                                    height: 50,
                                    width: 60,
                                  ),
                                ),
                              ...controller.nearby
                                  .map((place) {
                                    final lat = place.location?.latitude;
                                    final lng = place.location?.longitude;
                                    if (lat == null || lng == null) return null;

                                    return Marker(
                                      width: 100,
                                      height: 100,
                                      point: LatLng(lat, lng),
                                      child: Column(
                                        children: [
                                          const Icon(Icons.location_on,
                                              color: Colors.black, size: 30),
                                          Container(
                                            height: 30,
                                            width: 100,
                                            child: Center(
                                              child: Text(
                                                '${currentLocation != null ? (calculateDistance(currentLocation!, LatLng(lat, lng)) / 1000).toStringAsFixed(2) : '?'} km',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                  .whereType<Marker>()
                                  .toList(),
                            ],
                          ),
                        ],
                      ),

                    // LOADER WHILE FETCHING NEARBY
                    if (controller.mapisLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xff3572EF),
                        ),
                      ),

                    // 👉 SHOW ONLY AFTER:
                    //    - not loading
                    //    - map is ready
                    //    - nearby is empty
                    if (!controller.mapisLoading &&
                        _mapReady &&
                        controller.nearby.isEmpty)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'No nearby parking spots found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // Container(
                    //   decoration: const BoxDecoration(
                    //     image: DecorationImage(
                    //       fit: BoxFit.fill,
                    //       image: AssetImage('assets/images/map_bg.png'),
                    //     ),
                    //   ),
                    // ),
                    vehicleSelected == false
                        ? _welcome()
                        : Positioned(
                            top: 10,
                            left: showSuggestions ? 22 : 12,
                            right: showSuggestions ? 21 : 12,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          showSuggestions ? w * 0.74 : w * 0.78,
                                      height: 40,
                                      child: SearchBar(
                                        controller: _searchController,
                                        hintText: 'Search your location here',
                                        trailing: locSelected == true
                                            ? [
                                                IconButton(
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Colors.grey,
                                                      size: 16,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        locSelected = false;
                                                        showSuggestions = false;
                                                      });
                                                      _searchController.clear;
                                                    })
                                              ]
                                            : null,
                                        textStyle: MaterialStateProperty.all(
                                          GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff707070),
                                          ),
                                        ),
                                        onChanged: (value) =>
                                            _onSearchChanged(),
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                Colors.white),
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: locSelected == true
                                                ? BorderRadius.circular(20)
                                                : showSuggestions
                                                    ? const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20))
                                                    : BorderRadius.circular(20),
                                            // Border width
                                          ),
                                        ),
                                      ),
                                    ),
                                    // const SizedBox(width: 8),
                                    // if (showSuggestions == false)
                                    Image.asset(
                                      'assets/images/menu.png',
                                      height: 60,
                                      width: 50,
                                    )
                                  ],
                                ),
                                if (showSuggestions)
                                  _buildSuggestions(w, controller),
                              ],
                            ),
                          ),
                    if (locSelected == true)
                      _parksLoading
                          ? Center(
                              child: FadeTransition(
                                opacity: opacityAnim,
                                child: Image.asset(
                                  'assets/images/progress.png',
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                            )
                          : listPark(),
                    if (vehicleSelected == false)
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: h * 0.28,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        backgroundColor: Colors.white,
                                        constraints:
                                            BoxConstraints(maxHeight: h * 0.45),
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        'Select the vehicle that you want\n to park',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF181818),
                                                          fontSize: 16,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          height: 1.38,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Image.asset(
                                                        'assets/images/close.png',
                                                        height: 25,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Wrap(
                                                    spacing: 12,
                                                    runSpacing: 12,
                                                    children: List.generate(5,
                                                        (index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            vehicleSelected =
                                                                true;
                                                          });
                                                          Get.back();
                                                        },
                                                        child: Container(
                                                          width: index == 3 ||
                                                                  index == 4
                                                              ? w * 0.4
                                                              : w * 0.28,
                                                          height: 120,
                                                          // clipBehavior: Clip.antiAlias,
                                                          decoration:
                                                              ShapeDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              side:
                                                                  const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                    0xFFC1C1C1),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          20.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Image.asset(
                                                                    'assets/images/Motorcycle.png',
                                                                    height: 40,
                                                                    width: 70,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  textItem(
                                                                      'Two wheeler',
                                                                      Colors
                                                                          .black,
                                                                      12,
                                                                      FontWeight
                                                                          .w500)
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }))
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: optionItem(
                                      h * 0.25,
                                      w * 0.43,
                                      index == 0
                                          ? 'Find Parking'
                                          : 'Rent Space',
                                      index == 0
                                          ? 'assets/images/parking.png'
                                          : 'assets/images/rent.png',
                                      index == 0
                                          ? const Color.fromARGB(
                                              255, 145, 199, 188)
                                          : const Color(0xffA77FF8)),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(width: 16);
                              },
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ));
  }

  Widget _welcome() {
    var w = MediaQuery.of(context).size.width;
    return Container(
      height: 60,
      width: w,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 14,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcome ${store.read('name') ?? ''} !',
            style: const TextStyle(
              color: Color(0xFF181412) /* color-orange-8 */,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
          const SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.menu,
                size: 16,
              )),
        ],
      ),
    );
  }

  Widget _buildSuggestions(double width, HomeController controllr) {
    TextStyle tStyle = GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: const Color.fromARGB(255, 152, 150, 150),
    );

    return Container(
      width: width * 0.88,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          color: Colors.white,
          border: Border(
              top:
                  BorderSide(color: const Color(0xff707070).withOpacity(0.2)))),
      child: controllr.isLoading
          ? const Center(
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xff3572EF),
                    ),
                  )),
            )
          : locSelected == false
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: filteredResults.length,
                  itemBuilder: (context, index) {
                    var place = filteredResults[index];

                    return ListTile(
                      title: Text.rich(
                        _highlightText(
                            place.addressLine2!, _searchController.text),
                      ),
                      subtitle: Text(
                        place.addressLine1!,
                        style: tStyle,
                      ),
                      trailing: Text(
                        '${(currentLocation != null ? (calculateDistance(currentLocation!, LatLng(place.latitude!, place.longitude!)) / 1000).toStringAsFixed(2) : '...')} km',
                        style: tStyle.copyWith(color: Colors.black),
                      ),
                      // trailing: Text(
                      //   place['distance'],
                      //   style: tStyle,
                      // ),
                      onTap: () async {
                        // Handle selection
                        _searchController.text = place.addressLine2!;
                        setState(() {
                          locSelected = true;
                          showSuggestions = false;

                          _parksLoading = true;
                        });
                        await contrlr.getParkings(place.latitude!.toString(),
                            place.longitude!.toString());
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            _parksLoading = false;
                          });
                        });
                      },
                    );
                  },
                )
              : null,
    );
  }

  Widget gap(double h) {
    return SizedBox(height: h);
  }

  Widget listPark() {
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 70.0, left: 12, right: 20),
      child: ListView.separated(
        itemCount: contrlr.parkings.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              store.write('parkId', contrlr.parkings[index].id);
              Get.to(() => const ParkDetails());
            },
            child: Container(
              width: w * 0.2,
              height: 110,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/Rectangle 59.png',
                    height: 80,
                    width: 100,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gap(12),
                      Text(
                        contrlr.parkings.isNotEmpty
                            ? contrlr.parkings[index].name!
                            : 'Unknown Location',
                        style: const TextStyle(
                          color: Color(0xFF2D2D2D),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '${contrlr.parkings[index].location?.addressLine1},${contrlr.parkings[index].location?.addressLine2}',
                        style: const TextStyle(
                          color: Color(0x7F2D2D2D),
                          fontSize: 11,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      gap(20),
                      Text(
                        '₹${contrlr.parkings[index].pricePerHour}/hr',
                        style: const TextStyle(
                          color: Color(0xFF081024),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      gap(12),
                      Container(
                        height: 26,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: ShapeDecoration(
                          color: const Color(0x1605C9AD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Text(
                              (contrlr.parkings[index].location?.latitude !=
                                          null &&
                                      contrlr.parkings[index].location
                                              ?.longitude !=
                                          null &&
                                      currentLocation != null)
                                  ? (() {
                                      final distance = calculateDistance(
                                        currentLocation!,
                                        LatLng(
                                          contrlr.parkings[index].location!
                                              .latitude!,
                                          contrlr.parkings[index].location!
                                              .longitude!,
                                        ),
                                      );
                                      return formatDistanceAndTime(distance,
                                          speedKmph: 40);
                                    })()
                                  : '?',
                              style: const TextStyle(
                                color: Color(0xFF00A78F),
                                fontSize: 11,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      gap(35),
                      Text(
                          'Avl : ${contrlr.parkings[index].availableSlots} slot',
                          style: const TextStyle(
                            color: Color(0xFF00A78F),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ))
                    ],
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 10,
          );
        },
      ),
    );
  }

  TextSpan _highlightText(String fullText, String query) {
    final queryLower = query.toLowerCase();
    final fullTextLower = fullText.toLowerCase();

    List<TextSpan> spans = [];
    int start = 0;

    while (true) {
      final index = fullTextLower.indexOf(queryLower, start);
      if (index < 0) {
        spans.add(TextSpan(
          text: fullText.substring(start),
          style: const TextStyle(color: Color(0xff707070)), // grey
        ));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(
          text: fullText.substring(start, index),
          style: const TextStyle(color: Color(0xff707070)), // grey
        ));
      }

      spans.add(TextSpan(
        text: fullText.substring(index, index + query.length),
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600), // highlight
      ));

      start = index + query.length;
    }

    return TextSpan(
      children: spans,
      style: GoogleFonts.inter(fontSize: 14),
    );
  }

  Widget textItem(String title, Color color, double size, FontWeight weight) {
    return Text(title,
        style: GoogleFonts.poppins(
            decoration: TextDecoration.none,
            color: color,
            fontSize: size,
            fontWeight: weight));
  }

  Widget optionItem(
      double height, double width, String title, String img, Color color) {
    return ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(20),
        child: Container(
          color: Colors.white,
          height: height,
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Container(
                color: const Color(0xffFAFAFA),
                width: width,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.6,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          // Soft background circle or shape
                          Positioned(
                            top: -30,
                            left: -60,
                            bottom: 20,
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: color.withOpacity(
                                    title.contains('find') ? 1 : 0.14),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),

                          // Car image overlaid
                          Positioned(
                            top: 30,
                            left: 20,
                            child: Image.asset(
                              img,
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: textItem(
                                  title, Colors.black, 12, FontWeight.w500)),
                          const Spacer(),
                          Container(
                            width: 25,
                            height: 25,
                            decoration: const ShapeDecoration(
                              color: Colors.white, // Inside fill color
                              shape: CircleBorder(
                                side: BorderSide(
                                  color: Colors.black, // Border color
                                  width: 2, // Border width
                                ),
                              ),
                            ),
                            child: const Center(
                                child: Icon(
                              Icons.arrow_right_alt,
                              size: 16,
                            )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget circleItem(Color color) {
    return ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(16),
        child: Container(
          height: 100,
          width: 100,
          color: color,
        ));
  }
}
