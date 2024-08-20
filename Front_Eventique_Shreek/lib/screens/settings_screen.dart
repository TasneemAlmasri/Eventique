//taghreed
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/theme_provider.dart';
import '/color.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings-screen';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

List<String> language = ['English', 'Arabic'];

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notification = false;
  String _language = language[0];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    var sysBrightness = MediaQuery.of(context).platformBrightness;
    ThemeMode? themeMode = themeProvider.getThemeMode();
    bool isLight = themeMode == ThemeMode.light ||
        (sysBrightness == Brightness.light && themeMode != ThemeMode.dark);
    var style = TextStyle(
      color: isLight ? primary : white,
      fontSize: 18,
      fontFamily: 'CENSCBK',
    );
    return Scaffold(
      backgroundColor: isLight ? white : darkBackground,
      appBar: AppBar(
        backgroundColor: isLight ? white : darkBackground,
        shape: Border(
          bottom: BorderSide(
            color: isLight ? primary : white,
            width: 1.6,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'Settings',
            style: TextStyle(
              color: isLight ? primary : white,
              fontSize: 24,
              fontFamily: 'IrishGrover',
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(size.width * 0.03),
                  child: Text(
                    'App settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'CENSCBK',
                      color: isLight ? onPrimary : darkOnPrimary,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(size.width * 0.02),
                  height: size.width * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isLight ? white : darkBackground,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(
                          1.0,
                          1.0,
                        ),
                        blurRadius: 2.0,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: ListTile(
                      leading: const Icon(Icons.language_rounded),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      iconColor: primary,
                      title: Text(
                        'Language',
                        style: style,
                      ),
                      subtitle: _language == language[0]
                          ? const Text('English(US)')
                          : const Text('العربية'),
                      onTap: () {
                        _showLanguageBottomSheet(size, context, isLight);
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(size.width * 0.02),
                  height: size.width * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isLight ? white : Colors.grey,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(
                          1.0,
                          1.0,
                        ),
                        blurRadius: 2.0,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: ListTile(
                      title: Text(
                        'Theme',
                        style: style,
                      ),
                      leading: Icon(
                        isLight
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: primary,
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      subtitle: Text(themeMode == ThemeMode.system
                          ? 'System Default'
                          : themeMode == ThemeMode.light
                              ? 'Light'
                              : 'Dark'),
                      onTap: () {
                        _showThemeBottomSheet(
                            size, context, themeProvider, themeMode, isLight);
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(size.width * 0.02),
                  height: size.width * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isLight ? white : Colors.grey,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(
                          1.0,
                          1.0,
                        ),
                        blurRadius: 2.0,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SwitchListTile(
                      value: _notification,
                      dense: true,
                      inactiveThumbColor: Colors.grey,
                      activeColor: white,
                      inactiveTrackColor: white,
                      activeTrackColor: primary.withOpacity(0.8),
                      onChanged: (value) {
                        setState(() {
                          _notification = value;
                        });
                      },
                      title: Text(
                        'Notifications',
                        style: style,
                      ),
                      subtitle:
                          _notification ? const Text('On') : const Text('Off'),
                      secondary: Icon(
                        _notification
                            ? Icons.notifications_active
                            : Icons.notifications_off,
                        color: primary,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(size.width * 0.03),
                  child: Text(
                    'Contact us',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'CENSCBK',
                      color: isLight ? onPrimary : darkOnPrimary,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(size.width * 0.02),
                  height: size.width * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isLight ? white : Colors.grey,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(
                          1.0,
                          1.0,
                        ),
                        blurRadius: 2.0,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: ListTile(
                      dense: true,
                      leading: const Icon(Icons.help_rounded),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      iconColor: primary,
                      title: Text(
                        'Help',
                        style: style,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'EvenTique',
                style: TextStyle(
                  color: isLight ? primary : white,
                  fontSize: 40,
                  fontFamily: 'IrishGrover',
                  letterSpacing: 2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> _showLanguageBottomSheet(
      Size size, BuildContext context, bool isLight) {
    return showModalBottomSheet(
      backgroundColor: isLight ? white : Colors.grey,
      constraints: BoxConstraints(maxHeight: size.height * 0.35),
      context: context,
      isDismissible: true,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RadioListTile<String>(
              title: const Text(
                'English',
                style: TextStyle(color: primary),
              ),
              activeColor: primary,
              value: language[0],
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text(
                'العربية',
                style: TextStyle(color: primary),
              ),
              activeColor: primary,
              value: language[1],
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _showThemeBottomSheet(Size size, BuildContext context,
      ThemeProvider themeProvider, ThemeMode? themeMode, bool isLight) {
    return showModalBottomSheet(
      backgroundColor: isLight ? white : Colors.grey,
      constraints: BoxConstraints(maxHeight: size.height * 0.35),
      context: context,
      isDismissible: true,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RadioListTile<ThemeMode>(
              title: const Text(
                'System Default',
                style: TextStyle(color: primary),
              ),
              activeColor: primary,
              value: ThemeMode.system,
              groupValue: themeMode,
              onChanged: (value) {
                setState(() {
                  themeProvider.setSystemMode();
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text(
                'Light',
                style: TextStyle(color: primary),
              ),
              activeColor: primary,
              value: ThemeMode.light,
              groupValue: themeMode,
              onChanged: (value) {
                setState(() {
                  themeProvider.setLightMode();
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text(
                'Dark',
                style: TextStyle(color: primary),
              ),
              activeColor: primary,
              value: ThemeMode.dark,
              groupValue: themeMode,
              onChanged: (value) {
                setState(() {
                  themeProvider.setDarkMode();
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
