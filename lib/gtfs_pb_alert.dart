import 'dart:io';
import 'dart:typed_data';

import 'package:gtfs_pb/gtfs_pb.dart';
import 'package:gtfs_pb/proto/gtfs-realtime.pb.dart';

class GtfsPbAlert extends GtfsPb {
  // Insert your alerts.pb file as an argument
  GtfsPbAlert.fromFile(File file) : super.fromFile(file);

  // Insert Uint8List as an argument (ex. bodyBytes from http)
  GtfsPbAlert.fromUint8List(Uint8List uint8list)
      : super.fromUint8List(uint8list);

  // Returns list with all alerts
  List<Alert> get allAlerts {
    List<Alert> alerts = List();
    for (FeedEntity entity in message.entity) alerts.add(entity.alert);
    return alerts;
  }

  // Returns list with alerts for specified agencyId
  List<Alert> getAlertsForAgency(String agencyId) {
    List<Alert> alerts = List();
    for (FeedEntity entity in message.entity) {
      for (EntitySelector selector in entity.alert.informedEntity) {
        if (selector.agencyId == agencyId) {
          alerts.add(entity.alert);
        }
      }
    }
    return alerts;
  }

  // Returns list with alerts for specified routeId
  List<Alert> getAlertsForRouteId(String routeId) {
    List<Alert> alerts = List();
    for (FeedEntity entity in message.entity) {
      for (EntitySelector selector in entity.alert.informedEntity) {
        if (selector.routeId == routeId) {
          alerts.add(entity.alert);
        }
      }
    }
    return alerts;
  }

  // Returns list with alerts for specified routeType
  List<Alert> getAlertsForRouteType(int routeType) {
    List<Alert> alerts = List();
    for (FeedEntity entity in message.entity) {
      for (EntitySelector selector in entity.alert.informedEntity) {
        if (selector.routeType == routeType) {
          alerts.add(entity.alert);
        }
      }
    }
    return alerts;
  }

  // Returns list with alerts for specified trip
  List<Alert> getAlertsForTrip(TripDescriptor trip) {
    List<Alert> alerts = List();
    for (FeedEntity entity in message.entity) {
      for (EntitySelector selector in entity.alert.informedEntity) {
        if (selector.trip == trip) {
          alerts.add(entity.alert);
        }
      }
    }
    return alerts;
  }

  // Returns list with alerts for specified stopId
  List<Alert> getAlertsForStopId(String stopId) {
    List<Alert> alerts = List();
    for (FeedEntity entity in message.entity) {
      for (EntitySelector selector in entity.alert.informedEntity) {
        if (selector.stopId == stopId) {
          alerts.add(entity.alert);
        }
      }
    }
    return alerts;
  }
}