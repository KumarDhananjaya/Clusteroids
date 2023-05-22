import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Event {
  final String title;
  final DateTime dateTime;

  Event({required this.title, required this.dateTime});
}

class EventProvider with ChangeNotifier {
  List<Event> _events = [];

  List<Event> get events => _events;

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }
}

