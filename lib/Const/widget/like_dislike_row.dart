import 'package:flutter/material.dart';

class LikeDislikeRow extends StatefulWidget {
  final int likes;
  final int dislikes;

  const LikeDislikeRow({
    Key? key,
    this.likes = 809000,
    this.dislikes = 0,
  }) : super(key: key);

  @override
  State<LikeDislikeRow> createState() => _LikeDislikeRowState();
}

class _LikeDislikeRowState extends State<LikeDislikeRow> {
  bool _isLiked = false;
  bool _isDisliked = false;
  double _likeScale = 1.0;
  double _dislikeScale = 1.0;

  String _formatCount(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)} M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)} k';
    return value.toString();
  }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _isLiked = false;
      } else {
        _isLiked = true;
        _isDisliked = false;
      }
      _likeScale = 1.1;
      _dislikeScale = 1.0;
    });

    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) {
        setState(() {
          _likeScale = 1.0;
        });
      }
    });
  }

  void _toggleDislike() {
    setState(() {
      if (_isDisliked) {
        _isDisliked = false;
      } else {
        _isDisliked = true;
        _isLiked = false;
      }
      _dislikeScale = 1.1;
      _likeScale = 1.0;
    });

    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) {
        setState(() {
          _dislikeScale = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: _toggleLike,
          child: AnimatedScale(
            scale: _likeScale,
            duration: const Duration(milliseconds: 120),
            child: Image.asset(
              _isLiked
                  ? 'assets/img/Icon/liked.png'
                  : 'assets/img/Icon/unLike.png',
              width: 22,
              height: 22,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(_formatCount(widget.likes)),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _toggleDislike,
          child: AnimatedScale(
            scale: _dislikeScale,
            duration: const Duration(milliseconds: 120),
            child: Image.asset(
              _isDisliked
                  ? 'assets/img/Icon/disliked.png'
                  : 'assets/img/Icon/dislike.png',
              width: 22,
              height: 22,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(_formatCount(widget.dislikes)),
      ],
    );
  }
}

