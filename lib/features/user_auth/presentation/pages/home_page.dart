//import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'bar_graph_page.dart';
import 'package:intl/intl.dart';
//import 'package:flutter/src/material/date_picker_theme.dart' as MaterialDatePickerTheme;
//import 'package:flutter_datetime_picker/src/datetime_picker_theme.dart' as DateTimePickerTheme;



import '../../../../global/common/toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 100.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'COMPANION APP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  // Get the current time
                  DateTime now = DateTime.now();
                  
                  // Get the current hour
                  int currentHour = now.hour;
                  
                  // Check if the current hour is between 4:00 PM and 11:59 PM
                  if (currentHour >= 10 && currentHour <= 23) {
                    // Navigate to Page 2
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Page2()),
                    );
                  } else {
                    // Navigate to Page 4
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Page4()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "LET'S GET STARTED",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 20.0,
            right: 20.0,
            child: GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, "/login");
                showToast(message: "Successfully signed out");
              },
              child: Container(
                height: 45,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Sign out",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'lib/assets/homebackground.gif',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height / 2,
            ),
          ),
        ],
      ),
    );
  }
}               


//
class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hey Companion!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hey Companion!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36.0,
                    ),
                  ),
                  Text(
                    'Hope you are doing good!',
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Page3()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Tell me about today's status",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Insert your GIF here
          Container(
            width: MediaQuery.of(context).size.width, // Full width
            height: MediaQuery.of(context).size.height / 2, // Half of the screen height
            child: Image.asset(
              'lib/assets/hope.gif', // Replace 'your_gif.gif' with your GIF asset path
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

//

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  bool? _happySelected;
  bool? _sadSelected;
  bool? _neutralSelected;

  bool? _productivityYes;
  bool? _productivityNo;
  bool? _productivityMaybe;
  bool? _productivityNotSure;

  bool? _challengesYes;
  bool? _challengesNo;
  bool? _challengesMaybe;
  bool? _challengesNotSure;

  bool? _leisureYes;
  bool? _leisureNo;
  bool? _leisureMaybe;
  bool? _leisureNotSure;

  double _rating = 5;

  SharedPreferences? _prefs;
  late String _keyPrefix;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _keyPrefix = DateTime.now().toString().split(' ')[0];
    _loadUserSelections();
  }

  void _loadUserSelections() {
    setState(() {
      _happySelected = _prefs!.getBool('$_keyPrefix-happy') ?? false;
      _sadSelected = _prefs!.getBool('$_keyPrefix-sad') ?? false;
      _neutralSelected = _prefs!.getBool('$_keyPrefix-neutral') ?? false;

      _productivityYes = _prefs!.getBool('$_keyPrefix-productivityYes') ?? false;
      _productivityNo = _prefs!.getBool('$_keyPrefix-productivityNo') ?? false;
      _productivityMaybe = _prefs!.getBool('$_keyPrefix-productivityMaybe') ?? false;
      _productivityNotSure = _prefs!.getBool('$_keyPrefix-productivityNotSure') ?? false;

      _challengesYes = _prefs!.getBool('$_keyPrefix-challengesYes') ?? false;
      _challengesNo = _prefs!.getBool('$_keyPrefix-challengesNo') ?? false;
      _challengesMaybe = _prefs!.getBool('$_keyPrefix-challengesMaybe') ?? false;
      _challengesNotSure = _prefs!.getBool('$_keyPrefix-challengesNotSure') ?? false;

      _leisureYes = _prefs!.getBool('$_keyPrefix-leisureYes') ?? false;
      _leisureNo = _prefs!.getBool('$_keyPrefix-leisureNo') ?? false;
      _leisureMaybe = _prefs!.getBool('$_keyPrefix-leisureMaybe') ?? false;
      _leisureNotSure = _prefs!.getBool('$_keyPrefix-leisureNotSure') ?? false;

      _rating = _prefs!.getDouble('$_keyPrefix-rating') ?? 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tell me how you feel'),
      ),
      body: Stack(
        children: [
          // Background GIF
          Image.asset(
            'lib/assets/bbb.jpg', // Replace 'background.gif' with your GIF asset path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.transparent, // Make container transparent
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Select an emoji:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildEmojiCheckbox('😃', 'Happy', _happySelected),
                      buildEmojiCheckbox('😢', 'Sad', _sadSelected),
                      buildEmojiCheckbox('😐', 'Neutral', _neutralSelected),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Text('Rate your day from 1 to 10: $_rating'),
                  Slider(
                    value: _rating,
                    onChanged: (value) {
                      setState(() {
                        _rating = value;
                      });
                    },
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: '$_rating',
                  ),
                  SizedBox(height: 20.0),
                  buildQuestionWidget(1, 'How was your productivity today?', [
                    'Yes',
                    'No',
                    'Maybe',
                    'Not sure',
                  ]),
                  buildQuestionWidget(2, 'Did you overcome any challenges?', [
                    'Yes',
                    'No',
                    'Maybe',
                    'Not sure',
                  ]),
                  buildQuestionWidget(3, 'Did you enjoy your leisure time?', [
                    'Yes',
                    'No',
                    'Maybe',
                    'Not sure',
                  ]),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      await _saveUserSelections();
                      _showDonutChart();
                    },
                    child: Text("Today's Status"),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Page4()),
                      );
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmojiCheckbox(String emoji, String label, bool? selected) {
    return Row(
      children: [
        Checkbox(
          value: selected,
          onChanged: (value) {
            setState(() {
              _happySelected = false;
              _sadSelected = false;
              _neutralSelected = false;

              switch (label) {
                case 'Happy':
                  _happySelected = value;
                  break;
                case 'Sad':
                  _sadSelected = value;
                  break;
                case 'Neutral':
                  _neutralSelected = value;
                  break;
              }
            });
          },
        ),
        Text(
          emoji,
          style: TextStyle(fontSize: 30.0),
        ),
      ],
    );
  }

  Widget buildQuestionWidget(int questionNumber, String questionText, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        Text('Question $questionNumber: $questionText'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildOptionCheckbox(options[0], questionNumber),
            buildOptionCheckbox(options[1], questionNumber),
            buildOptionCheckbox(options[2], questionNumber),
            buildOptionCheckbox(options[3], questionNumber),
          ],
        ),
      ],
    );
  }

  Widget buildOptionCheckbox(String option, int questionNumber) {
    bool? _selected;
    switch (questionNumber) {
      case 1:
        _selected = option == 'Yes' ? _productivityYes : (option == 'No' ? _productivityNo : (option == 'Maybe' ? _productivityMaybe : _productivityNotSure));
        break;
      case 2:
        _selected = option == 'Yes' ? _challengesYes : (option == 'No' ? _challengesNo : (option == 'Maybe' ? _challengesMaybe : _challengesNotSure));
        break;
      case 3:
        _selected = option == 'Yes' ? _leisureYes : (option == 'No' ? _leisureNo : (option == 'Maybe' ? _leisureMaybe : _leisureNotSure));
        break;
    }

    return Row(
      children: [
        Checkbox(
          value: _selected,
          onChanged: (value) {
            setState(() {
              switch (questionNumber) {
                case 1:
                  _productivityYes = option == 'Yes' ? value : false;
                  _productivityNo = option == 'No' ? value : false;
                  _productivityMaybe = option == 'Maybe' ? value : false;
                  _productivityNotSure = option == 'Not sure' ? value : false;
                  break;
                case 2:
                  _challengesYes = option == 'Yes' ? value : false;
                  _challengesNo = option == 'No' ? value : false;
                  _challengesMaybe = option == 'Maybe' ? value : false;
                  _challengesNotSure = option == 'Not sure' ? value : false;
                  break;
                case 3:
                  _leisureYes = option == 'Yes' ? value : false;
                  _leisureNo = option == 'No' ? value : false;
                  _leisureMaybe = option == 'Maybe' ? value : false;
                  _leisureNotSure = option == 'Not sure' ? value : false;
                  break;
              }
            });
          },
        ),
        Text(option),
      ],
    );
  }

  Future<void> _saveUserSelections() async {
    await _prefs!.setBool('$_keyPrefix-happy', _happySelected!);
    await _prefs!.setBool('$_keyPrefix-sad', _sadSelected!);
    await _prefs!.setBool('$_keyPrefix-neutral', _neutralSelected!);

    await _prefs!.setBool('$_keyPrefix-productivityYes', _productivityYes!);
    await _prefs!.setBool('$_keyPrefix-productivityNo', _productivityNo!);
    await _prefs!.setBool('$_keyPrefix-productivityMaybe', _productivityMaybe!);
    await _prefs!.setBool('$_keyPrefix-productivityNotSure', _productivityNotSure!);

    await _prefs!.setBool('$_keyPrefix-challengesYes', _challengesYes!);
    await _prefs!.setBool('$_keyPrefix-challengesNo', _challengesNo!);
    await _prefs!.setBool('$_keyPrefix-challengesMaybe', _challengesMaybe!);
    await _prefs!.setBool('$_keyPrefix-challengesNotSure', _challengesNotSure!);

    await _prefs!.setBool('$_keyPrefix-leisureYes', _leisureYes!);
    await _prefs!.setBool('$_keyPrefix-leisureNo', _leisureNo!);
    await _prefs!.setBool('$_keyPrefix-leisureMaybe', _leisureMaybe!);
    await _prefs!.setBool('$_keyPrefix-leisureNotSure', _leisureNotSure!);

    await _prefs!.setDouble('$_keyPrefix-rating', _rating);
  }

  void _showDonutChart() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Today's Status"),
          content: Container(
            height: 300,
            width: 300,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: _getEmojiColor(),
                    value: 1,
                    title: '😍😢',
                  ),
                  PieChartSectionData(
                    color: _getRatingColor(),
                    value: 1,
                    title: '🌟',
                  ),
                  PieChartSectionData(
                    color: _getOptionColor(_productivityYes,'Yes'),
                    value: 1,
                    title: '🥳💃🏻',
                  ),
                  PieChartSectionData(
                    color: _getOptionColor(_challengesYes,'Yes'),
                    value: 1,
                    title: '🌱',
                  ),
                  PieChartSectionData(
                    color: _getOptionColor(_leisureYes,'Yes'),
                    value: 1,
                    title: '⏳',
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Color _getEmojiColor() {
    if (_happySelected!) {
      return Colors.green;
    } else if (_sadSelected!) {
      return Colors.red;
    } else if (_neutralSelected!) {
      return Colors.yellow;
    } else {
      return Colors.grey;
    }
  }

  Color _getRatingColor() {
    if (_rating < 5) {
      return Colors.red;
    } else if (_rating == 5) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }
  Color _getOptionColor(bool? selected, String option) {
    if (selected == true) {
      return Colors.green;
    } else if (selected == false) {
      return Colors.red;
    } else {
      if (option == 'Maybe') {
        return Colors.yellow;
      } else if (option == 'Not sure') {
        return Colors.blue;
      } else {
        return Colors.grey;
      }
    }
  }
}

//
class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Let\'s make your day better together!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.purple[100], // Background color
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSquareButton(context, Icons.account_circle, 'PROFILE', 'lib/assets/profile.gif', PageProfile()),
                  SizedBox(width: 16.0), // Add space between buttons
                  buildSquareButton(context, Icons.support, 'SUPPORT', 'lib/assets/support.gif', PageSupport()),
                ],
              ),
            ),
            SizedBox(height: 16.0), // Add space between rows
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSquareButton(context, Icons.task, 'TASK', 'lib/assets/task.gif', PageTask()),
                  SizedBox(width: 16.0), // Add space between buttons
                  buildSquareButton(context, Icons.star, 'FUN', 'lib/assets/fun.gif', PageFun()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSquareButton(BuildContext context, IconData iconData, String label, String gifPath, Widget destinationScreen) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => destinationScreen),
                );
              },
              icon: Icon(iconData),
              label: Text(
                label,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Big and bold font
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18.0),
                child: Image.asset(
                  gifPath,
                  fit: BoxFit.cover, // Ensure the image covers the entire space
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class PageProfile extends StatefulWidget {
  @override
  _PageProfileState createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  String? _selectedProfilePicture;

  List<String> profilePictures = [
    'lib/assets/male.jpg',
    'lib/assets/female.png',
    'lib/assets/pro.png',
    // Add more image choices as needed
  ];

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Load saved data when the widget is initialized
    loadSavedData();
  }

  Future<void> loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _nameController.text = prefs.getString('name') ?? '';
        _mobileNumberController.text = prefs.getString('mobileNumber') ?? '';
        _nationalityController.text = prefs.getString('nationality') ?? '';
        _selectedGender = prefs.getString('gender');
        final dateString = prefs.getString('dateOfBirth');
        _selectedDate = dateString != null
            ? DateTime.parse(dateString)
            : null;
        _selectedProfilePicture = prefs.getString('profilePicture');
      });
    } catch (error) {
      print('Error loading saved data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/profilebgg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProfilePicture(),
              buildProfileField('Name', _nameController),
              buildGenderDropdown(),
              buildProfileField('Mobile Number', _mobileNumberController),
              buildProfileField('Nationality', _nationalityController),
              buildDateOfBirthField(),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_isEditing) {
                        saveProfileInformation();
                      }
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    child: Text(_isEditing ? 'Save' : 'Edit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), // Increased font size
          ),
          SizedBox(height: 8.0),
          _isEditing
              ? TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Type your $label here...',
                  ),
                )
              : Text(
                  controller.text.isEmpty ? 'Not set' : controller.text,
                  style: TextStyle(color: Colors.black87, fontSize: 18), // Increased font size
                ),
        ],
      ),
    );
  }

  Widget buildGenderDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), // Increased font size
          ),
          SizedBox(height: 8.0),
          _isEditing
              ? DropdownButton<String>(
                  value: _selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  items: <String>['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                )
              : Text(
                  _selectedGender ?? 'Not set',
                  style: TextStyle(color: Colors.black87, fontSize: 18), // Increased font size
                ),
        ],
      ),
    );
  }

  Widget buildDateOfBirthField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date of Birth',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), // Increased font size
          ),
          SizedBox(height: 8.0),
          _isEditing
              ? ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                )
              : Text(
                  _selectedDate != null
                      ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                      : 'Not set',
                  style: TextStyle(color: Colors.black87, fontSize: 18), // Increased font size
                ),
        ],
      ),
    );
  }

  Widget buildProfilePicture() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Picture',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), // Increased font size
          ),
          SizedBox(height: 8.0),
          _isEditing
              ? DropdownButton<String>(
                  value: _selectedProfilePicture,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedProfilePicture = newValue;
                    });
                  },
                  items: profilePictures
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                )
              : CircleAvatar(
                  radius: 40.0,
                  backgroundImage: _selectedProfilePicture != null
                      ? AssetImage(_selectedProfilePicture!)
                      : AssetImage('lib/assets/pro.png'),
                ),
        ],
      ),
    );
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

  void saveProfileInformation() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userUid = user.uid;

        // Create a reference to the user's profile data in Firestore
        final userReference = FirebaseFirestore.instance.collection('users').doc(userUid);

        // Update the user's profile data in Firestore
        await userReference.set({
          'name': _nameController.text,
          'mobileNumber': _mobileNumberController.text,
          'nationality': _nationalityController.text,
          'gender': _selectedGender,
          'dateOfBirth': _selectedDate != null
              ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
              : null,
          'profilePicture': _selectedProfilePicture,
        });

        // Save the user's profile data in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('name', _nameController.text);
        prefs.setString('mobileNumber', _mobileNumberController.text);
        prefs.setString('nationality', _nationalityController.text);
        prefs.setString('gender', _selectedGender ?? '');
        prefs.setString('dateOfBirth', _selectedDate != null ? _selectedDate.toString() : '');
        prefs.setString('profilePicture', _selectedProfilePicture ?? '');

        Fluttertoast.showToast(msg: 'Profile information saved successfully!');
      } else {
        Fluttertoast.showToast(msg: 'User not logged in.');
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Error saving profile information.');
      print(error);
    }
  }
}

class PageSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support Page'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'lib/assets/onlinesupport.jpg', // Replace 'background_image.jpg' with your image asset
            fit: BoxFit.cover,
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildDashboardButton(context, 'Chatbot', ChatbotPage()),
                SizedBox(height: 16.0),
                buildDashboardButton(context, 'Seek Medical Help', DoctorListPage()),
                SizedBox(height: 16.0),
                buildDashboardButton(context, 'Week Status', BarGraph()), // Button for Bar Graph
              ],
            ),
          ),
        ],
      ),
    );
  }


 Widget buildDashboardButton(BuildContext context, String title, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Text(title),
    );
  }
}

class BarGraph extends StatelessWidget {
  // Function to generate random ratings for each day
  List<int?> _generateRandomRatings() {
    Random random = Random();
    List<int?> ratings = [];
    for (int i = 0; i < 7; i++) {
      if (i == 4) {
        ratings.add(6); // Day 5 rating is set to 6
      } else if (i < 4) {
        ratings.add(random.nextInt(10) + 1);
      }else {
        ratings.add(null); // Day 6 and Day 7 placeholders
      }
    }
    return ratings;
  }


  // Function to determine the color of the bar based on the rating
  Color _getBarColor(int rating) {
    if(rating != null){
    if (rating < 5) {
      return Colors.red;
    } else if (rating > 5) {
      return Colors.green;
    } else {
      return Colors.yellow;
    }
  }
  return Colors.transparent;
  }


  @override
  Widget build(BuildContext context) {
    List<int?> ratings = _generateRandomRatings();
    int redCount = ratings.where((rating) => rating != null && rating < 5).length;

    String message = redCount > 2 ? 'Seek medical help' : 'Good, you are progressing';
    bool showGoButton = redCount > 2;

    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Progress'),
        actions: [
          if (showGoButton)
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorListPage()),
                );
              },
            ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Weekly Progress',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: redCount > 3 ? Colors.red : Colors.green),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: BarChart(ratings: ratings),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.red,
                width: 20,
                height: 20,
              ),
              SizedBox(width: 5),
              Text('Sad'),
              SizedBox(width: 20),
              Container(
                color: Colors.yellow,
                width: 20,
                height: 20,
              ),
              SizedBox(width: 5),
              Text('Neutral'),
              SizedBox(width: 20),
              Container(
                color: Colors.green,
                width: 20,
                height: 20,
              ),
              SizedBox(width: 5),
              Text('Happy'),
            ],
          ),
        ],
      ),
    );
  }
}

class BarChart extends StatelessWidget {
  final List<int?> ratings;

  BarChart({required this.ratings});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ratings.asMap().entries.map((entry) {
        int day = entry.key + 1;
        int? rating = entry.value;
        Color color = rating != null ? _getBarColor(rating) : Colors.transparent;
        double barHeight = rating != null ? rating * 20.0 : 0.0;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 20,
              height: barHeight,
              color: color,
            ),
            SizedBox(height: 5),
            Text(
              'Day $day',
              style: TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  Color _getBarColor(int rating) {
    if (rating < 5) {
      return Colors.red;
    } else if (rating > 5) {
      return Colors.green;
    } else {
      return Colors.yellow;
    }
  }
}

class DoctorListPage extends StatelessWidget {
  final List<Doctor> doctors = [
    Doctor(
      name: 'Dr. John Doe',
      specialty: 'Cardiologist',
      contactNumber: '+123 456 7890',
      about: 'Experienced Cardiologist with a focus on heart health.',
      profilePicture: 'lib/assets/doctor1.jpg',
    ),
    Doctor(
      name: 'Dr. Jane Smith',
      specialty: 'Pediatrician',
      contactNumber: '+987 654 3210',
      about: 'Dedicated Pediatrician providing care for children of all ages.',
      profilePicture: 'lib/assets/doctor2.jpg',
    ),
    // Add more doctors as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor List'),
      ),
      body: Container(
        color: Colors.red[100], // Background color
        child: ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            return DoctorCard(doctor: doctors[index]);
          },
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(doctor.profilePicture),
        ),
        title: Text(doctor.name),
        subtitle: Text(doctor.specialty),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoctorDetailsPage(doctor: doctor)),
          );
        },
      ),
    );
  }
}

class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor;

  DoctorDetailsPage({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
      ),
      body: Container(
        color: Colors.orange[100], // Background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 60.0,
                backgroundImage: AssetImage(doctor.profilePicture),
              ),
              SizedBox(height: 16.0),
              Text('Name: ${doctor.name}'),
              Text('Specialty: ${doctor.specialty}'),
              Text('Contact Number: ${doctor.contactNumber}'),
              SizedBox(height: 16.0),
              Text('About: ${doctor.about}'),
            ],
          ),
        ),
      ),
    );
  }
}

class Doctor {
  final String name;
  final String specialty;
  final String contactNumber;
  final String about;
  final String profilePicture;

  Doctor({
    required this.name,
    required this.specialty,
    required this.contactNumber,
    required this.about,
    required this.profilePicture,
  });
}



void _launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}

void _canLaunchUrl(String url) async {
  await canLaunch(url);
}

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  TextEditingController _messageController = TextEditingController();
  List<String> _chatMessages = [
    'Hello! How can I help you?',
    'Feel free to ask me anything.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chatbot Dashboard',
          style: TextStyle(fontSize: 24), // Increase font size
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/chatt.png'), // Change 'assets/background_photo.jpg' to your background photo path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _chatMessages[index],
                      style: TextStyle(fontSize: 20), // Increase font size
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(fontSize: 20), // Increase font size
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      sendMessage();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    String message = _messageController.text;
    if (message.isNotEmpty) {
      setState(() {
        _chatMessages.add('User: $message');
        _messageController.clear();
        // Simulate chatbot responses based on user queries
        String botResponse = getChatbotResponse(message);
        _chatMessages.add('Chatbot: $botResponse');
      });
    }
  }

 String getChatbotResponse(String userMessage) {
    // Simple logic to generate chatbot responses based on user queries
    if (userMessage.toLowerCase().contains("how are you")) {
        return "I am doing well, thank you!";
    } else if (userMessage.toLowerCase().contains("your name")) {
        return "I am your Companion, your virtual assistant.";
    } else if (userMessage.toLowerCase().contains("help")) {
        return "Sure, I can help you with a variety of topics. Just ask!";
    } else if (userMessage.toLowerCase().contains("mental health")) {
        return "It's important to take care of your mental health. Is there anything specific you'd like to talk about?";
    } else if (userMessage.toLowerCase().contains("anxiety")) {
        return "Anxiety is a common feeling. It's okay to feel anxious sometimes. Would you like some tips on managing anxiety?";
    } else if (userMessage.toLowerCase().contains("depression")) {
        return "Depression is a serious condition. It's important to seek support. Would you like some resources for managing depression?";
    } else if (userMessage.toLowerCase().contains("stress")) {
        return "Stress is a natural response to challenges. Taking breaks and practicing relaxation techniques can help. Would you like some stress-relief exercises?";
    } else if (userMessage.toLowerCase().contains("lonely")) {
        return "Feeling lonely is tough, but you're not alone. Reach out to friends or loved ones, or consider joining social groups or clubs. Would you like suggestions on connecting with others?";
    } else if (userMessage.toLowerCase().contains("self-care")) {
        return "Self-care is important for your well-being. Taking time for yourself and engaging in activities you enjoy can help recharge your batteries. What's your favorite way to practice self-care?";
    } else if (userMessage.toLowerCase().contains("therapy")) {
        return "Therapy can be a helpful way to work through challenges and improve mental health. Have you considered talking to a therapist?";
    } else if (userMessage.toLowerCase().contains("meditation")) {
        return "Meditation is a great way to relax the mind and reduce stress. Would you like to try a guided meditation?";
    } else if (userMessage.toLowerCase().contains("exercise")) {
        return "Exercise is not only good for your physical health but also for your mental well-being. What type of exercise do you enjoy?";
    } else if (userMessage.toLowerCase().contains("sleep")) {
        return "Getting enough sleep is crucial for good mental health. Would you like some tips for improving your sleep quality?";
    } else if (userMessage.toLowerCase().contains("positivity")) {
        return "Practicing gratitude and focusing on the positives in life can improve your mood. What are you grateful for today?";
    } else if (userMessage.toLowerCase().contains("mindfulness")) {
        return "Mindfulness can help you stay present and reduce stress. Would you like to try a mindfulness exercise?";
    } else if (userMessage.toLowerCase().contains("coping strategies")) {
        return "Developing healthy coping strategies can help you manage difficult emotions. What are some activities that help you feel better?";
    } else if (userMessage.toLowerCase().contains("mental health resources")) {
        return "There are many resources available for mental health support. Would you like me to provide some links?";
    } else {
        return "Thank you for your message!";
    }
}

}



class PageTask extends StatefulWidget {
  @override
  _PageTaskState createState() => _PageTaskState();
}

class _PageTaskState extends State<PageTask> {
  String? _task;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    // Load saved tasks when the widget is initialized
    loadSavedTasks();
  }

  Future<void> loadSavedTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasks = prefs.getStringList('tasks');
      if (tasks != null) {
        setState(() {
          _tasks = tasks.map((task) => Task(task)).toList();
        });
      }
    } catch (error) {
      print('Error loading saved tasks: $error');
    }
  }

  Future<void> saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final taskStrings = _tasks.map((task) => task.task ?? '').toList();
      prefs.setStringList('tasks', taskStrings);
    } catch (error) {
      print('Error saving tasks: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showAddTaskDialog();
                      },
                      child: Text(
                        "SET YOUR TODAY'S TASK",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      "Your Task:",
                      style: TextStyle(fontSize: 18),
                    ),
                    for (var task in _tasks) ...[
                      _buildTaskCard(task),
                      SizedBox(height: 8.0),
                    ],
                    ElevatedButton(
                      onPressed: () {
                        _showNewTaskDialog();
                      },
                      child: Text("ADD NEW TASK", style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MotivationPage()),
                        );
                      },
                      child: Text('WANT MOTIVATION', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'lib/assets/task1.gif', // Replace 'your_image.jpg' with your image asset path
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.task!,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog(task, true);
                  },
                  child: Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog(task, false);
                  },
                  child: Text('No'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddTaskDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Set Your Today's Task", style: TextStyle(fontSize: 20)),
          content: TextField(
            onChanged: (value) {
              _task = value;
            },
            decoration: InputDecoration(
              hintText: 'Type your task here...',
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(fontSize: 18)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _tasks.add(Task(_task!));
                  saveTasks();
                });
              },
              child: Text('Save', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showNewTaskDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Task", style: TextStyle(fontSize: 20)),
          content: TextField(
            onChanged: (value) {
              _task = value;
            },
            decoration: InputDecoration(
              hintText: 'Type your new task here...',
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(fontSize: 18)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _tasks.add(Task(_task!));
                  saveTasks();
                });
              },
              child: Text('Save', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showConfirmationDialog(Task task, bool isAccomplished) async {
    String confirmationMessage = isAccomplished
        ? 'Good Job! Task completed!'
        : 'Better luck next time. Keep going!';
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(confirmationMessage, style: TextStyle(fontSize: 20)),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _tasks.remove(task);
                  saveTasks();
                });
              },
              child: Text('OK', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }
}

class Task {
  String? task;

  Task(this.task);
}

class MotivationPage extends StatefulWidget {
  @override
  _MotivationPageState createState() => _MotivationPageState();
}

class _MotivationPageState extends State<MotivationPage> {
  String _motivationalQuote = '';

  @override
  void initState() {
    super.initState();
    fetchMotivationalQuote();
  }

  Future<void> fetchMotivationalQuote() async {
    final response = await http.get(Uri.parse('https://api.quotable.io/random'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _motivationalQuote = data['content'];
      });
    } else {
      // Handle the error
      print('Failed to load motivational quote');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Motivation Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.purple[100], // Background color
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Momentum booster',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Here\'s a motivational quote for you:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _motivationalQuote.isNotEmpty ? _motivationalQuote : 'Loading...',
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    // "Get Another Quote" button
                    ElevatedButton(
                      onPressed: () {
                        fetchMotivationalQuote();
                      },
                      child: Text(
                        'Get Another Quote',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom half containing the GIF
          Expanded(
            child: Container(
              // Add your GIF widget here
              // For example:
              // Image.asset('assets/motivation.gif'),
              child: Image.asset('lib/assets/moti.gif'),
            ),
          ),
        ],
      ),
    );
  }
}

//

class PageFun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fun Page'),
      ),
      body: Container(
        color: Colors.orange[100], // Background color
        padding: EdgeInsets.all(10), // Padding for spacing between games
        child: GridView.count(
          crossAxisCount: 2, // 2 columns for 2 games per row
          children: [
            _buildGameButton(context, 'Tic Tac Toe', 'lib/assets/tictactoe.png'),
            _buildGameButton(context, 'Motivation', 'lib/assets/mo.jpg'),
            _buildGameButton(context, 'Music', 'lib/assets/music.png'),
            _buildGameButton(context, 'Relax', 'lib/assets/be.jpg'),
            _buildGameButton(context, 'Trivia Quiz', 'lib/assets/triq.png'),
            _buildGameButton(context, 'Workout', 'lib/assets/workout.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildGameButton(BuildContext context, String gameTitle, String imagePath) {
    return Container(
      margin: EdgeInsets.all(8), // Spacing between games
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black), // Border for each game
      ),
      child: ElevatedButton(
        onPressed: () {
          // Navigate to corresponding game page
          _navigateToGamePage(context, gameTitle);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 100, // Adjust image height as needed
              width: 100, // Adjust image width as needed
            ),
            SizedBox(height: 10), // Spacing between image and game title
            Text(gameTitle),
          ],
        ),
      ),
    );
  }

  void _navigateToGamePage(BuildContext context, String gameTitle) {
    switch (gameTitle) {
      case 'Tic Tac Toe':
        Navigator.push(context, MaterialPageRoute(builder: (context) => TicTacToeGame()));
        break;
      case 'Motivation':
        Navigator.push(context, MaterialPageRoute(builder: (context) => MotivationVideos()));
        break;
      case 'Music':
        Navigator.push(context, MaterialPageRoute(builder: (context) => Music()));
        break;
      case 'Relax':
        Navigator.push(context, MaterialPageRoute(builder: (context) => BreathingExercisePage()));
        break;
      case 'Trivia Quiz':
        Navigator.push(context, MaterialPageRoute(builder: (context) => QuizApp()));
        break;
      case 'Workout':
        Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutVideos()));
        break;
    }
  }
}
//

class TicTacToeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tic Tac Toe'),
        ),
        body: Container(
          color: Colors.blueGrey[900], // Set background color
          child: TicTacToeBoard(),
        ),
      ),
    );
  }
}

class TicTacToeBoard extends StatefulWidget {
  @override
  _TicTacToeBoardState createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  List<String> board = List.filled(9, '');
  bool isPlayerX = true;
  bool gameOver = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            return buildGridTile(index);
          },
        ),
        SizedBox(height: 20),
        Text(
          gameOver ? 'Game Over!' : 'Current Player: ${isPlayerX ? 'X' : 'O'}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // Set font style
        ),
      ],
    );
  }

  Widget buildGridTile(int index) {
    return GestureDetector(
      onTap: () {
        if (!gameOver && board[index].isEmpty) {
          setState(() {
            board[index] = isPlayerX ? 'X' : 'O';
            checkForWinner();
            isPlayerX = !isPlayerX;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2.0), // Set border and width
        ),
        child: Center(
          child: Text(
            board[index],
            style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.white), // Set font style
          ),
        ),
      ),
    );
  }

  void checkForWinner() {
    for (var i = 0; i < 3; i++) {
      // Check rows
      if (board[i * 3] == board[i * 3 + 1] &&
          board[i * 3 + 1] == board[i * 3 + 2] &&
          board[i * 3].isNotEmpty) {
        showWinnerDialog(board[i * 3]);
        return;
      }

      // Check columns
      if (board[i] == board[i + 3] &&
          board[i + 3] == board[i + 6] &&
          board[i].isNotEmpty) {
        showWinnerDialog(board[i]);
        return;
      }
    }

    // Check diagonals
    if (board[0] == board[4] && board[4] == board[8] && board[0].isNotEmpty) {
      showWinnerDialog(board[0]);
      return;
    }
    if (board[2] == board[4] && board[4] == board[6] && board[2].isNotEmpty) {
      showWinnerDialog(board[2]);
      return;
    }

    // Check for a tie
    if (!board.contains('')) {
      showTieDialog();
      return;
    }
  }

  void showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('$winner is the winner!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
    gameOver = true;
  }

  void showTieDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('It\'s a Tie!'),
          content: Text('No one wins.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
    gameOver = true;
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      isPlayerX = true;
      gameOver = false;
    });
  }
}

class Music extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildMusicSection(
                      imageUrl: 'lib/assets/spotify_background.jpg',
                      onTap: () {
                        _launchURL('https://open.spotify.com/');
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8), // Add space between sections
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildMusicSection(
                      imageUrl: 'lib/assets/youtube_music_background.jpg',
                      onTap: () {
                        _launchURL('https://music.youtube.com/');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8), // Add space between rows
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildMusicSection(
                      imageUrl: 'lib/assets/soundcloud_background.jpg',
                      onTap: () {
                        _launchURL('https://soundcloud.com/');
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8), // Add space between sections
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildMusicSection(
                      imageUrl: 'lib/assets/amazon-music-background.jpg',
                      onTap: () {
                        _launchURL('https://music.amazon.in/');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicSection({required String imageUrl, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1), // Border around each section
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class SudokuGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SudokuScreen(),
    );
  }
}

class SudokuScreen extends StatefulWidget {
  @override
  _SudokuScreenState createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  List<List<int>> _board = [[]];

  @override
  void initState() {
    super.initState();
    // Initialize the board
    _initializeBoard();
  }

  void _initializeBoard() {
    // You can customize this with any Sudoku puzzle you like
    _board = [
      [5, 3, 0, 0, 7, 0, 0, 0, 0],
      [6, 0, 0, 1, 9, 5, 0, 0, 0],
      [0, 9, 8, 0, 0, 0, 0, 6, 0],
      [8, 0, 0, 0, 6, 0, 0, 0, 3],
      [4, 0, 0, 8, 0, 3, 0, 0, 1],
      [7, 0, 0, 0, 2, 0, 0, 0, 6],
      [0, 6, 0, 0, 0, 0, 2, 8, 0],
      [0, 0, 0, 4, 1, 9, 0, 0, 5],
      [0, 0, 0, 0, 8, 0, 0, 7, 9],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sudoku'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: _buildBoard(),
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple, // Background color
        border: Border.all(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _board
            .map((row) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((cell) => _buildCell(cell)).toList(),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCell(int value) {
    return GestureDetector(
      onTap: () {
        if (value == 0) {
          // Empty cell, allow user to input number
          _showNumberPicker();
        } else {
          // Non-empty cell, do nothing
        }
      },
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Background color for cells
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          child: Center(
            child: Text(
              value != 0 ? value.toString() : '',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showNumberPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a number'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                for (int i = 1; i <= 9; i++)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(i);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        i.toString(),
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        // Update the board with the selected number
        setState(() {
          // Modify the _board list according to the selected number
          // This part needs to be implemented based on the Sudoku rules
          // For simplicity, let's just print the selected number for now
          print('Selected number: $value');
        });
      }
    });
  }
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quiz Game'),
        ),
        body: QuizPage(),
        backgroundColor: Colors.blueGrey[900], // Background color
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the capital of France?',
      'options': ['Paris', 'Rome', 'London', 'Berlin'],
      'answer': 'Paris'
    },
    {
      'question': 'Who wrote "Romeo and Juliet"?',
      'options': ['William Shakespeare', 'Jane Austen', 'Charles Dickens', 'Leo Tolstoy'],
      'answer': 'William Shakespeare'
    },
    {
      'question': 'What is the chemical symbol for water?',
      'options': ['H2O', 'CO2', 'O2', 'CH4'],
      'answer': 'H2O'
    },
    {
      'question': 'What is the largest mammal?',
      'options': ['Elephant', 'Blue Whale', 'Giraffe', 'Hippopotamus'],
      'answer': 'Blue Whale'
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Mars', 'Jupiter', 'Venus', 'Saturn'],
      'answer': 'Mars'
    },
    {
      'question': 'What is the tallest mountain on Earth?',
      'options': ['Mount Everest', 'K2', 'Kangchenjunga', 'Lhotse'],
      'answer': 'Mount Everest'
    },
    {
      'question': 'Who painted the Mona Lisa?',
      'options': ['Leonardo da Vinci', 'Vincent van Gogh', 'Pablo Picasso', 'Michelangelo'],
      'answer': 'Leonardo da Vinci'
    },
    {
      'question': 'What is the currency of Japan?',
      'options': ['Yen', 'Dollar', 'Euro', 'Pound'],
      'answer': 'Yen'
    },
    {
      'question': 'Which country is famous for its tulips?',
      'options': ['Netherlands', 'France', 'Italy', 'Turkey'],
      'answer': 'Netherlands'
    },
    {
      'question': 'What is the largest organ in the human body?',
      'options': ['Skin', 'Heart', 'Liver', 'Lung'],
      'answer': 'Skin'
    }
  ];

  int currentQuestionIndex = 0;
  String selectedOption = '';
  int score = 0;

  void checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      if (option == questions[currentQuestionIndex]['answer']) {
        score++;
      }
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          selectedOption = '';
          currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
          if (currentQuestionIndex == 0) {
            _showResultDialog();
          }
        });
      });
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Result'),
          content: Text('Your score: $score/${questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  currentQuestionIndex = 0;
                  score = 0;
                });
                Navigator.pop(context);
              },
              child: Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            questions[currentQuestionIndex]['question'],
            style: TextStyle(
              fontSize: 24.0, // Big font size
              color: Colors.white, // Text color
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0),
          Column(
            children: List.generate(
              questions[currentQuestionIndex]['options'].length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: selectedOption.isNotEmpty ? null : () => checkAnswer(questions[currentQuestionIndex]['options'][index]),
                  child: Text(
                    questions[currentQuestionIndex]['options'][index],
                    style: TextStyle(fontSize: 20.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: selectedOption == questions[currentQuestionIndex]['options'][index]
                        ? Colors.green // Change color to green if correct
                        : selectedOption == ''
                            ? Colors.white // Default color
                            : Colors.red, // Change color to red if incorrect
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class MotivationVideos extends StatelessWidget {
  final List<String> videoLinks = [
    "https://www.youtube.com/watch?v=Y5ZuYYmmS_o",
    "https://www.youtube.com/watch?v=edIctUyd4RQ",
    "https://www.youtube.com/watch?v=9C3cqFjQtrU",
    "https://www.youtube.com/watch?v=lX0mS9x8HdQ",
    "https://www.youtube.com/watch?v=1CSZ8EJgIe8"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Motivation Videos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/assets/vid.gif"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: videoLinks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _launchURL(videoLinks[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Text('Motivation Video ${index + 1}'),
                        leading: Icon(Icons.play_circle_filled),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class WorkoutVideos extends StatelessWidget {
  final List<String> videoLinks = [
    "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    "https://www.youtube.com/watch?v=DLzxrzFCyOs",
    "https://www.youtube.com/watch?v=0JRm7qlgaHY",
    "https://www.youtube.com/watch?v=SRcnnId15BA"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Videos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/assets/wo.gif"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
        itemCount: videoLinks.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _launchURL(videoLinks[index]);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: Text('Workout Video ${index + 1}'),
                  leading: Icon(Icons.play_circle_filled),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
            ),
          );
        },
      ),
      ),
     ],
    ),
   );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class BreathingExercisePage extends StatefulWidget {
  @override
  _BreathingExercisePageState createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer() {
    _videoPlayerController = VideoPlayerController.asset('lib/assets/breathing.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      allowPlaybackSpeedChanging: false,
      allowFullScreen: false,
      showControls: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breathing Exercise'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildVideoPlayer(),
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildBackgroundGif(),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Chewie(
      controller: _chewieController,
    );
  }

  Widget _buildBackgroundGif() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/be.gif'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}



class ConnectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Page'),
      ),
      body: Center(
        child: Text('CONNECT content'),
      ),
    );
  }
}