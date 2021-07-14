class City{
  String codeState;
  String stateName;
  String stateNumber;

  City(this.codeState, this.stateName, this.stateNumber);

  @override
  String toString() {
    return 'City{codeState: $codeState, stateName: $stateName}';
  }


}