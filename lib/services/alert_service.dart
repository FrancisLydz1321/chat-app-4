import 'package:chat_app/services/navigation_service.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AlertService {
  final GetIt _getIt = GetIt.instance;

  late NavigationService _navigationService; // creating variable

  AlertService() {
    _navigationService = _getIt.get<NavigationService>(); // _ means private
  }

  void showToast({required String text, IconData icon = Icons.info}) {
    try {
      // quering; Delightful toast
      DelightToastBar(
        autoDismiss: true,
        position: DelightSnackbarPosition.top,
        builder: (context) {
          return ToastCard(
            leading: Icon(icon, size: 28),
            title: Text(text),
          );
        },
      ).show(_navigationService.navigatorKey!.currentContext!);
    } catch (e) {
      print(e);
    }
  }
}
