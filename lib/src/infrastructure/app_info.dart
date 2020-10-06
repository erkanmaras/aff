import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

class AppInfo {
  static Map<String, dynamic> _deviceInfo;
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    _deviceInfo ??= await _getDeviceInfo();
    return _deviceInfo;
  }

  static Map<String, dynamic> _appInfo;
  static Future<Map<String, dynamic>> getAppInfo() async {
    _appInfo ??= await _getAppInfo();
    return _appInfo;
  }

  static Future<bool> get isAndroidQOrLater async {
    if (Platform.isAndroid) {
      var deviceInfo = DeviceInfoPlugin();
      return (await deviceInfo.androidInfo).version.sdkInt >= 29;
    }
    return false;
  }

  static Future<Map<String, dynamic>> _getDeviceInfo() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      return _getAndroidDeviceInfo(await deviceInfo.androidInfo);
    } else {
      return _getIosDeviceInfo(await deviceInfo.iosInfo);
    }
  }

  static Map<String, dynamic> _getAndroidDeviceInfo(AndroidDeviceInfo androidDeviceInfo) {
    var deviceInfo = <String, dynamic>{};
    deviceInfo['id'] = androidDeviceInfo.id;
    deviceInfo['androidId'] = androidDeviceInfo.androidId;
    deviceInfo['brand'] = androidDeviceInfo.brand;
    deviceInfo['device'] = androidDeviceInfo.device;
    deviceInfo['display'] = androidDeviceInfo.display;
    deviceInfo['hardware'] = androidDeviceInfo.hardware;
    deviceInfo['isPsychicalDevice'] = androidDeviceInfo.isPhysicalDevice;
    deviceInfo['manufacturer'] = androidDeviceInfo.manufacturer;
    deviceInfo['model'] = androidDeviceInfo.model;
    deviceInfo['product'] = androidDeviceInfo.product;
    deviceInfo['type'] = androidDeviceInfo.type;
    deviceInfo['supportedAbis'] = androidDeviceInfo.supportedAbis.join(',');
    deviceInfo['systemFeatures'] = androidDeviceInfo.systemFeatures.join(',');
    deviceInfo['versionBaseOs'] = androidDeviceInfo.version.baseOS;
    deviceInfo['versionCodename'] = androidDeviceInfo.version.codename;
    deviceInfo['versionIncremental'] = androidDeviceInfo.version.incremental;
    deviceInfo['versionRelase'] = androidDeviceInfo.version.release;
    deviceInfo['versionSdk'] = androidDeviceInfo.version.sdkInt;
    deviceInfo['versionSecurityPatch'] = androidDeviceInfo.version.securityPatch;
    return deviceInfo;
  }

  static Map<String, dynamic> _getIosDeviceInfo(IosDeviceInfo iosInfo) {
    var deviceInfo = <String, dynamic>{};
    deviceInfo['model'] = iosInfo.model;
    deviceInfo['isPsychicalDevice'] = iosInfo.isPhysicalDevice;
    deviceInfo['name'] = iosInfo.name;
    deviceInfo['identifierForVendor'] = iosInfo.identifierForVendor;
    deviceInfo['localizedModel'] = iosInfo.localizedModel;
    deviceInfo['systemName'] = iosInfo.systemName;
    deviceInfo['utsnameVersion'] = iosInfo.utsname.version;
    deviceInfo['utsnameRelease'] = iosInfo.utsname.release;
    deviceInfo['utsnameMachine'] = iosInfo.utsname.machine;
    deviceInfo['utsnameNodename'] = iosInfo.utsname.nodename;
    deviceInfo['utsnameSysname'] = iosInfo.utsname.sysname;
    return deviceInfo;
  }

  static Future<Map<String, dynamic>> _getAppInfo() async {
    var appInfo = <String, dynamic>{};
    var packageInfo = await PackageInfo.fromPlatform();
    appInfo['version'] = packageInfo.version;
    appInfo['appName'] = packageInfo.appName;
    appInfo['buildNumber'] = packageInfo.buildNumber;
    appInfo['packageName'] = packageInfo.packageName;
    appInfo['environment'] = kReleaseMode ? 'release' : 'debug';
    return appInfo;
  }
}
