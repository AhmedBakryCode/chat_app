import 'package:flutter/material.dart';

class DefaultTextformfield extends StatefulWidget {
  final String hintText;
  final bool ispassword;
  final TextEditingController controller;
  final Icon prefix;

  DefaultTextformfield({
    super.key,
    required this.hintText,
    required this.ispassword,
    required this.controller,
    required this.prefix,
  });

  @override
  State<DefaultTextformfield> createState() => _DefaultTextformfieldState();
}

class _DefaultTextformfieldState extends State<DefaultTextformfield> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.ispassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your ${widget.hintText}';
        }
         return null;
      }
      ,controller: widget.controller,
      obscureText: _isObscured,
      decoration: InputDecoration(
        suffixIcon: widget.ispassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                icon: Icon(
                  _isObscured
                      ? Icons.visibility
                      : Icons.visibility_off_rounded,
                ),
              )
            : null,
        prefixIcon: widget.prefix,
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.tertiary),
        ),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
