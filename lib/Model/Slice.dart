
class Slice{
  String codeSlice;
  String codeStation1;
  String codeStation2;
  String codeLine;
  String distance="0";
  String time="0";

  void slice1(){

  }

  Slice(this.codeSlice, this.codeStation1, this.codeStation2, this.codeLine,
      this.distance, this.time);

  @override
  String toString() {
    return 'Slice{codeSlice: $codeSlice, codeStation1: $codeStation1, codeStation2: $codeStation2}';
  }


}