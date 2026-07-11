import 'package:flutter/material.dart';

import 'car_colors.dart';
import 'models.dart';

class MockData {
  MockData._();

  static const impactStatsHero = [
    ImpactStat(value: '412+', label: 'Estudiantes activos'),
    ImpactStat(value: '1.2k', label: 'Viajes compartidos'),
    ImpactStat(value: '5.4t', label: 'CO2 ahorradas'),
  ];

  static const howItWorks = [
    HowItWorksStep(
      number: 1,
      title: 'Regístrate con tu correo',
      description:
          'Usa tu correo @escuelaing.edu.co o @mail.escuelaing.edu.co para validar tu identidad institucional.',
    ),
    HowItWorksStep(
      number: 2,
      title: 'Publica o busca un viaje',
      description:
          'Los conductores publican cupos y horarios; los pasajeros buscan por destino y hora.',
    ),
    HowItWorksStep(
      number: 3,
      title: 'Viaja y comparte gastos',
      description:
          'Confirma tu cupo, paga con Nequi, Daviplata o efectivo y califica al finalizar.',
    ),
  ];

  static const communityRoles = [
    CommunityRole(
      title: 'Pasajero',
      description:
          'Busca viajes disponibles, reserva cupos y paga de forma segura.',
    ),
    CommunityRole(
      title: 'Conductor',
      description: 'Publica viajes, gestiona pasajeros y controla tus cupos.',
    ),
    CommunityRole(
      title: 'Acompañante',
      description: 'Se une a un viaje ya reservado por otro estudiante.',
    ),
    CommunityRole(
      title: 'Profesor',
      description:
          'Accede a viajes con horarios y validaciones institucionales.',
    ),
  ];

  static const impactStatsFooter = [
    ImpactStat(value: '5.4t', label: 'CO2 ahorradas este semestre'),
    ImpactStat(value: '1,203', label: 'Viajes compartidos'),
    ImpactStat(value: '68%', label: 'Participación estudiantil'),
    ImpactStat(value: '412+', label: 'Usuarios verificados'),
  ];

  static const riderProfile = RiderProfile(
    name: 'María Camacho',
    faculty: 'Pasajera · Facultad de Ingeniería Industrial',
    rating: 4.9,
    trips: 32,
    co2Kg: 18,
    savedCop: 142000,
  );

  static const activeTrip = ActiveTrip(
    driverName: 'Camilo Rojas',
    car: 'Chevrolet Spark · Gris',
    carColor: CarColor.gray,
    etaMinutes: 6,
    status: 'Cupo confirmado',
  );

  static const availableTrips = [
    TripOffer(
      driverName: 'Camilo Rojas',
      rating: 4.8,
      car: 'Chevrolet Spark',
      carColor: CarColor.gray,
      origin: 'Portal 80',
      destination: 'Escuela Ing. Julio Garavito',
      time: '6:40 AM',
      seats: 2,
      price: 4500,
    ),
    TripOffer(
      driverName: 'Valentina Ruiz',
      rating: 4.6,
      car: 'Renault Sandero',
      carColor: CarColor.blue,
      origin: 'Suba, Calle 145',
      destination: 'Escuela Ing. Julio Garavito',
      time: '6:55 AM',
      seats: 1,
      price: 5000,
    ),
    TripOffer(
      driverName: 'Andrés Peña',
      rating: 4.9,
      car: 'Kia Picanto',
      carColor: CarColor.red,
      origin: 'Chapinero Alto',
      destination: 'Escuela Ing. Julio Garavito',
      time: '7:10 AM',
      seats: 3,
      price: 4000,
    ),
  ];

  static const driverStats = DriverStats(
    tripsCompleted: 87,
    rating: 4.8,
    co2Kg: 312,
    earningsCop: 980000,
  );

  static const confirmedPassengers = [
    ConfirmedPassenger(
      name: 'Laura Gómez',
      pickup: 'Portal 80',
      status: 'Confirmado',
    ),
    ConfirmedPassenger(
      name: 'Nicolás Reyes',
      pickup: 'Calle 80 con 68',
      status: 'Confirmado',
    ),
    ConfirmedPassenger(
      name: 'Sara Molina',
      pickup: 'Av. Boyacá',
      status: 'Pendiente',
    ),
  ];

  static const driverHistory = [
    HistoryItem(route: 'Portal 80 → Escuela', date: 'Lun 30 jun', amount: 13500),
    HistoryItem(route: 'Suba → Escuela', date: 'Vie 27 jun', amount: 10000),
    HistoryItem(route: 'Calle 80 → Escuela', date: 'Jue 26 jun', amount: 9000),
  ];

  static const passengerHistory = [
    HistoryItem(route: 'Portal 80 → Escuela', date: 'Hoy · 6:40 AM', amount: 4500),
    HistoryItem(route: 'Suba, Calle 145 → Escuela', date: 'Vie 27 jun', amount: 5000),
    HistoryItem(route: 'Chapinero Alto → Escuela', date: 'Jue 26 jun', amount: 4000),
    HistoryItem(route: 'Portal 80 → Escuela', date: 'Mié 25 jun', amount: 4500),
  ];

  static const validationRequests = [
    ValidationRequest(
      name: 'Julián Torres',
      requestedRole: 'Conductor',
      email: 'julian.torres@mail.escuelaing.edu.co',
      maskedId: '1032xxxxx4',
    ),
    ValidationRequest(
      name: 'Karol Estupiñán',
      requestedRole: 'Pasajero',
      email: 'karol.estupinan@mail.escuelaing.edu.co',
      maskedId: '1019xxxxx8',
    ),
    ValidationRequest(
      name: 'Sergio Idárraga',
      requestedRole: 'Acompañante',
      email: 'sergio.idarraga@mail.escuelaing.edu.co',
      maskedId: '1030xxxxx2',
    ),
    ValidationRequest(
      name: 'Daniel Patiño',
      requestedRole: 'Conductor',
      email: 'daniel.patino@escuelaing.edu.co',
      maskedId: '1015xxxxx7',
    ),
  ];

  static const notifications = [
    NotificationItem(
      title: 'Tu conductor está en camino',
      subtitle: 'Camilo Rojas llega en 6 min a Portal 80.',
      time: 'Hace 2 min',
      unread: true,
    ),
    NotificationItem(
      title: 'Nuevo viaje cerca de ti',
      subtitle: 'Valentina Ruiz publicó un viaje a las 6:55 AM.',
      time: 'Hace 18 min',
      unread: true,
    ),
    NotificationItem(
      title: 'Calificación recibida',
      subtitle: 'Recibiste 5★ de tu último viaje. ¡Sigue así!',
      time: 'Ayer',
      unread: true,
    ),
    NotificationItem(
      title: 'Cuenta verificada',
      subtitle: 'La institución aprobó tu solicitud de rol.',
      time: 'Hace 2 días',
    ),
  ];

  static const activeAdminTrips = [
    ActiveAdminTrip(
      driverName: 'Camilo Rojas',
      route: 'Portal 80 → Escuela Ing. Julio Garavito',
      time: '6:34 AM',
      seatsFilled: 3,
      seatsTotal: 4,
      status: 'En curso',
    ),
    ActiveAdminTrip(
      driverName: 'Valentina Ruiz',
      route: 'Suba, Calle 145 → Escuela Ing. Julio Garavito',
      time: '6:55 AM',
      seatsFilled: 2,
      seatsTotal: 4,
      status: 'Por iniciar',
    ),
    ActiveAdminTrip(
      driverName: 'Andrés Peña',
      route: 'Chapinero Alto → Escuela Ing. Julio Garavito',
      time: '7:10 AM',
      seatsFilled: 4,
      seatsTotal: 4,
      status: 'En curso',
    ),
  ];

  static final securityReports = [
    SecurityReport(
      reportedUser: 'Andrés Peña',
      type: 'Comportamiento',
      description: 'El conductor cambió la ruta sin avisar a los pasajeros.',
      date: 'Hoy · 7:32 AM',
      status: 'Pendiente',
    ),
    SecurityReport(
      reportedUser: 'Laura Gómez',
      type: 'Ausencia',
      description: 'La pasajera no se presentó en el punto de encuentro.',
      date: 'Ayer · 6:50 AM',
      status: 'En revisión',
    ),
    SecurityReport(
      reportedUser: 'Nicolás Reyes',
      type: 'Seguridad',
      description: 'Reporte de exceso de velocidad durante el trayecto.',
      date: 'Lun 30 jun',
      status: 'Resuelto',
    ),
  ];

  // --- Módulo 6: vehículo, distintivos y reputación ---

  static const driverVehicle = VehicleInfo(
    brand: 'Chevrolet',
    model: 'Spark GT',
    carColor: CarColor.gray,
    plate: 'ABC-123',
    capacity: 4,
    licenseExpiry: '14/03/2027',
  );

  static const driverDistintivos = [
    Distintivo(icon: Icons.emoji_events_outlined, label: 'Conductor confiable', description: 'Más de 50 viajes con calificación superior a 4.5.'),
    Distintivo(icon: Icons.bolt_outlined, label: 'Puntual', description: 'Inicia sus viajes a tiempo el 95% de las veces.'),
    Distintivo(icon: Icons.eco_outlined, label: 'Eco conductor', description: 'Ha ahorrado más de 300kg de CO2 compartiendo viajes.'),
  ];

  static const passengerDistintivos = [
    Distintivo(icon: Icons.favorite_outline, label: 'Pasajero frecuente', description: 'Más de 25 viajes reservados en el semestre.'),
    Distintivo(icon: Icons.emoji_emotions_outlined, label: 'Amigable', description: 'Buenos comentarios de conductores en tus viajes.'),
    Distintivo(icon: Icons.eco_outlined, label: 'Huella verde', description: 'Ahorraste 18kg de CO2 este semestre.'),
  ];

  static const emergencyContact = EmergencyContact(
    name: 'Camila Camacho',
    relation: 'Hermana',
    phone: '+57 300 123 4567',
  );

  static const co2ByMonthPassenger = [
    Co2MonthPoint(label: 'Mar', kg: 2.4),
    Co2MonthPoint(label: 'Abr', kg: 3.1),
    Co2MonthPoint(label: 'May', kg: 4.6),
    Co2MonthPoint(label: 'Jun', kg: 4.0),
    Co2MonthPoint(label: 'Jul', kg: 3.9),
  ];

  static const co2ByMonthDriver = [
    Co2MonthPoint(label: 'Mar', kg: 38),
    Co2MonthPoint(label: 'Abr', kg: 52),
    Co2MonthPoint(label: 'May', kg: 71),
    Co2MonthPoint(label: 'Jun', kg: 76),
    Co2MonthPoint(label: 'Jul', kg: 75),
  ];

  static final myFiledReports = [
    SecurityReport(
      reportedUser: 'Andrés Peña',
      type: 'Comportamiento',
      description: 'Reporté un cambio de ruta sin aviso previo.',
      date: 'Hoy · 7:40 AM',
      status: 'En revisión',
    ),
  ];

  static final reportsAboutMe = <SecurityReport>[];

  // --- Módulo 7: directorio institucional ---

  static const userDirectory = [
    UserDirectoryEntry(name: 'Camilo Rojas', email: 'camilo.rojas@mail.escuelaing.edu.co', role: 'Conductor', status: 'Activo', rating: 4.8, trips: 87),
    UserDirectoryEntry(name: 'María Camacho', email: 'maria.camacho@mail.escuelaing.edu.co', role: 'Pasajero', status: 'Activo', rating: 4.9, trips: 32),
    UserDirectoryEntry(name: 'Valentina Ruiz', email: 'valentina.ruiz@escuelaing.edu.co', role: 'Conductor', status: 'Activo', rating: 4.6, trips: 54),
    UserDirectoryEntry(name: 'Andrés Peña', email: 'andres.pena@mail.escuelaing.edu.co', role: 'Conductor', status: 'Suspendido', rating: 4.1, trips: 19),
    UserDirectoryEntry(name: 'Sara Molina', email: 'sara.molina@mail.escuelaing.edu.co', role: 'Acompañante', status: 'Activo', rating: 4.7, trips: 11),
    UserDirectoryEntry(name: 'Nicolás Reyes', email: 'nicolas.reyes@escuelaing.edu.co', role: 'Pasajero', status: 'Pendiente', rating: 0, trips: 0),
  ];
}
