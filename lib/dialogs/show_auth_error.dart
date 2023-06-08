import 'package:flutter/material.dart' show BuildContext;

import '../auth/auth_error.dart';
import 'generic_dialog.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogContent,
    optionsBuilder: () => {
      'OK': true,
    },
  );
}
