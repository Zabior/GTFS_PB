import 'dart:typed_data';

import 'package:gtfs_pb/gtfs_pb.dart';

import 'dart:io';

import 'package:gtfs_pb/proto/gtfs-realtime.pb.dart';

// Class for trip_updates.pb files
class GtfsPbTrip extends GtfsPb {
  // Insert Uint8List as an argument (ex. bodyBytes from http)
  GtfsPbTrip.fromUint8List(Uint8List uint8list)
      : super.fromUint8List(uint8list);

  // Insert your trip_update.pb file as an argument
  GtfsPbTrip.fromFile(File file) : super.fromFile(file);

  // Returns List with all TripUpdates from trip_updates.pb
  List<TripUpdate> get allTrips {
    List<TripUpdate> trips = List();
    for (FeedEntity entity in message.entity) trips.add(entity.tripUpdate);
    return trips;
  }

  // Returns single TripUpdate for specified tripId
  // If trip is not found returns empty FeedEntity
  TripUpdate getTripByTripId(String tripId) => message.entity
      .firstWhere((entity) => entity.tripUpdate.trip.tripId == tripId,
          orElse: () => FeedEntity())
      .tripUpdate;

  // Returns single trip data using search by vehicleId
  // If trip is not found returns FeedEntity
  TripUpdate getTripUpdateByVehicleId(String vehicleId) => message.entity
      .firstWhere((entity) => entity.tripUpdate.vehicle.id == vehicleId,
          orElse: () => FeedEntity())
      .tripUpdate;

  // Returns list of trip data using search by routeId
  // If trips were not found returns empty list
  List<TripUpdate> getTripsDataByRouteId(String routeId) {
    List<TripUpdate> trips = List();
    for (FeedEntity entity in message.entity) {
      if (entity.tripUpdate.trip.routeId == routeId)
        trips.add(entity.tripUpdate);
    }
    return trips;
  }

  // Returns list of all delayed trips
  // If trips were not found returns empty list
  List<TripUpdate> get allDelayedTrips {
    List<TripUpdate> trips = List();
    for (FeedEntity entity in message.entity) {
      for (TripUpdate_StopTimeUpdate stopTimeUpdate
      in entity.tripUpdate.stopTimeUpdate) {
        if (stopTimeUpdate.arrival.delay > 0 ||
            stopTimeUpdate.departure.delay > 0) {
          trips.add(entity.tripUpdate);
          break;
        }
      }
    }
    return trips;
  }

  // Returns list of all early trips
  // If trips were not found returns empty list
  List<TripUpdate> get allEarlyTrips {
    List<TripUpdate> trips = List();
    for (FeedEntity entity in message.entity) {
      for (TripUpdate_StopTimeUpdate stopTimeUpdate
          in entity.tripUpdate.stopTimeUpdate) {
        if (stopTimeUpdate.arrival.delay < 0 ||
            stopTimeUpdate.departure.delay < 0) {
          trips.add(entity.tripUpdate);
          break;
        }
      }
    }
    return trips;
  }

  // TODO: Search by stopId in stopTimeUpdate
  // TODO: Search by vehicle label
  // TODO: Search for concrete stopTimeUpdate by specifying tripId and StopId or StopSequence
  // TODO: Filter results for startDate
}
