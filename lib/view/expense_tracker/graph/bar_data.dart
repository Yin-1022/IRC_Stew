import 'individual_bar.dart';

class BarData
{
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;

  BarData
  (
    {
      required this.sunAmount,
      required this.monAmount,
      required this.tueAmount,
      required this.wedAmount,
      required this.thuAmount,
      required this.friAmount,
      required this.satAmount,
    }
  );

  List<IndividualBar> barData = [];

  void initializeBarData()
  {
    barData =
    {
      IndividualBar(x: 0, y: sunAmount,)
    }
  }
}