import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PoseDetectionService {
  final PoseDetector _poseDetector;

  PoseDetectionService()
      : _poseDetector = GoogleMlKit.vision.poseDetector(
          options: PoseDetectorOptions(
            mode: PoseDetectionMode.stream,
            model: PoseDetectionModel.accurate,
          ),
        );

  Future<List<Pose>> detectPose(CameraImage image) async {
    try {
      // Convert CameraImage to InputImage
      final inputImage = _convertCameraImage(image);
      if (inputImage == null) return [];

      // Detect poses
      final poses = await _poseDetector.processImage(inputImage);
      return poses;
    } catch (e) {
      print('Error detecting pose: $e');
      return [];
    }
  }

  InputImage? _convertCameraImage(CameraImage image) {
    try {
      // Note: This is a simplified conversion
      // In production, you'd need to handle different image formats
      // and rotations based on the device orientation

      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final imageSize = Size(
        image.width.toDouble(),
        image.height.toDouble(),
      );

      final imageRotation = InputImageRotation.rotation0deg;

      final inputImageFormat = InputImageFormat.nv21;

      final planeData = image.planes.map(
        (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList();

      final inputImageData = InputImageData(
        size: imageSize,
        imageRotation: imageRotation,
        inputImageFormat: inputImageFormat,
        planeData: planeData,
      );

      return InputImage.fromBytes(
        bytes: bytes,
        inputImageData: inputImageData,
      );
    } catch (e) {
      print('Error converting camera image: $e');
      return null;
    }
  }

  Map<String, double> analyzeMuscleActivation(
    List<Pose> poses,
    String exerciseType,
  ) {
    // This is a placeholder for muscle activation analysis
    // In production, this would use joint angles and exercise-specific logic
    // to determine which muscles are being activated

    if (poses.isEmpty) {
      return {};
    }

    final pose = poses.first;
    final landmarks = pose.landmarks;

    // Example: Analyze squat form and muscle activation
    if (exerciseType.toLowerCase() == 'squat') {
      return _analyzeSquatMuscles(landmarks);
    }

    // Default muscle activation (placeholder)
    return {
      'quadriceps': 0.0,
      'glutes': 0.0,
      'hamstrings': 0.0,
      'core': 0.0,
    };
  }

  Map<String, double> _analyzeSquatMuscles(
    Map<PoseLandmarkType, PoseLandmark> landmarks,
  ) {
    // Simplified muscle activation based on joint angles
    // In production, this would be much more sophisticated

    final leftHip = landmarks[PoseLandmarkType.leftHip];
    final leftKnee = landmarks[PoseLandmarkType.leftKnee];
    final leftAnkle = landmarks[PoseLandmarkType.leftAnkle];

    if (leftHip == null || leftKnee == null || leftAnkle == null) {
      return {};
    }

    // Calculate knee angle (simplified)
    final kneeAngle = _calculateAngle(
      leftHip.x,
      leftHip.y,
      leftKnee.x,
      leftKnee.y,
      leftAnkle.x,
      leftAnkle.y,
    );

    // Estimate muscle activation based on squat depth
    final depth = kneeAngle / 180.0; // Normalized 0-1

    return {
      'quadriceps': (depth * 0.85).clamp(0.0, 1.0),
      'glutes': (depth * 0.75).clamp(0.0, 1.0),
      'hamstrings': (depth * 0.60).clamp(0.0, 1.0),
      'core': (depth * 0.50).clamp(0.0, 1.0),
    };
  }

  double _calculateAngle(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) {
    // Calculate angle between three points
    final radians = atan2(y3 - y2, x3 - x2) - atan2(y1 - y2, x1 - x2);
    var angle = radians * 180.0 / pi;
    if (angle < 0) {
      angle += 360;
    }
    return angle;
  }

  void dispose() {
    _poseDetector.close();
  }
}

// Import for WriteBuffer
import 'dart:typed_data';
import 'dart:math';

final poseDetectionServiceProvider = Provider<PoseDetectionService>((ref) {
  final service = PoseDetectionService();
  ref.onDispose(() => service.dispose());
  return service;
});
