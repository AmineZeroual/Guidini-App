
class HistoriqueInfo{
  String CodeHistorique;
  String pD;
  String pA;
  String price;
  String distance;
  String duree;
  String rating;
  String uId;
  String stationCode;
  String date;

  HistoriqueInfo(
      this.CodeHistorique,
      this.pD,
      this.pA,
      this.price,
      this.distance,
      this.duree,
      this.rating,
      this.uId,
      this.stationCode,
      this.date);




  @override
  String toString() {
    return 'HistoriqueInfo{pD: $pD, pA: $pA, rating: $rating}$date';
  }
}