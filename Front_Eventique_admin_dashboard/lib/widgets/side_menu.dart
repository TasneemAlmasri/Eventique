import 'package:eventique_admin_dashboard/color.dart';
import 'package:eventique_admin_dashboard/models/side_menu_model.dart';
import 'package:eventique_admin_dashboard/providers/admin_provider.dart';
import 'package:eventique_admin_dashboard/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  final Function(int) onMenuItemSelected;

  const SideMenu({Key? key, required this.onMenuItemSelected}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int selectedIndex = 0;
  bool _isLoading = false;

  Future<void> logout() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<AdminProvider>(context, listen: false).logout();
      Navigator.of(context).popAndPushNamed(LoginScreen.routeName);

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<MenuModel> _menuData = [
      const MenuModel(icon: Icons.bubble_chart, title: 'Business Overview'),
      const MenuModel(icon: Icons.people, title: 'Customers'),
      const MenuModel(icon: Icons.add_box, title: 'Add To App'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          // bottomRight: Radius.circular(10),
          // topRight: Radius.circular(10),
        ),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: onPrimary,
            offset: Offset(
              1.0,
              1.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'EvenTique',
            style: TextStyle(
              color: primary,
              fontFamily: 'IrishGrover',
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _menuData.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                      color: isSelected
                          ? secondary.withOpacity(0.6)
                          : Colors.transparent,
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        widget.onMenuItemSelected(index);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 13, vertical: 7),
                            child: Icon(
                              _menuData[index].icon,
                              color: isSelected ? primary : Colors.grey,
                            ),
                          ),
                          Text(
                            _menuData[index].title,
                            style: TextStyle(
                              fontFamily: 'CENSCBK',
                              fontSize: 16,
                              color: isSelected ? white : Colors.grey,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          _isLoading
              ? const CircularProgressIndicator(
                  color: primary,
                )
              : TextButton.icon(
                  onPressed: () => logout(),
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.grey,
                  ),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'CENSCBK',
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
