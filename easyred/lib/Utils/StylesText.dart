

import 'dart:ui';

import 'package:snippet_coder_utils/hex_color.dart';

class StylesText {
  TextStyle titleP() {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: HexColor('A138C1')
    );
  
  }
  TextStyle subtitle() {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: HexColor('A138C1')
    );
  
  }

}