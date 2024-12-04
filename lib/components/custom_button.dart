import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final void Function()? onTap;
  final String  txt;
  const CustomButton({super.key,required this.onTap,required this.txt});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(txt,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20),),
        ),
      ),
    );
  }
}