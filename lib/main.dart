import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyCalculator());

class MyCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorPage(title: 'Flutter Calculator'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatefulWidget {
  CalculatorPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  double result = 0;
  String operation = '';

  final List<String> letters = [
    'C',
    '√',
    '%',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    'Del',
    '0',
    '.',
    '='
  ];

  List<String> getOperationParts(List<String> mathOperators) {
    String matchedOperator;
    mathOperators.forEach((op) {
      if (operation.contains(op)) {
        matchedOperator = op;
      }
    });
    if (matchedOperator == null) {
      return null;
    }
    List<String> operationItems = operation.split(matchedOperator);
    if (operationItems[0].length == 0 || operationItems[1].length == 0) {
      return null;
    }
    return [matchedOperator, operationItems[0], operationItems[1]];
  }

  void handleEqualsButton(List<String> operationParts) {
    if (operationParts == null) return null;
    double result =
        calculate(operationParts[0], operationParts[1], operationParts[2]);
    setState(() {
      operation = beautifyNumber(result);
    });
  }

  void handleClearButton() {
    setState(() {
      operation = '';
    });
  }

  void handleDeleteButton() {
    setState(() {
      operation = operation.length > 0
          ? operation.substring(0, operation.length - 1)
          : operation;
    });
  }

  void handleSquareRootButton(List<String> operationParts) {
    if (operationParts == null) {
      setState(() {
        operation = beautifyNumber(sqrt(double.parse(operation)));
      });
    }
  }

  void handleButton(
      String button, List<String> mathOperators, List<String> operationParts) {
    if (operation.length == 0) {
      setState(() {
        operation = button;
      });
    } else if (operation.length > 0) {
      String lastOperationItem = operation[operation.length - 1];
      if (mathOperators.contains(button) &&
          mathOperators.contains(lastOperationItem)) {
        setState(() {
          operation = operation.substring(0, operation.length - 1) + button;
        });
        return;
      }
      if (operationParts == null) {
        setState(() {
          operation += button;
        });
      } else {
        double result =
            calculate(operationParts[0], operationParts[1], operationParts[2]);
        setState(() {
          operation = beautifyNumber(result) + button;
        });
      }
    }
  }

  void onButtonPressed(String button) {
    const List<String> mathOperators = ['+', '-', 'x', '/', '%'];
    List<String> operationParts = getOperationParts(mathOperators);
    switch (button) {
      case '=':
        return handleEqualsButton(operationParts);
      case 'C':
        return handleClearButton();
      case 'Del':
        return handleDeleteButton();
      case '√':
        return handleSquareRootButton(operationParts);
      default:
        return handleButton(button, mathOperators, operationParts);
    }
  }

  double calculate(sign, item1, item2) {
    item1 = double.parse(item1);
    item2 = double.parse(item2);
    double result;
    switch (sign) {
      case '+':
        result = item1 + item2;
        break;
      case '-':
        result = item1 - item2;
        break;
      case 'x':
        result = item1 * item2;
        break;
      case '/':
        result = item1 / item2;
        break;
      case '%':
        result = item1 % item2;
        break;
    }
    return result;
  }

  String beautifyNumber(double number) {
    if (number.truncateToDouble() == number) {
      return number.toStringAsFixed(0);
    }
    return number.toString();
  }

  Color getButtonBackgroundColor(text) {
    if (text == '=') return Colors.orange;
    return int.tryParse(text) == null && text != '.'
        ? Colors.orangeAccent
        : Colors.black26;
  }

  Widget renderButton(text) {
    if (text == null) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: getButtonBackgroundColor(text),
      ),
      child: FlatButton(
        child: Text(
          text,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
        ),
        onPressed: () => onButtonPressed(text),
      ),
    );
  }

  List<Widget> renderButtons() {
    List<Widget> widgets = [];
    letters.forEach((letter) => widgets.add(renderButton(letter)));
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Column(children: <Widget>[
              Center(
                child: Text(
                  operation,
                  style: Theme.of(context).textTheme.display2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ]),
            Expanded(
              flex: 3,
              child: GridView.count(
                crossAxisCount: 4,
                children: renderButtons(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
