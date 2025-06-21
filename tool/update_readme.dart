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

  // ✅ Sort folders by numeric prefix
  folders.sort((a, b) {
    final aNum = int.tryParse(RegExp(r'^\d+').stringMatch(a) ?? '') ?? 0;
    final bNum = int.tryParse(RegExp(r'^\d+').stringMatch(b) ?? '') ?? 0;
    return aNum.compareTo(bNum);
  });

  final buffer = StringBuffer();

  // 🧠 Intro Section
  buffer.writeln('# 🚀 Flutter UI and Animation Collection\n');
  buffer.writeln(
      'Welcome to the **Flutter Animation Showcase** — a curated collection of high-quality Flutter UI animations built by **Muhammad Hassan Hafeez**.\n');
  buffer.writeln(
      'This repository features a variety of animations, UI challenges, and performance optimization techniques to help you master Flutter development.\n');

  buffer.writeln('---\n');

  // 📁 Folder List Section
  buffer.writeln('## 📁 Animation Index\n');
  for (var i = 0; i < folders.length; i++) {
    final name = folders[i];
    buffer.writeln('${i + 1}. [$name](lib/screens/$name/)');
  }

  buffer.writeln('\n---\n');

  // 👨‍💻 About & Social Links
  buffer.writeln('## 👨‍💻 About Me\n');
  buffer.writeln(
      'I’m **Muhammad Hassan Hafeez**, a Flutter developer passionate about building elegant and efficient mobile UI experiences.\n');
  buffer.writeln(
      'I create bite-sized animation tutorials, UI challenges, and performance optimization guides — all focused on Flutter.\n');

  buffer.writeln('\n## 📬 Contact & Socials\n');
  buffer.writeln('| Platform | Link |');
  buffer.writeln('|----------|------|');
  buffer.writeln('| 📧 Email | sunnypk0312@gmail.com |');
  buffer.writeln('| 📞 Mobile | +92 312 1529141 |');
  buffer.writeln('| 💬 WhatsApp | [Message Me](https://wa.me/+923121529141) |');
  buffer.writeln('| 📺 YouTube | [@muhammadhassanhafeez](https://youtube.com/@muhammadhassanhafeez?si=PqclYNV0IegFOJbW) |');
  buffer.writeln('| 📸 Instagram | [@muhammad_hassanhafeez.dev](https://www.instagram.com/muhammad_hassanhafeez.dev/) |');
  buffer.writeln('| 🎵 TikTok | [@muhammadhassanhafeez.dev](https://www.tiktok.com/@muhammadhassanhafeez.dev)');
  buffer.writeln('| 🧑‍🎨 Portfolio | [Behance](https://www.behance.net/muhammadhassanhafeez) |');
  buffer.writeln('| 💼 LinkedIn | [LinkedIn Profile](https://www.linkedin.com/in/muhammad-hassan-hafeez/) |');
  buffer.writeln('| 🐙 GitHub | [@pksunny](https://github.com/pksunny) |');
  buffer.writeln('| 💼 Upwork | [Freelancer Profile](https://www.upwork.com/freelancers/~0102bc13bd382f7504?mp_source=share) |');
  buffer.writeln('| 🌐 Freelancer.com | [@PkSunny0](https://www.freelancer.com/u/PkSunny0) |\n');

  buffer.writeln('---\n');

  buffer.writeln('## 🤝 Let\'s Connect\n');
  buffer.writeln('If you find this repository helpful or inspiring:\n');
  buffer.writeln('- ⭐ Star this repo');
  buffer.writeln('- 📥 Fork it for your use');
  buffer.writeln('- 🧠 Contribute ideas\n');

  buffer.writeln('> ✨ *“Bringing code to life — one Flutter animation at a time.”*\n');

  await readme.writeAsString(buffer.toString());
  print('✅ README.md updated with all contact links and animations!');
}
