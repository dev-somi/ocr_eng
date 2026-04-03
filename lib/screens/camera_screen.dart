import 'dart:io';

import 'package:camera/camera.dart';
import 'package:clickword/theme.dart';
import 'package:clickword/nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    var status = await Permission.camera.request();
    if (status.isDenied) {
      // Handle permission denied
      return;
    }

    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _controller = CameraController(
          _cameras[0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized || _controller == null) return;
    try {
      final image = await _controller!.takePicture();
      if (mounted) {
        context.push(AppRoutes.wordSelection, extra: image.path);
      }
    } catch (e) {
      debugPrint("Error taking picture: $e");
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null && mounted) {
        context.push(AppRoutes.wordSelection, extra: image.path);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: LightColors.secondary)),
      );
    }

    return Scaffold(
      backgroundColor: LightColors.background,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Camera Preview
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.black, width: 3),
                color: Colors.black,
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CameraPreview(_controller!),
                  Container(color: Colors.black.withOpacity(0.4)),
                  Center(
                    child: Container(
                      width: 280,
                      height: 180,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Stack(
                        children: [
                          _buildGuideCorner(Alignment.topLeft),
                          _buildGuideCorner(Alignment.topRight),
                          _buildGuideCorner(Alignment.bottomLeft),
                          _buildGuideCorner(Alignment.bottomRight),
                          Align(
                            alignment: const Alignment(0, -0.8),
                            child: Container(
                              width: 260,
                              height: 4,
                              decoration: BoxDecoration(
                                color: LightColors.primary,
                                borderRadius: BorderRadius.circular(AppRadius.full),
                                boxShadow: [
                                  BoxShadow(
                                    color: LightColors.primary.withOpacity(0.6),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: AppSpacing.paddingMd,
                              decoration: BoxDecoration(
                                color: LightColors.surface.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: Text(
                                "단어를 여기에 맞춰주세요",
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Top Buttons
            Positioned(
              top: 32,
              left: 32,
              right: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTopButton(Icons.close, () => context.pop()),
                  _buildTopButton(Icons.flash_on, () {
                    // Toggle Flash
                  }),
                ],
              ),
            ),

            // Bottom Controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 48, left: 32, right: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: LightColors.secondary,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [AppShadows.md],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb_rounded, color: Colors.black, size: 24),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              "책을 평평하게 놓으면 더 잘 인식돼요!",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildBottomAction(
                            context,
                            Icons.photo_library_rounded,
                            "갤러리",
                            _pickFromGallery
                        ),
                        GestureDetector(
                          onTap: _takePicture,
                          child: Container(
                            width: 92,
                            height: 92,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: LightColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 4),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 6),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: LightColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 4),
                              ),
                              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 40),
                            ),
                          ),
                        ),
                        _buildBottomAction(context, Icons.help_outline_rounded, "도움말", () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCorner(Alignment alignment) {
    double top = 0, bottom = 0, left = 0, right = 0;

    // Logic for corner borders
    // Simplified for now with specific containers
    BorderRadius radius = BorderRadius.zero;
    if (alignment == Alignment.topLeft) radius = const BorderRadius.only(topLeft: Radius.circular(16));
    if (alignment == Alignment.topRight) radius = const BorderRadius.only(topRight: Radius.circular(16));
    if (alignment == Alignment.bottomLeft) radius = const BorderRadius.only(bottomLeft: Radius.circular(16));
    if (alignment == Alignment.bottomRight) radius = const BorderRadius.only(bottomRight: Radius.circular(16));

    return Align(
      alignment: alignment,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top: (alignment.y < 0) ? const BorderSide(color: LightColors.primary, width: 4) : BorderSide.none,
            bottom: (alignment.y > 0) ? const BorderSide(color: LightColors.primary, width: 4) : BorderSide.none,
            left: (alignment.x < 0) ? const BorderSide(color: LightColors.primary, width: 4) : BorderSide.none,
            right: (alignment.x > 0) ? const BorderSide(color: LightColors.primary, width: 4) : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTopButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: LightColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [AppShadows.md],
        ),
        child: Icon(icon, color: Colors.black, size: 28),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: LightColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 3),
              boxShadow: const [AppShadows.md],
            ),
            child: Icon(icon, color: Colors.black, size: 28),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: LightColors.secondaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
