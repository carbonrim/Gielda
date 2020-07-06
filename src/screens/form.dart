import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:marketplace/src/alerts/upload.dart';
import 'package:marketplace/src/screens/terms.dart';
import 'package:marketplace/src/utils/image_field.dart';
import 'package:marketplace/src/utils/utils.dart';

class FormScreen extends StatefulWidget {
  FormScreen();

  @override
  MyFormState createState() {
    return MyFormState();
  }
}

class MyFormState extends State<FormScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final String _errorText = 'Pole nie może być puste';
  bool showImageError = false;
  var imagePaths = List<String>(3);
  var categories = ['Warzywa', 'Owoce', 'Zboże', 'Inne'];
  var quantityCtrl = TextEditingController();
  var priceCtrl = TextEditingController();

  replaceCommas() {
    if (quantityCtrl.text != null)
      quantityCtrl.text = quantityCtrl.text.replaceAll(new RegExp(r','), '.');
    if (priceCtrl.text != null)
      priceCtrl.text = priceCtrl.text.replaceAll(new RegExp(r','), '.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text('Dodaj produkt'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )),
        body: Builder(
            builder: (context) => SingleChildScrollView(
                child: FormBuilder(
                    key: _fbKey,
                    child: Column(children: <Widget>[
                      FormBuilderDropdown(
                        attribute: "category",
                        decoration: InputDecoration(labelText: "Kategoria"),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Wybierz kategorię')
                        ],
                        items: ['Warzywa', 'Owoce', 'Zboże', 'Inne']
                            .map((category) => DropdownMenuItem(
                                value: categories.indexOf(category),
                                child: Text("$category")))
                            .toList(),
                      ),
                      FormBuilderTextField(
                        attribute: 'name',
                        decoration: InputDecoration(labelText: "Nazwa"),
                        validators: [
                          FormBuilderValidators.required(errorText: _errorText)
                        ],
                      ),
                      FormBuilderTextField(
                        maxLines: 3,
                        attribute: 'description',
                        decoration: InputDecoration(labelText: "Opis"),
                        validators: [
                          FormBuilderValidators.required(errorText: _errorText),
                        ],
                      ),
                      Container(
                        height: 20,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Zdjęcia',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 17,
                              ))),
                      Container(
                        height: 10,
                      ),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ImageField(
                                paths: imagePaths,
                                index: 0,
                              ),
                              ImageField(
                                paths: imagePaths,
                                index: 1,
                              ),
                              ImageField(
                                paths: imagePaths,
                                index: 2,
                              ),
                            ],
                          )),
                      Container(
                        child: showImageError
                            ? Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Wybierz przynajmniej jedno zdjęcie',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromRGBO(210, 50, 50, 1)),
                                    )))
                            : Container(
                                width: 0,
                                height: 0,
                              ),
                      ),
                      FormBuilderTextField(
                        attribute: 'quantity',
                        controller: quantityCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "Ilość (kg)"),
                        validators: [
                          FormBuilderValidators.required(errorText: _errorText),
                          FormBuilderValidators.numeric(
                              errorText: 'Wprowadź liczbę'),
                          FormBuilderValidators.min(0,
                              errorText: 'Wprowadź poprawną ilość')
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: 'price',
                        controller: priceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "Cena (zł/kg)"),
                        validators: [
                          FormBuilderValidators.required(errorText: _errorText),
                          FormBuilderValidators.numeric(
                              errorText: 'Wprowadź liczbę'),
                          FormBuilderValidators.min(0,
                              errorText: 'Wprowadź poprawną cenę'),
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: 'contact',
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Numer kontaktowy",
                        ),
                        validators: [
                          FormBuilderValidators.required(errorText: _errorText),
                          FormBuilderValidators.pattern(r'^[0-9+ ]+$',
                              errorText: 'Podaj prawidłowy numer kontaktowy')
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: 'location',
                        decoration: InputDecoration(
                            labelText: "Adres odbioru",
                            helperText: '(Miejscowość, ulica i nr)'),
                        validators: [
                          FormBuilderValidators.required(errorText: _errorText),
                        ],
                      ),
                      FormBuilderCheckbox(
                        attribute: 'policy',
                        label: Row(
                          children: <Widget>[
                            Text("Przeczytałem i akceptuję "),
                            InkWell(
                                onTap: () {
                                  Utils.pushScreen(context, Terms());
                                },
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Text("politykę prywatności:",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        )))),
                          ],
                        ),
                        validators: [
                          FormBuilderValidators.requiredTrue(
                            errorText:
                                "Akceptuj politykę prywatności, aby kontynuować",
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.all(40),
                          child: FloatingActionButton.extended(
                            heroTag: null,
                            icon: Icon(Icons.done),
                            label: Text('Gotowe',
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                            onPressed: () {
                              setState(() {
                                showImageError =
                                    !imagePaths.any((v) => v != null);
                              });
                              replaceCommas();
                              _fbKey.currentState.save();
                              if (_fbKey.currentState.validate() &&
                                  imagePaths.any((v) => v != null)) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UploadAlert(imagePaths,
                                          _fbKey.currentState.value);
                                    });
                              }
                            },
                          ))
                    ])))));
  }
}
