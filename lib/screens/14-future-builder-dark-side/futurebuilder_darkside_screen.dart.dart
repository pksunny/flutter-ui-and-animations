import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';


class FutureBuilderDarkSideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FutureBuilder Demo'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose Implementation:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BadImplementation()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                '❌ BAD: Memory Leak Version',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GoodImplementation()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                '✅ GOOD: Optimized Version',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 40),
           
          ],
        ),
      ),
    );
  }
}

// Mock User Model
class User {
  final int id;
  final String name;
  final String email;
  final String avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }
}

// Mock API Service
class ApiService {
  static int _requestCount = 0;
  
  static Future<User> fetchUserData() async {
    _requestCount++;
    print('🌐 API Call #$_requestCount - Fetching user data...');
    
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
    
    // Simulate random user data
    final random = Random();
    final names = ['Alice Johnson', 'Bob Smith', 'Charlie Brown', 'Diana Prince'];
    final domains = ['gmail.com', 'yahoo.com', 'outlook.com', 'company.com'];
    
    return User(
      id: random.nextInt(1000),
      name: names[random.nextInt(names.length)],
      email: '${names[random.nextInt(names.length)].toLowerCase().replaceAll(' ', '.')}@${domains[random.nextInt(domains.length)]}',
      avatar: 'https://picsum.photos/100/100?random=${random.nextInt(100)}',
    );
  }
  
  static int get requestCount => _requestCount;
  static void resetCounter() => _requestCount = 0;
}

// ❌ BAD IMPLEMENTATION - Creates Memory Leaks
class BadImplementation extends StatefulWidget {
  @override
  _BadImplementationState createState() => _BadImplementationState();
}

class _BadImplementationState extends State<BadImplementation> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('❌ BAD: Memory Leak Version'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          // Warning Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.red.shade100,
            child: Column(
              children: [
                Icon(Icons.warning, color: Colors.red, size: 30),
                SizedBox(height: 8),
                Text(
                  'MEMORY LEAK ALERT!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'Future created in build() method',
                  style: TextStyle(color: Colors.red.shade700),
                ),
                Text(
                  'API Calls: ${ApiService.requestCount}',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Counter: $_counter',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  
                  // BAD: Future created in build method
                  Expanded(
                    child: FutureBuilder<User>(
                      // 🚨 PROBLEM: New Future created on every build/setState
                      future: ApiService.fetchUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Loading... (API Call in progress)'),
                            ],
                          );
                        }
                        
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, color: Colors.red, size: 50),
                                Text('Error: ${snapshot.error}'),
                              ],
                            ),
                          );
                        }
                        
                        if (snapshot.hasData) {
                          final user = snapshot.data!;
                          return Center(
                            child: Card(
                              elevation: 4,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(user.avatar),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      user.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      user.email,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text('ID: ${user.id}'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        
                        return Center(child: Text('No data'));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _counter++;
          });
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
        tooltip: 'Increment (triggers rebuild)',
      ),
    );
  }
}

// ✅ GOOD IMPLEMENTATION - No Memory Leaks
class GoodImplementation extends StatefulWidget {
  @override
  _GoodImplementationState createState() => _GoodImplementationState();
}

class _GoodImplementationState extends State<GoodImplementation> {
  int _counter = 0;
  late Future<User> _userFuture; // Future declared as instance variable
  
  @override
  void initState() {
    super.initState();
    // ✅ SOLUTION: Future created only once in initState
    _userFuture = ApiService.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('✅ GOOD: Optimized Version'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Success Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.green.shade100,
            child: Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 30),
                SizedBox(height: 8),
                Text(
                  'MEMORY OPTIMIZED!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  'Future created in initState()',
                  style: TextStyle(color: Colors.green.shade700),
                ),
                Text(
                  'API Calls: ${ApiService.requestCount}',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Counter: $_counter',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  
                  // GOOD: Future reused from instance variable
                  Expanded(
                    child: FutureBuilder<User>(
                      // ✅ SOLUTION: Reusing the same Future instance
                      future: _userFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Loading... (Single API Call)'),
                            ],
                          );
                        }
                        
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, color: Colors.red, size: 50),
                                Text('Error: ${snapshot.error}'),
                              ],
                            ),
                          );
                        }
                        
                        if (snapshot.hasData) {
                          final user = snapshot.data!;
                          return Center(
                            child: Card(
                              elevation: 4,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(user.avatar),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      user.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      user.email,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text('ID: ${user.id}'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        
                        return Center(child: Text('No data'));
                      },
                    ),
                  ),
                  
                  // Refresh Button
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _userFuture = ApiService.fetchUserData();
                      });
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Refresh User Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _counter++;
          });
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        tooltip: 'Increment (no extra API calls)',
      ),
    );
  }
}