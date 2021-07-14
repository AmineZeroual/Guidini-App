class Location{
  String codeLocation;

  @override
  String toString() {
    return 'Location{codeLocation: $codeLocation, locationName: $locationName, codeState: $codeState}';
  }

  Location(this.codeLocation, this.locationName, this.codeState);

  String locationName;
  String codeState;
}