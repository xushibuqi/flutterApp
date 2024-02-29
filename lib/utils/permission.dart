import 'dart:collection';

import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
// 获取位置权限
Future<void> requestLocationPermission() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
}

// 获取位置信息的方法
Future<Map<String, String>> getLocationInformation() async {

  Map<String, String> locationInfo = HashMap();
  await requestLocationPermission();
  try {
    Location location = Location();
    LocationData locationData = await location.getLocation();
    locationInfo["lat"] = locationData.latitude.toString();
    locationInfo["long"] = locationData.longitude.toString();
  } catch (e) {
    print(e);
  }
  return locationInfo;
}
