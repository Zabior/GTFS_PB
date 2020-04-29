library gtfs_pb;

import 'dart:typed_data';

import 'proto/gtfs-realtime.pb.dart';

import 'dart:io';

export 'gtfs_pb_alert.dart';
export 'gtfs_pb_trip.dart';
export 'gtfs_pb_vehicle.dart';

// TODO: GtfsPbAlert class

// If you want to get specified info for trip_updates.pb, vehicles_position.pb
// or alerts.pb use subclasses GtfsPbTrip, GtfsPbVehicle or GtfsPbAlert
class GtfsPb {
  // GTFS feed - all data in file
  FeedMessage message;

  // Insert your trip_update.pb file as an argument
  GtfsPb.fromFile(File file) {
    this.message = FeedMessage.fromBuffer(file.readAsBytesSync());
  }

  // Insert Uint8List as an argument (ex. bodyBytes from http)
  GtfsPb.fromUint8List(Uint8List uint8list) {
    this.message = FeedMessage.fromBuffer(uint8list);
  }

  // Metadata about this feed and feed message
  FeedHeader get header => message.header;

  // Contents of the feed.
  List<FeedEntity> get entity => message.entity;

  // Timestamp of last data update Int64 - Epoch seconds time
  get timestamp => message.header.timestamp;


}
