import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_buddy/modules/find_sign.dart';
import 'package:sign_buddy/modules/finger_spelling.dart';
import 'package:sign_buddy/modules/sharedwidget/page_transition.dart';
import 'package:sign_buddy/modules/sign_alphabet.dart';
import 'package:sign_buddy/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  bool isEnglish = true;

  final List<Widget> _screens = [
    const LessonsScreen(),
    AlphabetScreen(),
    FindSign(),
    FingerSpelling()
  ];

  @override
  void initState() {
    super.initState();
    getLanguage();

  }

  Future<void> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? true;

    setState(() {
      this.isEnglish = isEnglish;
    });
  }

 



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to indicate that you don't want to pop the route
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color(0xFF5A96E3),
          title: Text(
            isEnglish ? 'Hello!' :"Kamusta!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'FiraSans',
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.feedback),
              onPressed: () {
                // Implement search functionality here
              },
            ),
          ],
        ),
    
        drawer: Drawer(
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFF5A96E3),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(
                              5.0), // do adjust the margin of avatar and Text "Juan Dela Cruz"
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                child: const CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(
                                      'assets/user_man.png'), // Replace with your avatar image path
                                ),
                              ),
                              const SizedBox(height: 10),
                              buildUserData() // class for fetching user
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            _scaffoldKey.currentState?.openEndDrawer();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  // Handle profile tap
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                onTap: () {
                  // Handle about tap
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () async {
                  bool confirmLogout = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content:  Text(isEnglish ? 'Are you sure you want to logout?': 'Sigurado ka bang nais mong mag-logout?',
                          style: TextStyle(
                            fontFamily: 'FiraSans',
                            fontWeight: FontWeight.w300,
                          )),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child:  Text(isEnglish ? 'CANCEL': 'KANSEL',
                              style: TextStyle(
                                color: Colors.black,
                              )),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('LOGOUT',
                              style: TextStyle(
                                color: Colors.red,
                              )),
                        ),
                      ],
                    ),
                  );
    
                  if (confirmLogout == true) {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  }
                },
              ),
            ],
          ),
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF5BD8FF),
        unselectedItemColor: Colors.grey[800],
        selectedItemColor: Colors.black,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            // Check if the selected item is not the current screen
            if (index == 1) {
              // Navigate to AlphabetScreen
              Navigator.pushNamed(context, '/alphabet');
            } else if (index == 2) {
              // Navigate to FindSign
              Navigator.pushNamed(context, '/findSign');
            }
            else if (index == 3) {
              // Navigate to FindSign
              Navigator.pushNamed(context, '/fingerSpell');
            } else {
              // Change the current screen if it's not Alphabet or Find Sign
              setState(() {
                _currentIndex = index;
              });
            }
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Lessons',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'Alphabet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Find Sign',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spellcheck),
            label: 'Finger Spell',
          ),
          
        ],
      ),
        // floatingActionButton: _currentIndex == 0
        //     ? FloatingActionButton.extended(
        //         onPressed: () {
    
        //         },
        //         icon: const Icon(Icons.play_arrow),
        //         label: const Text('Start'),
        //         backgroundColor: Colors.deepPurpleAccent[700],
        //       )
        //     : null,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

Widget buildUserData() {
  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance
        .collection('userData')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      }

      if (snapshot.hasError) {
        return const Text('Error fetching data');
      }

      var userData = snapshot.data!.data() as Map<String, dynamic>;
      var firstName = userData['firstName'];
      var lastName = userData['lastName'];

      // Check if firstName or lastName is empty
      if (firstName == null ||
          firstName.isEmpty ||
          lastName == null ||
          lastName.isEmpty) {
        return Column(
          children: [
             Text(
              'Save progress, make a profile!',
              style: TextStyle(
                  color: Colors.white, fontSize: 11, fontFamily: 'FiraSans'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
              // Wrap the buttons in a Row
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                    width: 20), // Add some spacing between the buttons
                ElevatedButton(
                  onPressed: () {
                    // Navigate to sign up page
                    Navigator.push(
                        context, SlidePageRoute(page: const SignupPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ],
        );
      }

      // Capitalize the first letter
      String capitalizeFirstLetter(String name) {
        return name[0].toUpperCase() + name.substring(1);
      }

      return Text(
        '${capitalizeFirstLetter(firstName)} ${capitalizeFirstLetter(lastName)}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'FiraSans',
        ),
      );
    },
  );
}

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({Key? key}) : super(key: key);

  @override
  _LessonsScreenState createState() => _LessonsScreenState();
}



class _LessonsScreenState extends State<LessonsScreen> {
  int? selectedLessonIndex;

  final List<Map<String, dynamic>> lessons = [
    {
      'en': 'Alphabet',
      'ph': 'Alpabeto',
      'icon': 'lesson-icon/img1.png',
    },
    {
      'en': 'Numbers',
      'ph': 'Mga Numero',
      'icon': 'lesson-icon/img2.png',
    },
    {
      'en': 'Family',
      'ph': 'Pamilya',
      'icon': 'lesson-icon/img3.png',
    },
    {
      'en': 'Greetings',
      'ph': 'Pagbati',
      'icon': 'lesson-icon/img10.png',
    },
    {
      'en': 'Animals',
      'ph': 'Mga Hayop',
      'icon': 'lesson-icon/img6.png',
    },
    {
      'en': 'Time and Days',
      'ph': 'Oras at Araw',
      'icon': 'lesson-icon/img9.png',
    },
  ];

  bool isEnglish = true;

  @override
  void initState() {
    super.initState();
    getLanguage();

  }

  Future<void> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? true;

    setState(() {
      this.isEnglish = isEnglish;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/bg-signbuddy.png'), // Replace with your background image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(41, 20, 20, 20),
              child: Text(
                isEnglish ? 'Lessons' : 'Mga Lesson',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  final lessonName = isEnglish ? lesson['en'] : lesson['ph'];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        _navigateToStartLesson(context, lessonName);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/${lesson['icon']}',
                            width: 48,
                            height: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lessonName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _navigateToStartLesson(BuildContext context, String lesson) {
  final lessonMap = {
    'Alphabet': '/basic',
    'Alpabeto': '/basic',
    'Numbers': '/numbers',
    'Mga Numero': '/numbers',
    'Family': '/shapes',
    'Pamilya': '/shapes',
    'Animals': '/animals',
    'Mga Hayop': '/animals',
    'Time and Days': '/timeAndDays',
    'Oras at Araw': '/timeAndDays',
    'Greetings': '/greeting',
    'Pagbati': '/greeting',
  };

  final route = lessonMap[lesson];

  if (route != null) {
    Navigator.pushNamed(context, route);
  } else {
    // Handle the case when the lesson is not found
  }
}





