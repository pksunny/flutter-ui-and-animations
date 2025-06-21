import 'package:flutter/material.dart';


class PerformanceDemo extends StatefulWidget {
  const PerformanceDemo({super.key});

  @override
  State<PerformanceDemo> createState() => _PerformanceDemoState();
}

class _PerformanceDemoState extends State<PerformanceDemo> {
  int _counter = 0;
  static int _badBuilds = 0;
  static int _goodBuilds = 0;
  static String _lastBuildWidget = "";
  static DateTime _lastBuildTime = DateTime.now();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _resetCounters() {
    setState(() {
      _badBuilds = 0;
      _goodBuilds = 0;
      _lastBuildWidget = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    print('🏗️ Main rebuild - Counter: $_counter');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Const vs Non-Const Performance'),
        backgroundColor: Colors.blue.shade100,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Top Controls - Compact
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Counter: $_counter', 
                             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Last Build: $_lastBuildWidget', 
                             style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _incrementCounter,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text('Increment'),
                      ),
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: _resetCounters,
                        child: const Text('Reset', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Performance Stats - Compact
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.green.shade50],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('📊 Build Stats', 
                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text('❌ Bad Widgets: $_badBuilds builds', 
                             style: const TextStyle(color: Colors.red, fontSize: 12)),
                        Text('✅ Good Widgets: $_goodBuilds builds', 
                             style: const TextStyle(color: Colors.green, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: [
                        const Text('Performance', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        Text(
                          '${_badBuilds > 0 ? ((_badBuilds - _goodBuilds) / _badBuilds * 100).toStringAsFixed(0) : "0"}%',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        const Text('Better', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Widget Comparison - Side by Side
            Expanded(
              child: Row(
                children: [
                  // Bad Widgets Column
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.warning, color: Colors.red, size: 20),
                              const SizedBox(width: 6),
                              const Expanded(
                                child: Text(
                                  'Without const',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('$_badBuilds', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: Column(
                              children: [
                                BadWidget(title: "Header", color: Colors.red.shade100),
                                const SizedBox(height: 8),
                                BadWidget(title: "Content", color: Colors.orange.shade100),
                                const SizedBox(height: 8),
                                BadWidget(title: "Footer", color: Colors.pink.shade100),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Good Widgets Column
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green, size: 20),
                              const SizedBox(width: 6),
                              const Expanded(
                                child: Text(
                                  'With const',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('$_goodBuilds', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Expanded(
                            child: Column(
                              children: [
                                GoodWidget(title: "Header", color: Colors.lightGreen),
                                SizedBox(height: 8),
                                GoodWidget(title: "Content", color: Colors.green),
                                SizedBox(height: 8),
                                GoodWidget(title: "Footer", color: Colors.teal),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Bottom Instructions
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '💡 Tap "Increment" to trigger rebuilds and watch the difference!',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ❌ BAD: No const constructor
class BadWidget extends StatelessWidget {
  final String title;
  final Color color;
  
  BadWidget({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    _PerformanceDemoState._badBuilds++;
    _PerformanceDemoState._lastBuildWidget = "❌ Bad $title";
    _PerformanceDemoState._lastBuildTime = DateTime.now();
    
    print('❌ Bad $title widget built! (Total bad builds: ${_PerformanceDemoState._badBuilds})');
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.red.shade400, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '#${_PerformanceDemoState._badBuilds}',
              style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ GOOD: With const constructor
class GoodWidget extends StatelessWidget {
  final String title;
  final Color color;
  
  const GoodWidget({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    _PerformanceDemoState._goodBuilds++;
    _PerformanceDemoState._lastBuildWidget = "✅ Good $title";
    _PerformanceDemoState._lastBuildTime = DateTime.now();
    
    print('✅ Good $title widget built! (Total good builds: ${_PerformanceDemoState._goodBuilds})');
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.shade400, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '#${_PerformanceDemoState._goodBuilds}',
              style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}