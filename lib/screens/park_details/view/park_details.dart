// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:park_in_here/screens/park_details/model/park_detail_model.dart';
import 'package:park_in_here/screens/park_details/provider/park_provider.dart';

class ParkDetails extends ConsumerWidget {
  const ParkDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // bool isHours = true;
    // bool isSlotSelected = false;
    // bool timeOrHourSelected = false;
    // int? outerIndex;

    // int? innerIndex;
    final parkDetailsAsyncValue = ref.watch(parkingProvider);
    return Scaffold(
        backgroundColor: Colors.white,
        body: parkDetailsAsyncValue.when(
          data: (list) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gap(50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textItem(false, 'PARKING DETAIL', const Color(0xFF707070),
                          14, FontWeight.w500),
                      const Icon(Icons.bookmark_border)
                    ],
                  ),
                  gap(10),
                  listImages(list[0].attachments ?? []),
                  gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textItem(true, list[0].name!, const Color(0xFF192242), 16,
                          FontWeight.w700),
                      textItem(false, 'Avl : ${list[0].totalSlots} slot',
                          const Color(0xFF00A78F), 14, FontWeight.w500),
                    ],
                  ),
                  gap(20),
                  // wrapItems(false),
                  gap(20),
                  textItem(false, 'RULES', const Color(0xFF707070), 14,
                      FontWeight.w500),
                  textItem(
                      false,
                      'These rules and regulations for the use of Dummy University Parking Area. In these Rules, unless the context otherwise requires',
                      const Color(0xFF707070),
                      12,
                      FontWeight.w400),
                  gap(20),
                  // selection(),
                  gap(20),
                  // wrapItems(true),
                  gap(30),
                  Column(
                    children: [
                      const Text(
                        'Cancelling a booking will incur a ₹100 fee. You can’t book again until it’s paid.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(
                              0x8C808080) /* Miscellaneous-Alert-Menu-Action-Sheet---Separators */,
                          fontSize: 11,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.70,
                        ),
                      ),
                      gap(10),
                      // button(false)
                    ],
                  )
                ],
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text(err.toString())),
        ));
  }

  Widget listImages(List<Attachment> images) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.network(images[index].filePath ?? '');
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 10);
        },
      ),
    );
  }

  Widget gap(double h) {
    return SizedBox(height: h);
  }

  Widget textItem(
      bool isLato, String title, Color color, double size, FontWeight weight) {
    return Text(title,
        textAlign: TextAlign.justify,
        style: isLato
            ? GoogleFonts.lato(
                decoration: TextDecoration.none,
                color: color,
                fontSize: size,
                fontWeight: weight)
            : GoogleFonts.inter(
                decoration: TextDecoration.none,
                color: color,
                fontSize: size,
                fontWeight: weight));
  }

  // Widget timeSlots() {
  //   return Wrap(
  //       runSpacing: 4,
  //       children: List.generate(10, (index) {
  //         return Padding(
  //           padding: const EdgeInsets.all(3.0),
  //           child: GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 innerIndex = index;
  //               });
  //             },
  //             child: Container(
  //               height: 38,
  //               width: 80,
  //               // clipBehavior: Clip.antiAlias,
  //               decoration: ShapeDecoration(
  //                 color: Colors.white,
  //                 shape: RoundedRectangleBorder(
  //                   side: BorderSide(
  //                     width: 1,
  //                     color: innerIndex == index
  //                         ? const Color(0xff3572EF)
  //                         : const Color(0xFFC1C1C1),
  //                   ),
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //               ),
  //               child: Center(
  //                   child: textItem(
  //                       true,
  //                       '1pm - 2pm',
  //                       innerIndex == index
  //                           ? const Color(0xff3572EF)
  //                           : const Color(0xFF081024),
  //                       12,
  //                       FontWeight.w500)),
  //             ),
  //           ),
  //         );
  //       }));
  // }

  // Widget wrapItems(bool isdetail) {
  //   var w = MediaQuery.of(context).size.width;
  //   var h = MediaQuery.of(context).size.height;
  //   return Wrap(
  //       runSpacing: 4,
  //       children: List.generate(5, (index) {
  //         return Padding(
  //           padding: const EdgeInsets.all(3.0),
  //           child: isdetail == true
  //               ? GestureDetector(
  //                   onTap: () {
  //                     setState(() {
  //                       outerIndex = index;
  //                     });
  //                     showDialog(
  //                         context: context,
  //                         builder: (context) {
  //                           return Center(
  //                             child: Container(
  //                               height: h * 0.4,
  //                               width: w * 0.85,
  //                               decoration: ShapeDecoration(
  //                                 color: Colors.white,
  //                                 shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(6.92),
  //                                 ),
  //                               ),
  //                               child: Padding(
  //                                 padding: const EdgeInsets.only(
  //                                     left: 20.0, right: 12),
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     gap(10),
  //                                     Align(
  //                                       alignment: Alignment.topRight,
  //                                       child: Image.asset(
  //                                         'assets/images/close.png',
  //                                         height: 25,
  //                                         width: 25,
  //                                       ),
  //                                     ),
  //                                     textItem(
  //                                         false,
  //                                         'You picked for 1 hour',
  //                                         const Color(0xFF181818),
  //                                         16,
  //                                         FontWeight.w500),
  //                                     gap(10),
  //                                     timeSlots(),
  //                                     gap(15),
  //                                     button(true)
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           );
  //                         });
  //                   },
  //                   child: Container(
  //                     height: 38,
  //                     width: 100,
  //                     // clipBehavior: Clip.antiAlias,
  //                     decoration: ShapeDecoration(
  //                       color: outerIndex == index && isSlotSelected == true
  //                           ? const Color(0xff3572EF)
  //                           : Colors.white,
  //                       shape: RoundedRectangleBorder(
  //                         side: BorderSide(
  //                           width: 1,
  //                           color: outerIndex == index && isSlotSelected == true
  //                               ? const Color(0xff3572EF)
  //                               : const Color(0xFFC1C1C1),
  //                         ),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                     ),
  //                     child: Center(
  //                         child: textItem(
  //                             true,
  //                             isHours == true ? '₹ 300/ 1hr' : '₹ 500/ 1 D',
  //                             outerIndex == index && isSlotSelected == true
  //                                 ? Colors.white
  //                                 : const Color(0xFF081024),
  //                             12,
  //                             FontWeight.w500)),
  //                   ),
  //                 )
  //               : Container(
  //                   height: 30,
  //                   width: 100,
  //                   // clipBehavior: Clip.antiAlias,
  //                   decoration: ShapeDecoration(
  //                     color: const Color(0x14707070),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                   ),
  //                   child: Center(
  //                     child: Row(
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Image.asset(
  //                           'assets/images/Group.png',
  //                           height: 20,
  //                           width: 20,
  //                         ),
  //                         textItem(true, ' 1.0 km', const Color(0xFF081024), 12,
  //                             FontWeight.w500)
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //         );
  //       }));
  // }

  // Widget selection() {
  //   var w = MediaQuery.of(context).size.width;
  //   return Container(
  //       width: double.infinity,
  //       height: 40,
  //       padding: const EdgeInsets.all(4),
  //       decoration: ShapeDecoration(
  //         color: const Color(0x14707070).withOpacity(0.05),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(9999),
  //         ),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //           GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 isHours = true;
  //               });
  //             },
  //             child: Container(
  //               width: w * 0.42,
  //               decoration: ShapeDecoration(
  //                 color: isHours == true ? Colors.white : Colors.transparent,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(9999),
  //                 ),
  //               ),
  //               padding: const EdgeInsets.all(6),
  //               child: Center(
  //                 child: textItem(
  //                     true,
  //                     'One time',
  //                     isHours == true
  //                         ? const Color(0xFF1E293B)
  //                         : const Color(0xFF475569),
  //                     14,
  //                     FontWeight.w700),
  //               ),
  //             ),
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 isHours = false;
  //               });
  //             },
  //             child: Container(
  //               width: w * 0.42,
  //               decoration: ShapeDecoration(
  //                 color: isHours == false ? Colors.white : Colors.transparent,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(9999),
  //                 ),
  //               ),
  //               padding: const EdgeInsets.all(6),
  //               child: Center(
  //                 child: textItem(
  //                     false,
  //                     'Few days',
  //                     isHours == false
  //                         ? const Color(0xFF1E293B)
  //                         : const Color(0xFF475569),
  //                     14,
  //                     FontWeight.w500),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ));
  // }

  // Widget button(bool slot) {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         isSlotSelected = true;
  //       });
  //       Get.back();
  //     },
  //     child: Container(
  //       // width: 355,
  //       height: slot == false ? 50 : 40,
  //       decoration: ShapeDecoration(
  //         color: const Color.fromARGB(255, 102, 137, 242),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(27.50),
  //         ),
  //       ),
  //       child: Center(
  //         child: textItem(
  //             true,
  //             slot == true
  //                 ? 'Select time slot 1pm - 2pm'
  //                 : 'Book Parking & View details',
  //             Colors.white,
  //             16,
  //             FontWeight.w700),
  //       ),
  //     ),
  //   );
  // }
}
