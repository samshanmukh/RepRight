import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF00D4AA);
  static const Color accent = Color(0xFFFF6584);

  // Light theme colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF0F0F0F);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // Muscle group colors for visualization
  static const Map<String, Color> muscleColors = {
    'chest': Color(0xFFFF6B6B),
    'back': Color(0xFF4ECDC4),
    'shoulders': Color(0xFFFFE66D),
    'biceps': Color(0xFF95E1D3),
    'triceps': Color(0xFFF38181),
    'legs': Color(0xFF6C5CE7),
    'core': Color(0xFFFD79A8),
    'glutes': Color(0xFFA29BFE),
  };

  // Status colors
  static const Color success = Color(0xFF14B8A6); // Teal
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}
