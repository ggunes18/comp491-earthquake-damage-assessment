import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  static const String separator = '-';
  static const List<int> separatorPositions = [3, 6];
  static const int maxLength = 10;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > maxLength) {
      return oldValue; // Prevent exceeding the maximum length
    }

    final StringBuffer newText = StringBuffer();
    int separatorCount = 0;

    // Add the "5" at the beginning if it's missing
    if (newValue.text.isNotEmpty && newValue.text[0] != '5') {
      newText.write('5');
    }

    for (int i = 0; i < newValue.text.length; i++) {
      if (separatorPositions.contains(i)) {
        newText.write(separator);
        separatorCount++;
      }

      newText.write(newValue.text[i]);
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(
        offset: newValue.selection.end + separatorCount,
      ),
    );
  }
}
