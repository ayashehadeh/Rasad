abstract class TripPlannerEvent {
  const TripPlannerEvent();
}

class TripPlannerStarted extends TripPlannerEvent {
  const TripPlannerStarted();
}

class TripPlannerMessageSent extends TripPlannerEvent {
  final String text;
  const TripPlannerMessageSent(this.text);
}

class TripPlannerSuggestionTapped extends TripPlannerEvent {
  final String suggestion;
  const TripPlannerSuggestionTapped(this.suggestion);
}

class TripPlannerChatCleared extends TripPlannerEvent {
  const TripPlannerChatCleared();
}
