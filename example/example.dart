import 'dart:io';

import 'package:gtfs_pb/gtfs_pb.dart';

main() {
  // All example files come from ZTM Poznan
  print('trips_file:');
  /*GtfsPbTrip trip =
      GtfsPbTrip.fromFile(File('example/example_files/trip_updates.pb'));*/
  GtfsPbTrip trip =
      GtfsPbTrip.fromFile(File('example/example_files/gtfs-rt.pb'));
  print(trip.timestamp);
  //print(trip.allTrips);
  //print(trip.allTrips[0].vehicle.id);
  //print(trip.allEarlyTrips);
  //print(trip.getTripsDataByRouteId('177'));
  print(trip.getTripByTripId('2:5239'));

  /*print('vehicles_file:');
  GtfsPbVehicle vehicle = GtfsPbVehicle.fromFile(
      File('example/example_files/vehicle_positions.pb'));
  print(vehicle.timestamp);
  print(vehicle.getVehiclesDataNearLocation(52.414, 52.42, 16.955, 16.96));*/
}
