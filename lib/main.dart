import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 58, 196, 209),
        backgroundColor: const Color.fromARGB(255, 17, 18, 29),
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<String> operators = ['/', 'x', '-', '+', '%'];

  String _output = '0';
  String get output => _output;

  bool _result = false;

  numberPressed(String number) {
    if (_result) {
      _output = '';
      _result = false;
    }
    setState(() {
      _output = '$_output$number';
    });
  }

  operationPressed(String operator) {
    if (output != '') {
      final last = output[output.length - 1];

      switch (operator) {
        case '.':
          final regEx = RegExp(r'[^\d\.]');
          final arrayData = output.split(regEx);

          if (!arrayData[arrayData.length - 1].contains('.')) {
            numberPressed(operator);
          }
          break;
        case 'del':
          setState(() {
            _output = _output.substring(0, _output.length - 1);
          });
          break;

        case 'C':
          setState(() {
            _output = '';
          });
          break;

        case '=':
          result();
          break;

        default:
          if (!operators.contains(last) && !_result) {
            numberPressed(operator);
          } else if (operators.contains(last)) {
            setState(() {
            _output = _output.substring(0, _output.length - 1) + operator;
            });
          } else {
            _result = false;
            numberPressed(operator);
          }
          break;
      }
    }
  }

  void result() {
    final last = output[output.length - 1];
    if (!operators.contains(last)) {
      _output = _output.replaceAll('x', '*');

      Parser p = Parser();
      ContextModel cm = ContextModel();
      RegExp regex = RegExp(r"([.]*0+)(?!.*\d)");

      String exp =
          p.parse(_output).evaluate(EvaluationType.REAL, cm).toStringAsFixed(3);

      _result = true;
      setState(() {
        _output = exp.toString().replaceAll(regex, '');
      });
    }
  }

  Widget display() {
    return Container(
      width: Size.infinite.width,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Text(_output,
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w400,
                )),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget buttons() {
    return Container(
      clipBehavior: Clip.none,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(children: [
            operationButton('C'),
            numberButton('1'),
            numberButton('4'),
            numberButton('7'),
            numberButton('00'),
          ]),
          Column(
            children: [
              operationButton('del'),
              numberButton('2'),
              numberButton('5'),
              numberButton('8'),
              numberButton('0'),
            ],
          ),
          Column(
            children: [
              operationButton('x'),
              numberButton('3'),
              numberButton('7'),
              numberButton('9'),
              operationButton('.'),
            ],
          ),
          Column(
            children: [
              operationButton('%'),
              operationButton('-'),
              operationButton('+'),
              operationButton('/'),
              operationButton('='),
            ],
          ),
        ],
      ),
    );
  }

  Widget numberButton(String text) {
    var buttonStyle = ElevatedButton.styleFrom(
      primary: const Color.fromARGB(255, 23, 25, 36),
      elevation: 0,
    );
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(1),
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: () => numberPressed(text),
        child: Text(text,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w400,
            )),
      ),
    );
  }

  Widget operationButton(String text) {
    var buttonStyle = ElevatedButton.styleFrom(
      primary: const Color.fromARGB(255, 30, 25, 36),
      elevation: 0,
    );
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(1),
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: () => operationPressed(text),
        child: Text(text,
            style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 58, 196, 209))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: [
            const Expanded(child: SizedBox()),
            display(),
            buttons(),
          ],
        ),
      ),
    );
  }
}
