String formatPhoneNumber(String phoneNumber) {
  // Remove any non-digit characters from the phone number
  String cleanedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

  // Check if the cleaned number starts with '0' and has 10 digits
  if (cleanedNumber.startsWith('0') && cleanedNumber.length == 10) {
    // Replace the '0' with '+66' and return the formatted number
    return '+66${cleanedNumber.substring(1)}';
  } else {
    // Return the original phone number if it does not match the expected format
    return phoneNumber;
  }
}
