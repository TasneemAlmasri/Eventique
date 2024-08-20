import 'package:flutter/material.dart';

class OneEvent {
  int? youAndUsId;
  final int eventId;
  final String name;
  final double budget;
  final int guestsNumber;
  final TimeOfDay time;
  final DateTime dateTime;
  final int eventTypeId;

  OneEvent({
    this.youAndUsId,
    required this.eventId,
    required this.name,
    required this.budget,
    required this.guestsNumber,
    required this.time,
    required this.dateTime,
    required this.eventTypeId,
  });
}
