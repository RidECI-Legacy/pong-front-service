import 'package:flutter/material.dart';

import 'car_colors.dart';

class TripOffer {
  final String driverName;
  final double rating;
  final String car;
  final CarColor carColor;
  final String origin;
  final String destination;
  final String time;
  final int seats;
  final int price;

  const TripOffer({
    required this.driverName,
    required this.rating,
    required this.car,
    required this.carColor,
    required this.origin,
    required this.destination,
    required this.time,
    required this.seats,
    required this.price,
  });
}

class ActiveTrip {
  final String driverName;
  final String car;
  final CarColor carColor;
  final int etaMinutes;
  final String status;

  const ActiveTrip({
    required this.driverName,
    required this.car,
    required this.carColor,
    required this.etaMinutes,
    required this.status,
  });
}

class RiderProfile {
  final String name;
  final String faculty;
  final double rating;
  final int trips;
  final int co2Kg;
  final int savedCop;

  const RiderProfile({
    required this.name,
    required this.faculty,
    required this.rating,
    required this.trips,
    required this.co2Kg,
    required this.savedCop,
  });
}

class ConfirmedPassenger {
  final String name;
  final String pickup;
  final String status;

  const ConfirmedPassenger({
    required this.name,
    required this.pickup,
    required this.status,
  });
}

class DriverStats {
  final int tripsCompleted;
  final double rating;
  final int co2Kg;
  final int earningsCop;

  const DriverStats({
    required this.tripsCompleted,
    required this.rating,
    required this.co2Kg,
    required this.earningsCop,
  });
}

class HistoryItem {
  final String route;
  final String date;
  final int amount;

  const HistoryItem({
    required this.route,
    required this.date,
    required this.amount,
  });
}

class ValidationRequest {
  final String name;
  final String requestedRole;
  final String email;
  final String maskedId;

  const ValidationRequest({
    required this.name,
    required this.requestedRole,
    required this.email,
    required this.maskedId,
  });
}

class ImpactStat {
  final String value;
  final String label;

  const ImpactStat({required this.value, required this.label});
}

class HowItWorksStep {
  final int number;
  final String title;
  final String description;

  const HowItWorksStep({
    required this.number,
    required this.title,
    required this.description,
  });
}

class CommunityRole {
  final String title;
  final String description;

  const CommunityRole({required this.title, required this.description});
}

class NotificationItem {
  final String title;
  final String subtitle;
  final String time;
  final bool unread;

  const NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    this.unread = false,
  });
}

class ActiveAdminTrip {
  final String driverName;
  final String route;
  final String time;
  final int seatsFilled;
  final int seatsTotal;
  final String status;

  const ActiveAdminTrip({
    required this.driverName,
    required this.route,
    required this.time,
    required this.seatsFilled,
    required this.seatsTotal,
    required this.status,
  });
}

class SecurityReport {
  final String reportedUser;
  final String type;
  final String description;
  final String date;
  String status;

  SecurityReport({
    required this.reportedUser,
    required this.type,
    required this.description,
    required this.date,
    this.status = 'Pendiente',
  });
}

class VehicleInfo {
  final String brand;
  final String model;
  final CarColor carColor;
  final String plate;
  final int capacity;
  final String licenseExpiry;
  final bool verified;

  const VehicleInfo({
    required this.brand,
    required this.model,
    required this.carColor,
    required this.plate,
    required this.capacity,
    required this.licenseExpiry,
    this.verified = true,
  });
}

class Distintivo {
  final IconData icon;
  final String label;
  final String description;
  final bool achieved;

  const Distintivo({
    required this.icon,
    required this.label,
    required this.description,
    this.achieved = true,
  });
}

class EmergencyContact {
  final String name;
  final String relation;
  final String phone;

  const EmergencyContact({
    required this.name,
    required this.relation,
    required this.phone,
  });
}

class Co2MonthPoint {
  final String label;
  final double kg;

  const Co2MonthPoint({required this.label, required this.kg});
}

class UserDirectoryEntry {
  final String name;
  final String email;
  final String role;
  final String status;
  final double rating;
  final int trips;

  const UserDirectoryEntry({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.rating,
    required this.trips,
  });
}
