import 'package:flutter/material.dart';
import 'package:vqa_graduation_project/go_router/app_router.dart';
import 'package:vqa_graduation_project/services/auth_services.dart';

class DefaultDrawer extends StatelessWidget {
  const DefaultDrawer({super.key});

  @override
  Widget build(BuildContext context) {

        final AuthService _authService = AuthService();

  void _onTap(BuildContext context) async {
    await _authService.signOut();
    Navigator.pushReplacementNamed(context, AppRouter.login);
  }

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
           DrawerHeader(
            decoration: BoxDecoration(
              color:Theme.of(context).colorScheme.secondary,
            ),
            child: Icon( size: 50,Icons.message,color: Theme.of(context).colorScheme.primary,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading:  Icon(Icons.home ,color: Theme.of(context).colorScheme.primary,),
              title:  Text('H O M E' ,style: TextStyle( color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold),),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),

                   Expanded(
                     child: Padding(
                       padding: const EdgeInsets.only(left: 25.0),
                       child: ListTile(
                                   leading:  Icon(Icons.settings ,color: Theme.of(context).colorScheme.primary,),
                                   title:  Text('S E T T I N G' ,style: TextStyle( color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold),),
                                   onTap: ()=> Navigator.pushNamed(context, AppRouter.settings),
                                 
                               ),
                     ),
                   )

        ,Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading:  Icon(Icons.logout ,color: Theme.of(context).colorScheme.primary,),
              title:  Text('L O G O U T' ,style: TextStyle( color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold),),
              onTap: ()=> _onTap(context),
            
                    ),
          ),

        ]
    ));
  }
}