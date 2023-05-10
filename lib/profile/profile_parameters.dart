import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Parameter extends StatelessWidget {
  final String imgUrl;
  final String scale;
  final double magnitude;
  final String unit;
  const Parameter(
      {super.key,
        required this.imgUrl,
        required this.magnitude,
        required this.scale,
        required this.unit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: 340,
        height: 100,
        decoration: BoxDecoration(
            color: const Color.fromARGB(47, 255, 255, 255),
            borderRadius: BorderRadius.circular(20)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(width: 20),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: Image.asset(imgUrl), //Enter Image Url here
            ),
            SizedBox(
              width: 130,
              child: Text(
                scale, //Enter the scale here
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    color: const Color(0xFF9678C8),
                    fontSize: 30,
                    fontWeight: FontWeight.w900),
              ),
            )
          ]),
          const SizedBox(width: 25),
          Text(
            '$magnitude', //Enter the magnitude here
            style: GoogleFonts.raleway(
                fontSize: 40, fontWeight: FontWeight.w800, color: Colors.black),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                unit, // Enter the unit here
                style: GoogleFonts.poppins(
                    fontSize: 17, fontWeight: FontWeight.w500),
              )
            ],
          )
        ]),
      ),
    );
  }
}
