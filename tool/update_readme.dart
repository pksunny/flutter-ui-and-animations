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

  folders.sort((a, b) {
    final aNum = int.tryParse(RegExp(r'^\d+').stringMatch(a) ?? '') ?? 0;
    final bNum = int.tryParse(RegExp(r'^\d+').stringMatch(b) ?? '') ?? 0;
    return aNum.compareTo(bNum);
  });

  final buffer = StringBuffer();

  // ⚡️ Cyberpunk Intro
  buffer.writeln('# 🧬✨ Flutter Animation Universe ⚡️\n');
  buffer.writeln(
      '> **A Cyberpunk-Styled Galaxy of Flutter UI & Animations**\n');
  buffer.writeln(
      'Welcome to **Flutter Animation Universe** — a 🔮 futuristic, high-performance Flutter showcase crafted by **Muhammad Hassan Hafeez**.\n');
  buffer.writeln(
      'This repo is a digital playground 🕹️ full of **jaw-dropping UI**, **smooth transitions**, and **cyber-cool animations** that push the boundaries of Flutter.\n');

  buffer.writeln('---\n');

  // 🌀 Animated Index First
  buffer.writeln('## 🌀 Animated UI & Screen Index\n');
  for (var i = 0; i < folders.length; i++) {
    final name = folders[i];
    buffer.writeln('**${i + 1}.** [`$name`](lib/screens/$name/) 🔹');
  }

  buffer.writeln('\n---\n');

  // 👤 About
  buffer.writeln('## 👤 Who Am I?\n');
  buffer.writeln(
      'I’m **Muhammad Hassan Hafeez** — a digital artisan 🔧 who sculpts **next-gen mobile UI** using Flutter + ❤️.\n');
  buffer.writeln(
      'From seamless transitions to pixel-perfect microinteractions, I build things that move minds and move smoothly.\n');

  // 🔗 Social
  buffer.writeln('\n## 🌐 Contact & Cyber Channels\n');
  buffer.writeln('| 🔹 Platform | 🔗 Link |');
  buffer.writeln('|------------|---------|');
  buffer.writeln('| 📧 Email | sunnypk0312@gmail.com |');
  buffer.writeln('| 📞 Mobile | +92 312 1529141 |');
  buffer.writeln('| 💬 WhatsApp | [Message Me](https://wa.me/+923121529141) |');
  buffer.writeln('| 📺 YouTube | [@muhammadhassanhafeez](https://youtube.com/@muhammadhassanhafeez?si=PqclYNV0IegFOJbW) |');
  buffer.writeln('| 📸 Instagram | [@muhammad_hassanhafeez.dev](https://www.instagram.com/muhammad_hassanhafeez.dev/) |');
  buffer.writeln('| 🎵 TikTok | [@muhammadhassanhafeez.dev](https://www.tiktok.com/@muhammadhassanhafeez.dev) |');
  buffer.writeln('| 🧑‍🎨 Behance | [Portfolio](https://www.behance.net/muhammadhassanhafeez) |');
  buffer.writeln('| 💼 LinkedIn | [Connect](https://www.linkedin.com/in/muhammad-hassan-hafeez/) |');
  buffer.writeln('| 🐙 GitHub | [@pksunny](https://github.com/pksunny) |');
  buffer.writeln('| 💼 Upwork | [Hire Me](https://www.upwork.com/freelancers/~0102bc13bd382f7504?mp_source=share) |');
  buffer.writeln('| 🌐 Freelancer | [@PkSunny0](https://www.freelancer.com/u/PkSunny0) |\n');

  buffer.writeln('---\n');

  // 🤝 Final CTA
  buffer.writeln('## 🤝 Join the Movement\n');
  buffer.writeln('- ⭐ Star this repo to support premium Flutter content');
  buffer.writeln('- 🌀 Fork and remix your own animations');
  buffer.writeln('- 💡 Share ideas, collab, or contribute\n');

  buffer.writeln('> ⚡ *“Code is not just logic, it’s an experience.”*\n');

  await readme.writeAsString(buffer.toString());
  print('✅ README.md cyberpunk edition generated!');
}
