import 'dart:io';
import 'package:path/path.dart' as p;

void main() async {
  final screenDir = Directory('lib/screens');
  final readme = File('README.md');

  if (!screenDir.existsSync()) {
    print('❌ Directory lib/screens not found!');
    return;
  }

  final folders = screenDir
      .listSync()
      .whereType<Directory>()
      .map((d) => p.basename(d.path))
      .toList();

  // ✅ Fix: Sort by numeric prefix
  folders.sort((a, b) {
    final aNum = int.tryParse(RegExp(r'^\d+').stringMatch(a) ?? '') ?? 0;
    final bNum = int.tryParse(RegExp(r'^\d+').stringMatch(b) ?? '') ?? 0;
    return aNum.compareTo(bNum);
  });

  final buffer = StringBuffer();
  buffer.writeln('# 🚀 Flutter UI and Animation Collection\n');

  for (var i = 0; i < folders.length; i++) {
    final name = folders[i];
    buffer.writeln('${i + 1}. [$name](lib/screens/$name/)');
  }

  await readme.writeAsString(buffer.toString());
  print('✅ README.md updated with numeric sort!');
}
