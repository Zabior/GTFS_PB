import 'dart:typed_data';

import 'package:gtfs_pb/gtfs_pb.dart';

import 'dart:io';

import 'package:gtfs_pb/proto/gtfs-realtime.pb.dart';

// Class for trip_updates.pb etc. files
class GtfsPbTrip extends GtfsPb {
  // Insert Uint8List as an argument (ex. body bytes of response from http)
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

  TripUpdate getTripByTripId(String tripId) => message.entity
      .firstWhere((entity) => entity.tripUpdate.trip.tripId == tripId,
          orElse: () => null)
      .tripUpdate;
}
