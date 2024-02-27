// import 'dart:ffi';

import 'package:calculator/cal_buttons/buttons_value.dart';
import 'package:flutter/material.dart';

class CalculateScreen extends StatefulWidget {
  const CalculateScreen({super.key});

  @override
  State<CalculateScreen> createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  String number1 = ""; // right side of my cal . 0-9
  String oprands = ""; // my operation + - / *
  String number2 = ""; // left side of my cal . 0-9
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "$number1$oprands$number2".isEmpty
                        ? "0"
                        : "$number1$oprands$number2",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: btn.buttonValues
                  .map(
                    (value) => SizedBox(
                        width: [btn.n0].contains(value)
                            ? screenSize.width / 2
                            : (screenSize.width) / 4,
                        height: screenSize.width / 5,
                        child: buildBottons(value)),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBottons(value) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Material(
        color: getButtonColors(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => getInputValue(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }

  ////////////////
  void getInputValue(String value) {
    if (value == btn.del) {
      deleteIndex();
      return;
    }
    if (value == btn.clr) {
      clearAll();
      return;
    }
    if (value == btn.per) {
      convertToPercentage();
      return;
    }
    if (value == btn.calculate) {
      calculateValue();
      return;
    }

    appendValues(value);
  }

  ///////////

  void calculateValue() {
    if (number1.isEmpty) return;
    if (oprands.isEmpty) return;
    if (number2.isEmpty) return;

    final numOne = double.parse(number1);
    final numTwo = double.parse(number2);

    var result = 0.0;

    switch (oprands) {
      case btn.add:
        result = numOne + numTwo;
        break;
      case btn.multiply:
        result = numOne * numTwo;
        break;
      case btn.subtract:
        result = numOne - numTwo;
        break;
      case btn.divide:
        result = numOne / numTwo;
        break;
      default:
    }
    setState(() {
      number1 = "$result";
      // result = "{$number1}" as double;
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      oprands = "";
      number2 = "";
    });
  }

  //////
  void deleteIndex() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (oprands.isNotEmpty) {
      oprands = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  /////////

  void convertToPercentage() {
    if (number1.isNotEmpty && oprands.isNotEmpty && number2.isNotEmpty) {
      // means if 454+656 not empty
      calculateValue();
    }
    if (oprands.isNotEmpty) {
      // we have 55+ or - it will not convert.
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      oprands = "";
      number2 = "";
    });
  }

  //////////
  void clearAll() {
    setState(() {
      number1 = "";
      oprands = '';
      number2 = "";
    });
  }

///////////
  void appendValues(value) {
    /// seperating operands from numbers and dot .
    if (value != btn.dot && int.tryParse(value) == null) {
      if (oprands.isNotEmpty && number1.isNotEmpty) {
        calculateValue();
      }
      oprands = value;
      // working on number1...
    } else if (number1.isEmpty || oprands.isEmpty) {
      // means when we add number one and the add operand we cant add numbers one again
      // when number1 is "4.5" it shouldnt add another btn.dot.
      if (value == btn.dot && number1.contains(btn.dot)) return;
      if (value == btn.n0 && number1.isEmpty && number2.isEmpty) return;
      if (value == btn.dot && number1.isEmpty && number2.isEmpty) {
        value = "0.";
      }
      if (value == btn.dot && number1.isEmpty && number1 == btn.n0) {
        // if number1 is "" or number is "0"
        value = "0.";
      }
      number1 += value;
    } else if (number2.isEmpty || oprands.isNotEmpty) {
      // means when we add number one and the add operand we cant add numbers one again
      // when number1 is "4.5" it shouldnt add another btn.dot.
      if (value == btn.dot && number2.contains(btn.dot)) return;
      if (value == btn.dot && number2.isEmpty || number2 == btn.n0) {
        // if number1 is "" or number is "0"
        value = "0.";
      }
      number2 += value;
    }
    setState(() {});
  }

////////////////
  getButtonColors(value) {
    return [btn.del, btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            btn.per,
            btn.multiply,
            btn.add,
            btn.subtract,
            btn.divide,
            btn.calculate
          ].contains(value)
            ? Colors.orange[700]
            : Colors.black54;
  }
}
