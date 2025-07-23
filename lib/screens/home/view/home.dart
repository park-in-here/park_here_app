// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'package:park_in_here/screens/home/controller/home_controller.dart';
import 'package:park_in_here/screens/home/model/search_loc_model.dart'
    hide Location;
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<LocData> filteredResults = [];
  List<String> addresses = [];
  bool showSuggestions = false;
  HomeController contrlr = Get.put(HomeController());
  LatLng? currentLocation;
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _getCurrentLocation();
  }

  double calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    ); // returns distance in meters
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locData = await location.getLocation();
    setState(() {
      currentLocation = LatLng(locData.latitude!, locData.longitude!);
    });
    mapController.move(currentLocation!, 12.0);
    log('Location fetched: ${locData.latitude}, ${locData.longitude}');
  }

  void _onSearchChanged() async {
    final query = _searchController.text.toLowerCase();
    await contrlr.getLocations(query);

    if (query.isEmpty) {
      setState(() {
        filteredResults.clear();
        showSuggestions = false;
      });
    } else {
      final results = contrlr.locations;
      final values = contrlr.addresses;
      setState(() {
        filteredResults = results;
        addresses = values;
        showSuggestions = true;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
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
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    controller.mapisLoading || controller.nearby.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xff3572EF),
                          ))
                        : FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              center: currentLocation ??
                                  LatLng(
                                      controller.nearby[0].location!.latitude!,
                                      controller
                                          .nearby[0].location!.longitude!),
                              zoom: 12.0,
                              interactiveFlags:
                                  InteractiveFlag.all & ~InteractiveFlag.rotate,
                            ),
                            children: [
                              TileLayer(
                                backgroundColor: Colors.white,
                                urlTemplate:
                                    'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.parkin.park_in_here',
                              ),
                              MarkerLayer(
                                markers: [
                                  if (currentLocation != null)
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

                                        if (lat == null || lng == null) {
                                          return null;
                                        }

                                        return Marker(
                                          width: 100,
                                          height: 100,
                                          point: LatLng(lat, lng),
                                          child: Column(
                                            children: [
                                              const Icon(Icons.location_on,
                                                  color: Colors.black,
                                                  size: 30),
                                              Container(
                                                height: 30,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color:
                                                            Color(0x3F000000),
                                                        blurRadius: 4,
                                                        offset: Offset(0, 4))
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${(currentLocation != null ? (calculateDistance(currentLocation!, LatLng(lat, lng)) / 1000).toStringAsFixed(2) : '?')} km',
                                                    style: GoogleFonts.inter(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              )
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

                    // Container(
                    //   decoration: const BoxDecoration(
                    //     image: DecorationImage(
                    //       fit: BoxFit.fill,
                    //       image: AssetImage('assets/images/map_bg.png'),
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      top: 10,
                      left: showSuggestions ? 22 : 12,
                      right: showSuggestions ? 21 : 12,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: showSuggestions ? w * 0.88 : w * 0.78,
                                height: 40,
                                child: SearchBar(
                                  controller: _searchController,
                                  hintText: 'Search your location here',
                                  textStyle: MaterialStateProperty.all(
                                    GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff707070),
                                    ),
                                  ),
                                  onChanged: (value) => _onSearchChanged(),
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.white),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: showSuggestions
                                          ? const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20))
                                          : BorderRadius.circular(20),
                                      // Border width
                                    ),
                                  ),
                                ),
                              ),
                              // const SizedBox(width: 8),
                              if (showSuggestions == false)
                                Image.asset(
                                  'assets/images/menu.png',
                                  height: 60,
                                  width: 50,
                                )
                            ],
                          ),
                          if (showSuggestions) _buildSuggestions(w, controller),
                        ],
                      ),
                    ),
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
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      'Select the vehicle that you want\n to park',
                                                      textAlign: TextAlign.left,
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
                                                  children:
                                                      List.generate(5, (index) {
                                                    return Container(
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
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 20.0),
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
                                                                  Colors.black,
                                                                  12,
                                                                  FontWeight
                                                                      .w500)
                                                            ],
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
                                    index == 0 ? 'Find Parking' : 'Rent Space',
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
          : ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: filteredResults.length,
              itemBuilder: (context, index) {
                var place = filteredResults[index];
                var address = addresses[index];
                final lati = place.location?.latitude;
                final lngi = place.location?.longitude;
                return ListTile(
                  title: Text.rich(
                    _highlightText(place.name!, _searchController.text),
                  ),
                  subtitle: Text(
                    address,
                    style: tStyle,
                  ),
                  trailing: Text(
                    '${(currentLocation != null ? (calculateDistance(currentLocation!, LatLng(lati!, lngi!)) / 1000).toStringAsFixed(2) : '...')} km',
                    style: tStyle.copyWith(color: Colors.black),
                  ),
                  // trailing: Text(
                  //   place['distance'],
                  //   style: tStyle,
                  // ),
                  onTap: () {
                    // Handle selection
                    _searchController.text = place.name!;
                    setState(() {
                      showSuggestions = false;
                    });
                  },
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
