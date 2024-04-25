import 'package:flutter/material.dart';
import 'package:mobile/compotents/authbutton.dart';
import 'package:mobile/compotents/authtext.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print('Failed with error code: ${e.code}');
      print(e.message);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Failed with error code: ${e.code}'),
              content: const Text('Неверно введены данные'),
            );
          });
      // это надо будет зафиксить, тут хуй пойми что происходит
      //
      // if (e.code == 'user-not-found') {
      //   wrongEmailDialog();
      // } else if (e.code == 'wrong-password') {
      //   wrongPasswordDialog();
      // }
    }
  }

// не работает
  // void wrongEmailDialog() {
  //   print('Ошибка email');
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return const AlertDialog(
  //           title: Text('Неправильно введён адрес электронной почты'),
  //         );
  //       });
  // }

// не работает
//   void wrongPasswordDialog() {
//     print('Ошибка в пароле');
//     showDialog(
//         context: context,
//         builder: (context) {
//           return const AlertDialog(
//             title: Text('Неправильно введён пароль'),
//           );
//         });
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.house,
                  size: 75,
                  color: Color.fromARGB(255, 131, 99, 158),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Добро пожаловать!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                MyTextField(
                  controller: emailController,
                  hintText: 'Электронная почта',
                  obscureText: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Пароль',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Забыли пароль?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SignButton(
                  onTap: signUserIn,
                  text: 'Войти',
                ),
                const SizedBox(
                  height: 20,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     GestureDetector(
                //       onTap: widget.onTap,
                //       child: const Text(
                //         'Зарегистрироваться',
                //         style: TextStyle(
                //             color: Colors.blue, fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        )));
  }
}
