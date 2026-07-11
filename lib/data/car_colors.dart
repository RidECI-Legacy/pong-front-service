import 'package:flutter/material.dart';

enum CarColor { blue, white, gray, black, red, green }

class CarColorStyle {
  final String assetPath;
  final List<Color> gradient;
  final Color glow;
  final Color textOnCard;

  const CarColorStyle({
    required this.assetPath,
    required this.gradient,
    required this.glow,
    this.textOnCard = Colors.white,
  });
}

const Map<CarColor, CarColorStyle> carColorStyles = {
  CarColor.blue: CarColorStyle(
    assetPath: 'assets/cars/car_blue.png',
    gradient: [Color(0xFF4F7CFF), Color(0xFF2A4CC7)],
    glow: Color(0xFF4F7CFF),
  ),
  CarColor.white: CarColorStyle(
    assetPath: 'assets/cars/car_white.png',
    gradient: [Color(0xFFE7ECF5), Color(0xFFB9C3D6)],
    glow: Color(0xFFB9C3D6),
    textOnCard: Color(0xFF1B2440),
  ),
  CarColor.gray: CarColorStyle(
    assetPath: 'assets/cars/car_gray.png',
    gradient: [Color(0xFF7C8798), Color(0xFF454E60)],
    glow: Color(0xFF7C8798),
  ),
  CarColor.black: CarColorStyle(
    assetPath: 'assets/cars/car_black.png',
    gradient: [Color(0xFF3A3F4B), Color(0xFF12151C)],
    glow: Color(0xFF3A3F4B),
  ),
  CarColor.red: CarColorStyle(
    assetPath: 'assets/cars/car_red.png',
    gradient: [Color(0xFFE05B5B), Color(0xFF9B1F2E)],
    glow: Color(0xFFE05B5B),
  ),
  CarColor.green: CarColorStyle(
    assetPath: 'assets/cars/car_green.png',
    gradient: [Color(0xFF3FB08A), Color(0xFF1D6A52)],
    glow: Color(0xFF3FB08A),
  ),
};
