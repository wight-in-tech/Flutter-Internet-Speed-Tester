import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class SpeedGauge extends StatelessWidget {
  final double value;

  // Constructor with required 'value' parameter
  const SpeedGauge({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedRadialGauge(
      /// The animation duration.
      duration: const Duration(seconds: 1),
      curve: Curves.elasticOut,

      /// Define the radius.
      radius: 100,

      /// Gauge value, using the passed `value` variable.
      value: value,

      /// Optionally, you can configure your gauge, providing additional styles and transformers.
      axis: const GaugeAxis(
        /// Provide the [min] and [max] value for the [value] argument.
        min: 0,
        max: 100,

        /// Render the gauge as a 180-degree arc.
        degrees: 180,

        /// Set the background color and axis thickness.
        style: GaugeAxisStyle(
          thickness: 20,
          background: Color(0xFFDFE2EC),
          segmentSpacing: 4,
        ),

        /// Define the pointer that will indicate the progress (optional).
        pointer: GaugePointer.needle(
          borderRadius: 16,
          width: 16,
          height: 100,
          color: Colors.black,
        ),

        /// Define the progress bar (optional).
        progressBar: GaugeProgressBar.rounded(
          color: Color(0xFFB4C2F8),
        ),

        /// Define axis segments (optional).
        segments: [
          GaugeSegment(
            from: 0,
            to: 33.3,
            color: Color(0xFFD9DEEB),
            cornerRadius: Radius.zero,
          ),
          GaugeSegment(
            from: 33.3,
            to: 66.6,
            color: Color(0xFFD9DEEB),
            cornerRadius: Radius.zero,
          ),
          GaugeSegment(
            from: 66.6,
            to: 100,
            color: Color(0xFFD9DEEB),
            cornerRadius: Radius.zero,
          ),
        ],
      ),

      /// Define the child builder for the gauge label.
      builder: (context, child, value) => RadialGaugeLabel(
        value: this.value,

        style: const TextStyle(
          color: Colors.black,
          fontSize: 46,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
