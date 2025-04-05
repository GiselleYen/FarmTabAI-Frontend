import 'package:flutter/material.dart';

class CardSmall extends StatefulWidget {
  const CardSmall({
    super.key,
    required this.title,
    required this.image,
    this.subtitle,
    this.onTap,
    this.onFavoritePressed,
    this.isFavorite = false,
  });

  final String title;
  final String image;
  final String? subtitle;
  final VoidCallback? onTap;
  final Function(bool)? onFavoritePressed;
  final bool isFavorite;

  @override
  State<CardSmall> createState() => _CardSmallState();
}

class _CardSmallState extends State<CardSmall> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: widget.onTap,
          child: Stack(
            children: [
              // Image
              Positioned.fill(
                child: widget.image.startsWith('http')
                    ? Image.network(
                  widget.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                )
                    : Image.asset(
                  widget.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: "Inter",
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Favorite button
              Positioned(
                top: 6,
                right: 6,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                      widget.onFavoritePressed?.call(_isFavorite);
                    },
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildPlaceholderImage() {
  return Container(
    color: Colors.grey[200],
    alignment: Alignment.center,
    child: Icon(
      Icons.broken_image,
      size: 40,
      color: Colors.grey[600],
    ),
  );
}
