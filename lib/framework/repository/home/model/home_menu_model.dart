import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';

class DrawerMenuModel {
  final String menuName;
  final String? strIcon;
  bool isExpanded;
  final ScreenName? screenName;
  final ScreenName? parentScreen;
  Widget screen;
  final List<String>? dropDownList;
  NavigationStackItem item;

  DrawerMenuModel({
    required this.menuName,
    this.strIcon,
    this.screenName,
    this.parentScreen,
    this.isExpanded = false,
    this.dropDownList,
    required this.item,
    required this.screen,
  });
}
