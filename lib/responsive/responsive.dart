import 'package:flutter/material.dart';
import 'package:instagram_app/Provider/user_provider.dart';
import 'package:instagram_app/utils/global_variables.dart';
import 'package:provider/provider.dart';

class Responsive extends StatefulWidget {
  const Responsive({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  @override
  State<Responsive> createState() => _ResponsiveState();
}

class _ResponsiveState extends State<Responsive> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async{
    UserProvider _userProvider = Provider.of(context, listen: false);
     await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > AppDimensions.webScreenSize) {
          // Web Screen
          return widget.webScreenLayout;
        }
        // Mobile Screen
        return widget.mobileScreenLayout;
      },
    );
  }
}
