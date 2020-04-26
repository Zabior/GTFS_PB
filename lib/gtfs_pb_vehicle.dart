import 'dart:typed_data';

import 'package:gtfs_pb/gtfs_pb.dart';
import 'dart:io';

import 'package:gtfs_pb/proto/gtfs-realtime.pb.dart';

//TODO: Make todo for this class

// Class for vehicles_position.pb files
class GtfsPbVehicle extends GtfsPb {
  // Insert your vehicle_position.pb file as an argument
  GtfsPbVehicle.fromFile(File file) : super.fromFile(file);

  // Insert Uint8List as an argument (ex. bodyBytes from http)
  GtfsPbVehicle.fromUint8List(Uint8List uint8list)
      : super.fromUint8List(uint8list);

  // Returns list with all vehicles data from vehicle_position.pb
  // If there is no vehicles data in file returns empty list
  List<VehiclePosition> get allVehiclesData {
    List<VehiclePosition> vehicles = List();
    for (FeedEntity entity in message.entity) vehicles.add(entity.vehicle);
    return vehicles;
  }

  // Returns single vehicle data using search by tripId
  // If vehicle is not found returns empty FeedEntity
  VehiclePosition getVehicleDataByTripId(String tripId) => message.entity
          .firstWhere((entity) => entity.vehicle.trip.tripId == tripId,
              orElse: () => FeedEntity()).vehicle;

  // Returns single vehicle data using search by vehicleId
  // If vehicle is not found returns FeedEntity
  VehiclePosition getVehicleDataByVehicleId(String vehicleId) => message.entity
          .firstWhere((entity) => entity.vehicle.vehicle.id == vehicleId,
              orElse: () => FeedEntity()).vehicle;

  // Returns list of vehicle data using search by routeId
  // If vehicles were not found returns empty list
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
  // If vehicles were not found returns empty list
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
