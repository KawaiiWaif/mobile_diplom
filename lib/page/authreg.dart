import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/compotents/authbutton.dart';
import 'package:mobile/compotents/authtext.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fioController = TextEditingController();

  void signUserUp() async {
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
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(title: Text('Пароли не совпадают'));
            });
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
        backgroundColor: Colors.grey[300],
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
                  Icons.lock,
                  size: 75,
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Регистрация',
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
                  height: 10,
                ),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Повторите пароль',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                MyTextField(
                  controller: fioController,
                  hintText: 'Введите ФИО',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                SignButton(
                  onTap: signUserUp,
                  text: 'Зарегистрироваться',
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Уже зарегистрированы? '),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Авторизируйтесь',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )));
  }
}
