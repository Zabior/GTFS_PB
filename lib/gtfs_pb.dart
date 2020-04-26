library gtfs_pb;

import 'dart:typed_data';

import 'proto/gtfs-realtime.pb.dart';
import 'proto/gtfs-realtime.pbenum.dart';

import 'dart:io';

class GtfsPb {
  FeedMessage message;

  GtfsPb.fromFile(File file) {
    this.message = FeedMessage.fromBuffer(file.readAsBytesSync());
  }

  GtfsPb.fromUint8List(Uint8List uint8list) {
    this.message = FeedMessage.fromBuffer(uint8list);
  }

  // Metadata about this feed and feed message.
  FeedHeader get header => message.header;

  // Contents of the feed.
  List<FeedEntity> get entity => message.entity;

  // Timestamp of last data update Int64 - Epoch seconds time.
  get timestamp => message.header.timestamp;


}
