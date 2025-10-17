extension ColorOpacityFix on Color {
  Color withFixedOpacity(double opacity) =>
      withAlpha((opacity.clamp(0.0, 1.0) * 255).round());
}