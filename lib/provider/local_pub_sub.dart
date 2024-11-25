import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum EventName {
  shareSCD,
}

class LocalPubSub {
  final EventName _eventName;
  final dynamic _value;

  const LocalPubSub(this._eventName, [this._value]);

  EventName get name => _eventName;

  dynamic get value => _value;
}


class AppLocalPubSub {

  AppLocalPubSub._();

  static AppLocalPubSub? _i;

  static PublishSubject<LocalPubSub>? _eventController;

  static AppLocalPubSub get I {
    _i ??= AppLocalPubSub._();
    _eventController ??= PublishSubject<LocalPubSub>();
    return _i!;
  }

  // ban event
  Function(LocalPubSub) get emitEvent => _eventController!.sink.add;

  StreamSubscription<LocalPubSub> listenEvent({
    required EventName eventName,
    required Function(LocalPubSub) handler,
    Duration debounceTime = Duration.zero,
  }) {
    return _eventController!.stream
        .debounceTime(debounceTime)
        .where((evt) => evt.name == eventName)
        .listen(handler);
  }

  StreamSubscription<LocalPubSub> listenManyEvents({
    required List<EventName> listEventName,
    required Function(LocalPubSub) handler,
    Duration debounceTime = Duration.zero,
  }) {
    return _eventController!.stream
        .debounceTime(debounceTime)
        .where((evt) => listEventName.contains(evt.name))
        .listen(handler);
  }

  ///Chưa cần quan tâm
  @mustCallSuper
  void dispose() {
    _eventController!.close();
    _eventController = null;
    _i = null;
  }
}
