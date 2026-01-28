import 'package:flutter/material.dart';

class BookmarkButton extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
  final double? size;

  const BookmarkButton({
    Key? key,
    this.initialValue = false,
    this.onChanged,
    this.size,
  }) : super(key: key);

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  late bool _isBookmarked;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.initialValue;
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
      _scale = 1.1;
    });

    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) {
        setState(() {
          _scale = 1.0;
        });
      }
    });

    widget.onChanged?.call(_isBookmarked);

    final title =
        _isBookmarked ? 'Saved to bookmarks' : 'Removed from bookmarks';
    final subtitle = _isBookmarked
        ? 'You can find this event in your saved list.'
        : 'This event was removed from your saved list.';

    _showIosBannerToast(
      context,
      title: title,
      subtitle: subtitle,
      isPositive: _isBookmarked,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleBookmark,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Image.asset(
          _isBookmarked
              ? 'assets/img/Icon/bookmarked.png'
              : 'assets/img/Icon/bookmark.png',
          width: widget.size,
          height: widget.size,
        ),
      ),
    );
  }
}

/// iOS-style banner / Toastify-like alert (similar to your design)
void _showIosBannerToast(
  BuildContext context, {
  required String title,
  required String subtitle,
  required bool isPositive,
}) {
  final overlay = Overlay.of(context);
  if (overlay == null) return;

  final Color accentColor =
      isPositive ? const Color(0xFF4CAF50) : const Color(0xFFFFA726);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (ctx) => Positioned(
      top: 70,
      left: 16,
      right: 16,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: -20, end: 0),
        duration: const Duration(milliseconds: 220),
        builder: (context, value, child) => Transform.translate(
          offset: Offset(0, value),
          child: Opacity(
            opacity: 1 - (value.abs() / 20),
            child: child,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7EC),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: accentColor.withOpacity(0.7), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Icon(
                    isPositive ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    if (entry.mounted) entry.remove();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  Future.delayed(const Duration(milliseconds: 2000), () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}

