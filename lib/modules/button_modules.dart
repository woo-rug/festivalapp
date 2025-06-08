import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isBlue;
  final double height;
  final double width;


  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isBlue,
    this.height = 45,
    this.width = (double.infinity - 90),
  });

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
      lowerBound: 0.9,
      upperBound: 1.0,
      value: 1.0,
    );

    _controller.addListener(() {
      setState(() {
        _scale = _controller.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) async {
    await _controller.reverse();
    await _controller.forward();
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: widget.height,
      width : widget.width,
      child: GestureDetector(
        onTapDown: _onTapDown,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 70),
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              gradient: widget.isBlue ? 
              LinearGradient(
                colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ) :
              LinearGradient(
                colors: [Color.fromARGB(255, 230, 230, 230), Color.fromARGB(255, 200, 200, 200)],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(
                color: Colors.black26,
                blurRadius: 3,
                offset: Offset(1, 1),
              ),]
            ),
            alignment: Alignment.center,
            child: Text(
              widget.text,
              style: TextStyle(
                color: widget.isBlue ? Colors.white : Colors.black,
                fontSize: 16,
              )
            ),
          ),
        ),
      ),
    );
  }
}

class FloatingButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isBlue;

  const FloatingButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.isBlue,
  });

  @override
  _FloatingButtonState createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
      lowerBound: 0.9,
      upperBound: 1.0,
      value: 1.0,
    )..addListener(() {
        setState(() {
          _scale = _controller.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) async {
    await _controller.reverse();
    await _controller.forward();
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTapDown: _onTapDown,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 70),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 50,
          width: (screenWidth - 90),
          decoration: BoxDecoration(
            gradient: widget.isBlue ? 
              LinearGradient(
                colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ) :
              LinearGradient(
                colors: [Color.fromARGB(255, 230, 230, 230), Color.fromARGB(255, 200, 200, 200)],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            borderRadius: BorderRadius.all(Radius.circular(25)),
            boxShadow: const [BoxShadow(
              color: Colors.black26,
              blurRadius: 3,
              offset: Offset(1, 1),
            )],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                color: widget.isBlue ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
