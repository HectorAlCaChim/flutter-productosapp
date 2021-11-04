import 'dart:html';

import 'package:flutter/material.dart';
import 'package:productosapp/providers/login_form_provider.dart';
import 'package:productosapp/ui/input_decorations.dart';
import 'package:productosapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Text('Login', style: Theme.of(context).textTheme.headline4,),
                    SizedBox(height: 30,),
                    // controla el estado del login form
                    ChangeNotifierProvider(
                      create: (_) => LoginFormPorvider(),
                      child: _LoginForm(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50,),
              Text('Crear una Nueva cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
            ],
          ),
        )
      ),
    );
  }
}
class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormPorvider>(context);
    return Container(
      child: Form(
        key: loginForm.fromKey,
        // mantenar su referencia
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'name.correo@email.com',
                labelText: 'Correo Electronico',
                prefixIcon: Icons.alternate_email_sharp,
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);
                return regExp.hasMatch(value ?? '') ? null : 'Correo Invalido';
              },
            ),
            SizedBox(height: 20,),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*********',
                labelText: 'Cotraseña',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) => loginForm.pasword = value,
              validator: (value) {
                if (value != null && value.length >= 6 ) {
                  return null;
                }
                return 'La constraseña debe de ser 6 caracteres';
              },
            ),
            SizedBox(height: 20,),

            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading ? 'Espera':
                  'Ingresar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: loginForm.isLoading ? null : () async {
                FocusScope.of(context).unfocus(); // quitar teclado
                if (!loginForm.isValidForm()) return;

                loginForm.isLoading = true;

                Future.delayed(Duration(seconds: 2));

                Navigator.pushReplacementNamed(context, 'home');
              },
            )
          ],
        ),
      ),
    );
  }
}