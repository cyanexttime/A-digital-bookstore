import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userEmail = user.email;
    final displayName = user.displayName ?? '';
    final phoneNumber = user.phoneNumber ?? '';

    final profileQuery = await FirebaseFirestore.instance
        .collection('profiles')
        .where('email', isEqualTo: userEmail)
        .get();
    
    if (profileQuery.docs.isNotEmpty) {
      final profileData = profileQuery.docs.first.data();
      setState(() {
        _nameController.text = profileData['name'];
        _emailController.text = profileData['email'];
        _phoneNumberController.text = profileData['phoneNumber'];
        if (profileData['dateOfBirth'] != null) {
          _selectedDate = DateTime.parse(profileData['dateOfBirth']);
        }
      });
    } else {
      FirebaseFirestore.instance.collection('profiles').add({
        'name': displayName,
        'email': userEmail,
        'phoneNumber': phoneNumber,
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile created successfully')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create profile: $error')),
        );
      });
    }
  }
}


  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^\d{10,15}$');
    return regex.hasMatch(phoneNumber);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveProfile() async {
  if (_formKey.currentState!.validate()) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final email = user.email;
      final displayName = user.displayName ?? _nameController.text;
      final phoneNumber = user.phoneNumber ?? _phoneNumberController.text;
      final profileQuery = await FirebaseFirestore.instance
          .collection('profiles')
          .where('email', isEqualTo: email)
          .get();
      if (profileQuery.docs.isNotEmpty) {
        final docId = profileQuery.docs.first.id;
        FirebaseFirestore.instance.collection('profiles').doc(docId).update({
          'name': _nameController.text.isEmpty ? displayName : _nameController.text,
          'phoneNumber': _phoneNumberController.text.isEmpty ? phoneNumber : _phoneNumberController.text,
          'dateOfBirth': _selectedDate?.toIso8601String().split('T').first,
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: $error')),
          );
        });
      } else {
        FirebaseFirestore.instance.collection('profiles').add({
          'name': _nameController.text.isEmpty ? displayName : _nameController.text,
          'email': email,
          'phoneNumber': _phoneNumberController.text.isEmpty ? phoneNumber : _phoneNumberController.text,
          'dateOfBirth': _selectedDate?.toIso8601String().split('T').first,
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile created successfully')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create profile: $error')),
          );
        });
      }
    }
  }
}
  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : const Color(0xFFF1DCD1);
    final Color textColor =
        Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF219F94),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: backgroundColor,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  readOnly:true,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: backgroundColor,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    } else if (!_isValidEmail(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    filled: true,
                    fillColor: backgroundColor,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!_isValidPhoneNumber(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            
                            hintText: _selectedDate != null
                                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                : 'Select Date of Birth',
                            filled: true,
                            fillColor: backgroundColor,
                          ),
                          child: Text(
                            _selectedDate != null
                                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                : 'Select Date of Birth',
                            style: TextStyle(
                              color: _selectedDate != null
                                  ? textColor
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: const Color(0xFF219F94),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                      ),
                      child: const Text(
                        'Save Profile',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }
}
