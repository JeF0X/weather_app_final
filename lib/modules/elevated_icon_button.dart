import 'package:flutter/material.dart';

class ElevatedIconButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;

  ElevatedIconButton({@required this.onPressed, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        elevation: 0,
        primary: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 45,
      ),
    );
  }
}