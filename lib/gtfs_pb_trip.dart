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
  // If trip is not found returns empty TripUpdate
  TripUpdate getTripByTripId(String tripId) => message.entity
      .firstWhere((entity) => entity.tripUpdate.trip.tripId == tripId,
          orElse: () => FeedEntity())
      .tripUpdate;

  // Returns single TripUpdate using search by vehicleId
  // If trip is not found returns empty TripUpdate
  TripUpdate getTripUpdateByVehicleId(String vehicleId) => message.entity
      .firstWhere((entity) => entity.tripUpdate.vehicle.id == vehicleId,
          orElse: () => FeedEntity())
      .tripUpdate;

  // Returns single TripUpdate using search by vehicleLabel
  // If trip is not found returns empty TripUpdate
  TripUpdate getTripUpdateByVehicleLabel(String label) => message.entity
      .firstWhere((entity) => entity.tripUpdate.vehicle.label == label,
          orElse: () => FeedEntity())
      .tripUpdate;

  // Returns list of TripUpdate using search by routeId
  // If trips were not found returns empty list
  List<TripUpdate> getTripsDataByRouteId(String routeId) {
    List<TripUpdate> trips = List();
    for (FeedEntity entity in message.entity) {
      if (entity.tripUpdate.trip.routeId == routeId)
        trips.add(entity.tripUpdate);
    }
    return trips;
  }

  // Returns list of TripUpdate which have chosen stopId in one of stopTimeUpdates
  // If trips were not found returns empty list
  List<TripUpdate> getTripsDataByStopId(String stopId) {
    List<TripUpdate> trips = List();
    for (FeedEntity entity in message.entity) {
      for (TripUpdate_StopTimeUpdate stopTimeUpdate
          in entity.tripUpdate.stopTimeUpdate) {
        if (stopTimeUpdate.stopId == stopId) {
          trips.add(entity.tripUpdate);
          break;
        }
      }
    }
    return trips;
  }

  // Returns single StopTimeUpdate for specified tripId and either stopId or stopSequence
  // If nothing was found return empty StopTimeUpdate
  // You have to specify stopId or stopSequence - if not returns null
  TripUpdate_StopTimeUpdate getSingleStopTimeUpdate(String tripId,
      {String stopId, int stopSequence}) {
    TripUpdate trip = getTripByTripId(tripId);
    if (stopId != null) {
      return trip.stopTimeUpdate.firstWhere((update) => update.stopId == stopId,
          orElse: () => TripUpdate_StopTimeUpdate());
    } else if (stopSequence != null) {
      return trip.stopTimeUpdate.firstWhere(
          (update) => update.stopSequence == stopSequence,
          orElse: () => TripUpdate_StopTimeUpdate());
    } else {
      print('You have to specify stopId or stopSequence');
      return null;
    }
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

  // Filter your message to reduce it to only one startDate
  filterFeedByStartDate(String startDate) {
    for (FeedEntity entity in message.entity) {
      if (startDate != entity.vehicle.trip.startDate)
        message.entity.remove(entity);
    }
  }
}
