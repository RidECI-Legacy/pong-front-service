import 'package:flutter/material.dart';

/// One destination in a role's sidebar / bottom nav — shared shape used by
/// the passenger, driver and admin shells so navigation always looks and
/// behaves the same way regardless of role.
class RoleNavItem {
  final IconData icon;
  final String label;

  const RoleNavItem(this.icon, this.label);
}
