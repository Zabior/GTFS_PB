import 'dart:typed_data';

import 'package:gtfs_pb/gtfs_pb.dart';
import 'dart:io';

import 'package:gtfs_pb/proto/gtfs-realtime.pb.dart';

// Class for vehicles_position.pb etc. files.
class GtfsPbVehicle extends GtfsPb {
  // Insert your vehicle_position.pb file as an argument
  GtfsPbVehicle.fromFile(File file) : super.fromFile(file);

  // Insert Uint8List as an argument (ex. body bytes of response from http)
  GtfsPbVehicle.fromUint8List(Uint8List uint8list)
      : super.fromUint8List(uint8list);

  // Returns list with all vehicles data from vehicle_position.pb
  List<VehiclePosition> get allVehiclesData {
    List<VehiclePosition> vehicles = List();
    for (FeedEntity entity in message.entity) vehicles.add(entity.vehicle);
    return vehicles;
  }

  // Returns single vehicle data using search by tripId
  VehiclePosition getVehicleDataByTripId(String tripId) => message.entity
      .firstWhere((entity) => entity.vehicle.trip.tripId == tripId,
          orElse: () => null)
      .vehicle;

  // Returns list of vehicle data using search by routeId
  List<VehiclePosition> getVehiclesDataByRouteId(String routeId) {
    List<VehiclePosition> vehicles = List();
    for (FeedEntity entity in message.entity) {
      if (entity.vehicle.trip.routeId == routeId) vehicles.add(entity.vehicle);
    }
    return vehicles;
  }

  // Returns list of vehicle data of vehicles that are near the specified
  // location
  // Min and Max Longitude/Latitude create square of field of search
  List<VehiclePosition> getVehiclesDataNearLocation(double minLatitude,
      double maxLatitude, double minLongitude, double maxLongitude) {
    List<VehiclePosition> vehicles = List();
    for (FeedEntity entity in message.entity) {
      // If vehicle is in the square then it is added
      if (entity.vehicle.position.latitude >= minLatitude &&
          entity.vehicle.position.latitude <= maxLatitude &&
          entity.vehicle.position.longitude >= minLongitude &&
          entity.vehicle.position.longitude <= maxLongitude) {
        vehicles.add(entity.vehicle);
      }
    }
    return vehicles;
  }
}
