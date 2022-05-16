import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomButton({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(20.0),
          height: 50.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.yellow[700],
            boxShadow: [BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4.0,
            ),],
            borderRadius: BorderRadius.circular(25.0),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
  }
}