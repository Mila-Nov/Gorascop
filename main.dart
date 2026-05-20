import 'package:flutter/material.dart';
//пакет для экрана
import 'dart:math';
//для рандома
void main() {
  runApp(const AstroApp());
}
class User {
  final String login;
  final String password;
//первый и последний раз = final
  //String - наша строка
//конструктор пользователя
  User({
    required this.login,
    required this.password,
    //required - обязательность заполнения
  });
}
//StatefulWidget нужен чтобы изменить экран и данные
class AstroApp extends StatefulWidget {
  const AstroApp({super.key});

  @override
  State<AstroApp> createState() => _AstroAppState();
}

class _AstroAppState extends State<AstroApp> {
  //список для хранения всех пользователей
  final List<User> users =[];
  /*
  ========================================
  ДОБАВИЛИ ТЕКУЩЕГО ПОЛЬЗОВАТЕЛЯ
  ========================================
  Если currentUser == null
  значит никто не вошел.
  */

  User? currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /*
      ========================================
      ЕСЛИ НЕ ВОШЛИ → LOGIN PAGE
      ЕСЛИ ВОШЛИ → ASTRO PAGE
      ========================================
      */

      home: currentUser == null
          ? LoginPage(
            //передаём список пользователей
              users: users,

              /*
              ========================================
              КОГДА ПОЛЬЗОВАТЕЛЬ ВОШЕЛ
              ========================================
              */

              onLogin: (user) {
                //обновить экран
                setState(() {
                  //передаём текущего пользователя в переменную
                  currentUser = user;
                });
              },
            )
          : AstroPage(
              user: currentUser!,

              /*
              ========================================
              ВЫХОД ИЗ АККАУНТА
              ========================================
              */

              onLogout: () {
                setState(() {
                  currentUser = null;
                });
              },
            ),
    );
  }
}
/*
========================================
ЭКРАН ВХОДА
========================================
*/

class LoginPage extends StatefulWidget {
  final List<User> users;
  final Function(User) onLogin;
//принимает пользователя когда успешный вход - Function(User)
  const LoginPage({
    super.key,
    required this.users,
    required this.onLogin,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /*
  ========================================
  КОНТРОЛЛЕРЫ ДЛЯ ПОЛЕЙ ВВОДА считывает что ввёл пользователь
  ========================================
  */

  final TextEditingController loginController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();
//переменная для текста ошибки
  String errorText = '';

  void login() {
    //берут текст из полей
    final login = loginController.text;
    final password = passwordController.text;

    /*
    ========================================
    ПРОВЕРКА ПОЛЬЗОВАТЕЛЕЙ
    ========================================
    */

    for (var user in widget.users) {
      if (//проверка на совпадение
        user.login == login &&
        user.password == password
      ) {
        widget.onLogin(user);
        return;
        //остановка поиска
      }
    }

    setState(() {
      errorText = 'Неверный логин или пароль';
    });
  }

  void openRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(
          users: widget.users,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,

      appBar: AppBar(
        title: const Text('Вход'),
      ),

      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),

          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                const Text(
                  'Авторизация',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /*
                ========================================
                ПОЛЕ ЛОГИНА
                ========================================
                */

                TextField(
                  controller: loginController,
                  decoration: const InputDecoration(
                    labelText: 'Логин',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                /*
                ========================================
                ПОЛЕ ПАРОЛЯ
                ========================================
                */

                TextField(
                  controller: passwordController,
                  obscureText: true,

                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  errorText,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),

                const SizedBox(height: 12),

                /*
                ========================================
                КНОПКА ВХОДА
                ========================================
                */

                ElevatedButton(
                  onPressed: login,
                  child: const Text('Войти'),
                ),

                const SizedBox(height: 12),

                /*
                ========================================
                КНОПКА РЕГИСТРАЦИИ
                ========================================
                */

                OutlinedButton(
                  onPressed: openRegisterPage,
                  child: const Text('Регистрация'),
                ),
              ],
),
          ),
        ),
      ),
    );
  }
}
/*
========================================
ЭКРАН РЕГИСТРАЦИИ
========================================
*/

class RegisterPage extends StatefulWidget {
  final List<User> users;

  const RegisterPage({
    super.key,
    required this.users,
  });

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {

  final TextEditingController loginController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  String infoText = '';

  void register() {
    final login = loginController.text;
    final password = passwordController.text;

    /*
    ========================================
    ПРОВЕРКА НА ПУСТЫЕ ПОЛЯ при помощи is empty
    ========================================
    */

    if (login.isEmpty || password.isEmpty) {
      setState(() {
        infoText = 'Заполните поля';
      });

      return;
    }

    /*
    ========================================
    СОЗДАЕМ НОВОГО ПОЛЬЗОВАТЕЛЯ
    ========================================
    */

    widget.users.add(
      User(
        login: login,
        password: password,
      ),
    );

    setState(() {
      infoText = 'Пользователь создан';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,

      appBar: AppBar(
        title: const Text('Регистрация'),
      ),

      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),

          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                const Text(
                  'Регистрация',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: loginController,

                  decoration: const InputDecoration(
                    labelText: 'Логин',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: passwordController,
                  obscureText: true,

                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  infoText,
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: register,
                  child: const Text('Создать аккаунт'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//для знака зодиака
class ZodiacSign {
  final String name;
  final String emoji;

  const ZodiacSign({required this.name, required this.emoji});
}

class AstroPage extends StatefulWidget {
  //пользователь который вошёл
  final User user;
//выход из аккаунта
  final VoidCallback onLogout;

  const AstroPage({
    super.key,
    required this.user,
    required this.onLogout,
  });

  @override
  State<AstroPage> createState() => _AstroPageState();
}

class _AstroPageState extends State<AstroPage> {
  final Random random = Random();

  ZodiacSign selectedSign = const ZodiacSign(name: 'Овен', emoji: '♈');
  String text = 'Нажми кнопку и получи гороскоп 🔮';
int luck = 0;
  int popitka = 0;
  String getLuckStatus() {
  if (luck >= 80) {
    return 'Супер удача 🔥';
  } else if (luck >= 50) {
    return 'Нормальный день 😎';
  } else if (luck >= 25) {
    return 'Будь внимательнее 👀';
  } else {
    return 'День для осторожных решений 🧘';
  }
}
  final List< String > history = [];
  
  final List<ZodiacSign> zodiacSigns = const [
    ZodiacSign(name: 'Овен', emoji: '♈'),
    ZodiacSign(name: 'Телец', emoji: '♉'),
    ZodiacSign(name: 'Близнецы', emoji: '♊'),
    ZodiacSign(name: 'Рак', emoji: '♋'),
    ZodiacSign(name: 'Лев', emoji: '♌'),
    ZodiacSign(name: 'Дева', emoji: '♍'),
    ZodiacSign(name: 'Весы', emoji: '♎'),
    ZodiacSign(name: 'Скорпион', emoji: '♏'),
    ZodiacSign(name: 'Стрелец', emoji: '♐'),
    ZodiacSign(name: 'Козерог', emoji: '♑'),
    ZodiacSign(name: 'Водолей', emoji: '♒'),
    ZodiacSign(name: 'Рыбы', emoji: '♓'),
  ];

  final List<String> predictions = [
    'Сегодня тебя ждёт удача!',
    'Хороший день для новых идей!',
    'Не спеши — сегодня важно подумать.',
    'Будь внимателен к деталям.',
    'День принесёт неожиданные приятные сюрпризы!',
    'Отличный момент для саморазвития.',
    'Возможны новые знакомства.',
    'Прислушайся к своей интуиции.',
    'Смело берись за новые проекты.',
    'Время для отдыха и восстановления сил.',
  ];
final List<String> predictionsSecret = ['✨ Секретный прогноз: сегодня ты легенда!',
  '🌌 Вселенная выбрала тебя для особой миссии.',
  '🔥 Редкий прогноз: удача сегодня на максимуме!',];
  void getPrediction() {
    setState(() {
      
      bool isSecret = random.nextInt(100)<10;
      if(isSecret){
         text = predictionsSecret[random.nextInt(predictionsSecret.length)];
      }else{ text = predictions[random.nextInt(predictions.length)];}
     
    luck = random.nextInt(101);
      popitka++;
      history.insert(0,'${selectedSign.emoji} ${selectedSign.name} $text удача $luck%');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(title:  Text('Привет ${widget.user.login} это твой Гороскоп 🔮'),actions: [
          IconButton(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
          ),
        ], ),
      body: SingleChildScrollView(
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Мой гороскоп',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButton<ZodiacSign>(
                  value: selectedSign,
                  items: zodiacSigns.map<DropdownMenuItem<ZodiacSign>>((
                    ZodiacSign sign,
                  ) {
                    return DropdownMenuItem<ZodiacSign>(
                      value: sign,
                      child: Text('${sign.emoji} ${sign.name}'),
                    );
                  }).toList(),
                  onChanged: (ZodiacSign? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedSign = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: getPrediction,
                  child: const Text('Получить гороскоп'),
                ),
                const SizedBox(height: 10),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 10),
                Text(
                  'Ваша удача $luck% ${getLuckStatus()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
               
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                value:luck/100),
                              const SizedBox(height: 14),
                Text(
                  'Ваши попытки $popitka ',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
               
               ),
                

                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryPage(history: history),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('История'),
                  ),
              ],
            ),
          ),
        ),
      ),
        ),
    );
  }
}

class HistoryPage extends StatelessWidget{
  
  final List< String > history;
  const HistoryPage({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История прогнозов 📜'),
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'История пока пустая',
                style: TextStyle(fontSize: 22),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.star),
                  title: Text(history[index]),
                );
              },
            ),
    );
  }
}
