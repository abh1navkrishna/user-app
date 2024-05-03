
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  const AppText({super.key,
  required this.text,
    required this.size,
    required this.weight,
    required this.textcolor,

  });
  final String text;
  final FontWeight weight;
  final double size;
  final Color textcolor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,style: GoogleFonts.poppins(
      fontSize: size,fontWeight: weight,color: textcolor
    ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}
