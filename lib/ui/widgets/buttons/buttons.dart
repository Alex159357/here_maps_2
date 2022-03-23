

import 'package:flutter/material.dart';

class Buttons{
  
  Widget primaryButton({required BuildContext context, required Function onClick, required String text, Widget? icon}){
    return ElevatedButton(onPressed:()=> onClick.call(), child:
    Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text.toUpperCase(), style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),),
          Padding(
            padding: const EdgeInsets.only(left: 21),
            child: icon ?? Container(),
          )
        ],
      ),
    ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 13, horizontal: 21)),
            backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Theme.of(context).primaryColor)))));
  }

  Widget buttonCancel({required BuildContext context, required Function onClick, required String text, Widget? icon}){
    return ElevatedButton(onPressed: ()=> onClick.call(), child:
    Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text.toUpperCase(), style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).errorColor),),
          Padding(
            padding: EdgeInsets.only(left: icon== null? 0 :21),
            child: icon ?? Container(),
          )
        ],
      ),
    ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>( 0 ),
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 13, horizontal: 21)),
            backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).disabledColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Theme.of(context).disabledColor)))));
  }

  Widget buttonUsual({required BuildContext context, required Function onClick, required String text, Widget? icon}){
    return ElevatedButton(onPressed: ()=> onClick.call(), child:
    Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text.toUpperCase(), style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),),
          Padding(
            padding: EdgeInsets.only(left: icon== null? 0 :21),
            child: icon ?? Container(),
          )
        ],
      ),
    ),
        style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>( 0 ),
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 13, horizontal: 21)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(width: 2, color: Theme.of(context).primaryColor)))));
  }


}