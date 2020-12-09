import 'dart:typed_data';

import 'package:gtfs_pb/gtfs_pb.dart';

import 'dart:io';

import 'package:gtfs_pb/proto/gtfs-realtime.pb.dart';

/// [GtfsPbTrip] represents GTFS-RT TripUpdates data
class GtfsPbTrip extends GtfsPb {
  /// [GtfsPbTrip.fromUint8List(uint8list)] data Uint8List
  /// (ex. bodyBytes from http)
  GtfsPbTrip.fromUint8List(Uint8List uint8list)
      : super.fromUint8List(uint8list);

  /// [GtfsPbTrip.fromFile(file)] data from trip_update.pb file
  GtfsPbTrip.fromFile(File file) : super.fromFile(file);

  /// [allTrips] returns List with all TripUpdates
  List<TripUpdate> get allTrips {
    List<TripUpdate> trips = [];
    for (FeedEntity entity in message.entity) trips.add(entity.tripUpdate);
    return trips;
  }

  /// [getTripByTripId] returns single TripUpdate for specified tripId
  /// If trip is not found returns empty TripUpdate
  TripUpdate getTripByTripId(String tripId) => message.entity
      .firstWhere((entity) => entity.tripUpdate.trip.tripId == tripId,
          orElse: () => FeedEntity())
      .tripUpdate;

  /// [getTripUpdateByVehicleId] returns single TripUpdate
  /// using search by vehicleId
  /// If trip is not found returns empty TripUpdate
  TripUpdate getTripUpdateByVehicleId(String vehicleId) => message.entity
      .firstWhere((entity) => entity.tripUpdate.vehicle.id == vehicleId,
          orElse: () => FeedEntity())
      .tripUpdate;

  /// [getTripUpdateByVehicleLabel] returns single TripUpdate
  /// using search by vehicleLabel
  /// If trip is not found returns empty TripUpdate
  TripUpdate getTripUpdateByVehicleLabel(String label) => message.entity
      .firstWhere((entity) => entity.tripUpdate.vehicle.label == label,
          orElse: () => FeedEntity())
      .tripUpdate;

  /// [getTripsDataByRouteId] returns list of TripUpdate using search by routeId
  /// If trips were not found returns empty list
  List<TripUpdate> getTripsDataByRouteId(String routeId) {
    List<TripUpdate> trips = [];
    for (FeedEntity entity in message.entity) {
      if (entity.tripUpdate.trip.routeId == routeId)
        trips.add(entity.tripUpdate);
    }
    return trips;
  }

  /// [getTripsDataByStopId] returns list of TripUpdate
  /// which have chosen stopId in one of stopTimeUpdates
  /// If trips were not found returns empty list
  List<TripUpdate> getTripsDataByStopId(String stopId) {
    List<TripUpdate> trips = [];
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

  /// [getSingleStopTimeUpdate] returns single StopTimeUpdate
  /// for specified tripId and either stopId or stopSequence
  /// If nothing was found return empty StopTimeUpdate
  /// You have to specify stopId or stopSequence - if not returns null
  TripUpdate_StopTimeUpdate? getSingleStopTimeUpdate(String tripId,
      {String? stopId, int? stopSequence}) {
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

  /// [allDelayedTrips] returns list of all delayed trips
  /// If trips were not found returns empty list
  List<TripUpdate> get allDelayedTrips {
    List<TripUpdate> trips = [];
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

  /// [allEarlyTrips] returns list of all early trips
  /// If trips were not found returns empty list
  List<TripUpdate> get allEarlyTrips {
    List<TripUpdate> trips = [];
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

  /// [filterFeedByStartDate] filters your message
  /// to reduce it to only one startDate
  filterFeedByStartDate(String startDate) {
    for (FeedEntity entity in message.entity) {
      if (startDate != entity.vehicle.trip.startDate)
        message.entity.remove(entity);
    }
  }
}
