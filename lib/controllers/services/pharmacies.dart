import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PharmaciesController {
  static openGoogleMaps(String lat, String long) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/pharmacy/@${lat},${long},15z/data=!3m1!4b1?entry=ttu');
    if (!await launchUrl(url)) {
      Get.snackbar('Error', 'Could not open Google Maps');
    }
  }
}
