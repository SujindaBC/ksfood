// This formatter will format the phone number as the user types to 0XX-XXX-XXXX
import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Get the current text in the field
    String newText = newValue.text;

    // If the new text is empty, return the new value
    if (newText.isEmpty) {
      return newValue;
    }

    // If the new text is longer than the old text, the user is typing
    if (newText.length > oldValue.text.length) {
      // If the new text is 3 characters long, add a dash to the end
      if (newText.length == 3) {
        newText += '-';
      }
      // If the new text is 7 characters long, add a dash to the end
      if (newText.length == 7) {
        newText += '-';
      }
    }

    // Return the new value
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
