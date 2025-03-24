import 'package:flutter/material.dart';

import '../../theme/color_extension.dart';

class TypingIndicator extends StatefulWidget {
  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with TickerProviderStateMixin {
  late List<AnimationController> _animControllers;
  late List<Animation<double>> _animations;
  final int _dotsCount = 3;

  @override
  void initState() {
    super.initState();

    _animControllers = List.generate(
        _dotsCount,
            (index) => AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 400),
        )
    );

    _animations = _animControllers.map((controller) =>
        Tween<double>(begin: 0, end: 6).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut)
        )
    ).toList();

    // Start the animations with staggered delays
    for (var i = 0; i < _dotsCount; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _animControllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _animControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Thinking ",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: List.generate(_dotsCount, (index) {
            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Container(
                  padding: EdgeInsets.all(2),
                  child: Transform.translate(
                    offset: Offset(0, -_animations[index].value),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: TColor.primaryColor1.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}