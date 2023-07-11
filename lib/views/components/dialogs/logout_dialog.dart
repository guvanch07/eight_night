import 'package:eight_night/views/components/constants/strings.dart';
import 'package:eight_night/views/components/dialogs/alert_dialog_model.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class LogoutDialog extends AlertDialogModel<bool> {
  const LogoutDialog()
      : super(
          title: Strings.logOut,
          message: Strings.areYouSureThatYouWantToLogOutOfTheApp,
          buttons: const {
            Strings.cancel: false,
            Strings.logOut: true,
          },
        );
}
