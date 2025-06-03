import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
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
    this.height = 50,
    this.width = (double.infinity - 90),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: height,
      width : width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: isBlue ? 
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
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [BoxShadow(
              color: Colors.black26,
              blurRadius: 3,
              offset: Offset(1, 1),
            ),]
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: isBlue ? Colors.white : Colors.black,
                fontSize: 16,
              )
            ),
          ),
        ),
      ),
    );
  }
}

class FloatingButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 50,
      width: (screenWidth - 90),
      decoration: BoxDecoration(
        gradient: isBlue ? 
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
        )]
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              text,
              style: TextStyle(
                color: isBlue ? Colors.white : Colors.black,
                fontSize: 16,
              )
            ),
          ),
          GestureDetector(
            onTap: onPressed,
          )
        ],
      ),
    );
  }
}
