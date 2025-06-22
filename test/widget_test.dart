// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:endemicdb_new/main.dart'; // Pastikan nama package sesuai

void main() {
  testWidgets('SplashScreen menampilkan logo dan teks', (WidgetTester tester) async {
    // Bangun MyApp dan render frame
    await tester.pumpWidget(const MyApp());

    // Cari widget berdasarkan teks atau gambar
    expect(find.text('EndemicDB'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Tidak ada tombol add, jadi hapus test untuk Icon(Icons.add)
  });

  testWidgets('Navigasi dari SplashScreen ke HomeScreen', (WidgetTester tester) async {
    // Bangun MyApp
    await tester.pumpWidget(const MyApp());

    // Simulasikan lewat waktu splash screen (3 detik)
    await tester.pump(const Duration(seconds: 3));

    // Pastikan kita sudah beralih ke halaman utama (HomeScreen)
    expect(find.text('Selamat datang di EndemicDB'), findsOneWidget);
  });
}