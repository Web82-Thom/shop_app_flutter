import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class EditProductScreen extends StatefulWidget {
static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edition d\'un article'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
          child: Form(
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Titre'),
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
          ),
      ) ,
    );
  }
}
