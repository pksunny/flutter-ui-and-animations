import 'package:flutter/material.dart';
import 'dart:math';


class PerformanceDemoSetStateVsValueNotifier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('setState vs ValueNotifier Demo'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              children: [
                SlowSetStateExample(),
                FastValueNotifierExample(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ❌ SLOW APPROACH - setState()
class SlowSetStateExample extends StatefulWidget {
  @override
  _SlowSetStateExampleState createState() => _SlowSetStateExampleState();
}

class _SlowSetStateExampleState extends State<SlowSetStateExample> {
  int _counter = 0;
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    // Har build par count increase hota hai
    _rebuildCount++;
    
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: Text('❌ setState() - SLOW'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          // Performance stats
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text('🐌 Total Rebuilds: $_rebuildCount', 
                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Counter: $_counter', style: TextStyle(fontSize: 16)),
                Text('⚠️ Whole widget tree rebuild on every increment'),
              ],
            ),
          ),
          
          // Expensive widgets jo unnecessarily rebuild hote hain
          Expanded(
            child: ListView.builder(
              itemCount: 50,
              itemBuilder: (context, index) {
                return ExpensiveListTile(
                  index: index,
                  isSetState: true,
                );
              },
            ),
          ),
          
          // Counter controls
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _counter++;
                    });
                  },
                  child: Text('Increment'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _rebuildCount = 0;
                      _counter = 0;
                    });
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ FAST APPROACH - ValueNotifier wala
class FastValueNotifierExample extends StatelessWidget {
  final ValueNotifier<int> _counter = ValueNotifier(0);
  final ValueNotifier<int> _rebuildCount = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text('✅ ValueNotifier - FAST'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Performance stats
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ValueListenableBuilder<int>(
              valueListenable: _rebuildCount,
              builder: (context, rebuilds, child) {
                return Column(
                  children: [
                    Text('🚀 Selective Rebuilds: $rebuilds', 
                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ValueListenableBuilder<int>(
                      valueListenable: _counter,
                      builder: (context, count, child) {
                        return Text('Counter: $count', style: TextStyle(fontSize: 16));
                      },
                    ),
                    Text('✅ Only Counter Widget Rebuild'),
                  ],
                );
              },
            ),
          ),
          
          // Same expensive widgets - lekin ye rebuild NAHI hote!
          Expanded(
            child: ListView.builder(
              itemCount: 50,
              itemBuilder: (context, index) {
                return ExpensiveListTile(
                  index: index,
                  isSetState: false,
                );
              },
            ),
          ),
          
          // Counter controls
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _counter.value++;
                    _rebuildCount.value++;
                  },
                  child: Text('Increment'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _counter.value = 0;
                    _rebuildCount.value = 0;
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Expensive widget jo performance impact dikhane ke liye hai
class ExpensiveListTile extends StatelessWidget {
  final int index;
  final bool isSetState;
  
  // Build count track karne ke liye static variables
  static int setStateBuildCount = 0;
  static int valueNotifierBuildCount = 0;

  ExpensiveListTile({required this.index, required this.isSetState});

  @override
  Widget build(BuildContext context) {
    // Build count track karo
    if (isSetState) {
      setStateBuildCount++;
    } else {
      valueNotifierBuildCount++;
    }
    
    // Kuch expensive calculations simulate karte hain
    final randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: randomColor.shade200,
          child: Text('$index'),
        ),
        title: Text('Expensive Widget #$index'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🔥 Heavy calculations here...'),
            Text(isSetState 
              ? 'setState builds: $setStateBuildCount'
              : 'ValueNotifier builds: $valueNotifierBuildCount'),
          ],
        ),
        trailing: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: randomColor.shade100,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(Icons.widgets, color: randomColor.shade800),
        ),
      ),
    );
  }
}

// Real-time performance tracking ke liye helper
class PerformanceTracker {
  static int totalSetStateBuilds = 0;
  static int totalValueNotifierBuilds = 0;
  
  static void trackSetStateBuild() {
    totalSetStateBuilds++;
    print('🐌 setState build count: $totalSetStateBuilds');
  }
  
  static void trackValueNotifierBuild() {
    totalValueNotifierBuilds++;
    print('🚀 ValueNotifier build count: $totalValueNotifierBuilds');
  }
  
  static void reset() {
    totalSetStateBuilds = 0;
    totalValueNotifierBuilds = 0;
    ExpensiveListTile.setStateBuildCount = 0;
    ExpensiveListTile.valueNotifierBuildCount = 0;
  }
}