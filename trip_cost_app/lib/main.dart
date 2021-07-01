import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Cost Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FuelForm(title: 'Trip Cost Calculator'),
    );
  }
}

class FuelForm extends StatefulWidget {
  FuelForm({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FuelFormState createState() => _FuelFormState();
}

class _FuelFormState extends State<FuelForm> {
  String _result = '';
  final _currencies = ['Dollars', 'Euro', 'Pounds'];
  String? _currency = 'Dollars';
  TextEditingController distanceController = TextEditingController();
  TextEditingController mpgController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.headline6;
    const double _formDistance = 5.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: _formDistance,
                bottom: _formDistance,
              ),
              child: TextField(
                controller: distanceController,
                decoration: InputDecoration(
                  labelText: 'Distance',
                  labelStyle: textStyle,
                  hintText: "e.g. 124",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: _formDistance,
                bottom: _formDistance,
              ),
              child: TextField(
                controller: mpgController,
                decoration: InputDecoration(
                  labelText: 'Miles per Gallon',
                  labelStyle: textStyle,
                  hintText: "e.g. 32",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: _formDistance,
                      bottom: _formDistance,
                    ),
                    child: TextField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: 'Price per Gallon',
                        labelStyle: textStyle,
                        hintText: "e.g. 3.49",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: _formDistance * 5),
                    child: DropdownButton(
                      items: _currencies.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) => _onDropdownChanged(value),
                      value: _currency,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _result = _calculate();
                      });
                    },
                    child: Text(
                      'Submit',
                      textScaleFactor: 1.5,
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).buttonColor,
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColorDark,
                      ),
                    ),
                    onPressed: _resetForm,
                    child: Text(
                      "Reset",
                      textScaleFactor: 1.5,
                    ),
                  ),
                )
              ],
            ),
            Text(_result),
          ],
        ),
      ),
    );
  }

  void _resetForm() {
    distanceController.clear();
    mpgController.clear();
    priceController.clear();

    setState(() {
      this._result = "";
    });
  }

  _onDropdownChanged(String? value) {
    setState(() {
      this._currency = value;
    });
  }

  String _calculate() {
    double _distance = double.parse(distanceController.text);
    double _fuelCost = double.parse(priceController.text);
    double _consumption = double.parse(mpgController.text);

    double _totalCost = _distance * _fuelCost / _consumption;
    String _result =
        'The total cost of your trip is ${_totalCost.toStringAsFixed(2)} $_currency';

    return _result;
  }
}
