library gtfs_pb;

import 'dart:typed_data';

import 'proto/gtfs-realtime.pb.dart';

import 'dart:io';

export 'gtfs_pb_alert.dart';
export 'gtfs_pb_trip.dart';
export 'gtfs_pb_vehicle.dart';
export 'proto/gtfs-realtime.pb.dart';

/// [GtfsPb] represents general data stored in GTFS-RT files
/// If you want to get specified info for trip_updates.pb, vehicles_position.pb
/// or alerts.pb use subclasses GtfsPbTrip, GtfsPbVehicle or GtfsPbAlert
class GtfsPb {
  /// [message] contains GTFS feed
  late FeedMessage message;

  /// [GtfsPb.fromFile(file)] data from trip_update.pb file
  GtfsPb.fromFile(File file) {
    this.message = FeedMessage.fromBuffer(file.readAsBytesSync());
  }

  /// [GtfsPb.fromUint8List(uint8list)] data Uint8List (ex. bodyBytes from http)
  GtfsPb.fromUint8List(Uint8List uint8list) {
    this.message = FeedMessage.fromBuffer(uint8list);
  }

  /// [header] Metadata about this feed and feed message
  FeedHeader get header => message.header;

  /// [entity] Contents of the feed.
  List<FeedEntity> get entity => message.entity;

  /// [timestamp] Timestamp of last data update Int64 - Epoch seconds time
  get timestamp => message.header.timestamp;
}
