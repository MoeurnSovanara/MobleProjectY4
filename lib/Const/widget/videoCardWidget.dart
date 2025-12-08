import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AssetVideoCard extends StatefulWidget {
  final String thumbnailAsset; // e.g. 'assets/thumbs/promo1.jpg'
  final String videoAsset; // e.g. 'assets/videos/promo1.mp4'

  const AssetVideoCard({
    super.key,
    required this.thumbnailAsset,
    required this.videoAsset,
  });

  @override
  State<AssetVideoCard> createState() => _AssetVideoCardState();
}

class _AssetVideoCardState extends State<AssetVideoCard> {
  VideoPlayerController? _controller;
  bool _showPlayer = false;
  bool _muted = false;

  Future<void> _startInlinePlayback() async {
    setState(() => _showPlayer = true);

    _controller = VideoPlayerController.asset(widget.videoAsset);

    try {
      await _controller!.initialize();
      // Optional defaults:
      _controller!.setLooping(false);
      _controller!.setVolume(_muted ? 0.0 : 1.0);
      await _controller!.play();
    } catch (e) {
      // If initialization fails, fall back to thumbnail
      debugPrint('Video init error: $e');
      if (mounted) setState(() => _showPlayer = false);
      return;
    }

    if (mounted) setState(() {});
  }

  void _togglePlayPause() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  void _toggleMute() {
    if (_controller == null) return;
    setState(() {
      _muted = !_muted;
      _controller!.setVolume(_muted ? 0.0 : 1.0);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(16));
    final isReady = _controller?.value.isInitialized ?? false;

    // Use 9:16 card shape for the grid,
    // but when video is ready, render with its true aspect ratio within that space.
    return SizedBox(
      width: 160,
      child: ClipRRect(
        borderRadius: radius,
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1) Thumbnail (default)
              if (!_showPlayer) ...[
                Image.asset(widget.thumbnailAsset, fit: BoxFit.cover),
                // Gradient over thumbnail (optional)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0x66000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ),
                // Play button
                Center(
                  child: InkWell(
                    onTap: _startInlinePlayback,
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 30,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],

              // 2) Player (after tap)
              if (_showPlayer) ...[
                if (isReady)
                  FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: 160, // base width
                      // Height based on card aspect; the child inside uses the video’s ratio
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                  )
                else
                  const Center(child: CircularProgressIndicator()),

                // 3) Minimal controls overlay
                if (isReady)
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: false,
                      child: Stack(
                        children: [
                          // Tap anywhere center to toggle play/pause
                          Center(
                            child: GestureDetector(
                              onTap: _togglePlayPause,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    _controller!.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Mute button (top-right)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              visualDensity: VisualDensity.compact,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.35),
                                foregroundColor: Colors.white,
                              ),
                              icon: Icon(
                                _muted ? Icons.volume_off : Icons.volume_up,
                              ),
                              onPressed: _toggleMute,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
