
import 'package:shared_preferences/shared_preferences.dart';


String ipAddress = sharedPrefs.ipAddress;


class SharedPrefs {
  static SharedPreferences? _sharedPrefs;
  init() async {
  
      _sharedPrefs = await SharedPreferences.getInstance();
  }
String get ipAddress => _sharedPrefs?.getString('ip_address')?? "";

set ipAddress(String value)=> _sharedPrefs?.setString('ip_address', value);
}

final sharedPrefs = SharedPrefs();