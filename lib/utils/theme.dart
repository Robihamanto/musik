import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musik/utils/theme_constant.dart';


ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: lightAppBarTheme(context),
    iconTheme: IconThemeData(color: kContentColorLightTheme),
    textTheme: Theme.of(context).textTheme.apply(bodyColor: kContentColorLightTheme, fontFamily: 'MPLUS1p'),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    splashColor: kTransparentColor,
    colorScheme: ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: kContentColorLightTheme,
      unselectedItemColor: kContentColorLightTheme.withOpacity(.5),
      selectedIconTheme: IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

ThemeData darkThemeData(BuildContext context) {
  // By default flutter provide us light and dark theme
  // we just modify it as our need
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: darkAppBarTheme(context),
    iconTheme: IconThemeData(color: kContentColorDarkTheme),
    textTheme: Theme.of(context).textTheme.apply(bodyColor: kContentColorDarkTheme),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    splashColor: kTransparentColor,
    colorScheme: ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: kContentColorDarkTheme,
      unselectedItemColor: kContentColorDarkTheme.withOpacity(0.5),
      selectedIconTheme: IconThemeData(color: kContentColorDarkTheme),
      showUnselectedLabels: true,
    ),
  );
}

AppBarTheme lightAppBarTheme(BuildContext context) => AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: kContentColorLightTheme),
    actionsIconTheme: IconThemeData(color: kContentColorLightTheme),
    titleTextStyle: TextStyle(color: kContentColorLightTheme, fontSize: 17, fontWeight: FontWeight.w500),
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
    elevation: 0
);

AppBarTheme darkAppBarTheme(BuildContext context) => AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: kContentColorDarkTheme),
    actionsIconTheme: IconThemeData(color: kContentColorDarkTheme),
    titleTextStyle: TextStyle(color: kContentColorDarkTheme, fontSize: 17, fontWeight: FontWeight.w500),
    systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
    elevation: 0
);