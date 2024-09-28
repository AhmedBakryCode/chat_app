import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vqa_graduation_project/themes/themes_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar( title: Text("Settings"),foregroundColor: Colors.grey,backgroundColor: Colors.transparent,),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
      Container(
        margin: EdgeInsets.all(25),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        Text("Dark mode "),
        
        CupertinoSwitch(activeColor: Colors.green,value:  Provider.of<ThemesProvider>(context,listen:false,).isDarkMode , onChanged: (value) {
        
          Provider.of<ThemesProvider>(context,listen:false,).toggleTheme(value);
        },)
          ],
        ),
      )          ],
          ),
        ),
      ),
    );
  }
}