import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_homework/pages/user_infopage.dart';

import '../model/user.dart';

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({Key? key}) : super(key: key);

  @override
  RegisterFormPageState createState() => RegisterFormPageState();
}

class RegisterFormPageState extends State<RegisterFormPage> {
  bool _hidePass = true;

  final _formKey = GlobalKey<FormState>();
  // final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _statusController = TextEditingController();
  final _passController = TextEditingController();
  final _conPassController = TextEditingController();

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();

  User newUser = User();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _statusController.dispose();
    _passController.dispose();
    _conPassController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  void _fieldFocusChanged(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  final List<String> _countries = ['Russia', 'Ukraine', 'Germany', 'Spain'];
  String? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Register Form'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              focusNode: _nameFocus,
              autofocus: true,
              onFieldSubmitted: (_) {
                _fieldFocusChanged(context, _nameFocus, _phoneFocus);
              },
              controller: _nameController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _nameController.clear();
                    },
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.blue, width: 2)),
                  labelText: 'Full name *',
                  hintText: 'Enter you name'),
              validator: _validateName,
              onSaved: (value) => newUser.name = value,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                focusNode: _phoneFocus,
                onFieldSubmitted: (_) {
                  _fieldFocusChanged(context, _phoneFocus, _passFocus);
                },
                controller: _phoneController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  suffixIcon: GestureDetector(
                    onLongPress: () {
                      _phoneController.clear();
                    },
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.blue, width: 2)),
                  labelText: 'Phone number *',
                  hintText: 'Enter your number',
                  helperText: '(XXX)XXX-XXXX',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp(r'^[()\d -]{1,15}$'),
                      allow: true),
                  //FilteringTextInputFormatter.digitsOnly,
                ],
                onSaved: (value) => newUser.phone = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  } else {
                    final isValid = _validatePhoneNumber(value);
                    if (!isValid) {
                      return 'Phone number uncorrected';
                    }
                    return null;
                  }
                }),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email address ',
                hintText: 'Enter email address',
                icon: Icon(Icons.alternate_email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              onSaved: (value) => newUser.email = value,
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.map),
                  labelText: 'Country?'),
              items: _countries.map((country) {
                return DropdownMenuItem(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (country) {
                debugPrint(country);
                setState(
                  () {
                    _selectedCountry = country!;
                    newUser.country = country;
                  },
                );
              },
              value: _selectedCountry,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _statusController,
              decoration: const InputDecoration(
                labelText: 'Status',
                hintText: 'Tell about yourself',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              onSaved: (value) => newUser.status = value,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              focusNode: _passFocus,
              controller: _passController,
              obscureText: _hidePass,
              maxLength: 8,
              decoration: InputDecoration(
                labelText: 'Password *',
                hintText: 'Enter your password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _hidePass = !_hidePass;
                    });
                  },
                  icon:
                      Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
                ),
                icon: const Icon(Icons.security),
              ),
              validator: _validatePassword,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _conPassController,
              obscureText: _hidePass,
              maxLength: 8,
              decoration: const InputDecoration(
                labelText: 'Confirm password *',
                hintText: 'Confirm your password',
                icon: Icon(Icons.border_color),
              ),
              validator: _validatePassword,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _submitForm();
              },
              child: const Text('Submit form'),
            )
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      _showDialog(name: _nameController.text);
      debugPrint('------------------------------');
      debugPrint('Name: ${_nameController.text}');
      debugPrint('Phone: ${_phoneController.text}');
      debugPrint('Email: ${_emailController.text}');
      debugPrint('Country: $_selectedCountry');
      debugPrint('Status: ${_statusController.text}');
    } else {
      _showMessage(message: 'Form is not valid! Please correct!');
    }
  }

  String? _validateName(String? value) {
    final nameExp = RegExp(r'^[A-Za-z]+$');
    if (value!.isEmpty) {
      return 'Name is required';
    } else if (!nameExp.hasMatch(value)) {
      return 'Please enter alphabetical characters';
    } else {
      return null;
    }
  }

  bool _validatePhoneNumber(String input) {
    final phoneExp = RegExp(r'^\(\d\d\d\)\d\d\d-\d\d\d\d$');
    return phoneExp.hasMatch(input);
  }

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Email cannot be empty';
    } else if (!_emailController.text.contains('@')) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  String? _validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Password cannot be empty';
    } else if (_passController.text.length != 8) {
      return 'Password must be 8 characters';
    } else if (_conPassController.text != _passController.text) {
      return 'Password mismatch';
    } else {
      return null;
    }
  }

  void _showMessage({String? message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
      content: Text(
        message!,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    ));
  }

  void _showDialog({String? name}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Registration successful!',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            content: Text(
              '$name is now a verified register form',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserInfoPage(
                        userInfo: newUser,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Verified',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
