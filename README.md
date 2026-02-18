# 🧠 Mood AI - Yapay Zeka Destekli Duygu Asistanı

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Gemini AI](https://img.shields.io/badge/Google%20Gemini-AI-8E75B2?style=for-the-badge)

**Mood AI**, kullanıcıların anlık duygu durumlarını analiz eden, onlara özel motivasyonel tavsiyeler veren ve bu duygu yolculuğunu kayıt altına alan akıllı bir mobil uygulamadır.

## 🚀 Projenin Amacı
Günlük hayatta yaşanan duygusal dalgalanmaları anlamlandırmak ve kullanıcılara yapay zeka destekli, empatik bir "Yaşam Koçu" deneyimi sunmak.

## ✨ Temel Özellikler

- **🤖 Yapay Zeka Analizi:** Google Gemini 1.5 Flash modeli ile doğal dil işleme (NLP) yapılarak kullanıcının metni analiz edilir.
- **🎨 Glassmorphism Arayüz:** Modern, şeffaf ve estetik "Buzlu Cam" tasarım dili.
- **⏰ Dinamik Karşılama:** Günün saatine göre (Sabah, Öğle, Akşam) değişen akıllı arayüz mesajları.
- **💾 Yerel Veritabanı:** `SharedPreferences` kullanılarak verilerin telefon hafızasında güvenle saklanması.
- **📜 Geçmiş Takibi:** Eski analizlerin ve tavsiyelerin tarihçesini görüntüleme imkanı.

## 🛠️ Kullanılan Teknolojiler ve Mimari

Bu proje **Modüler Mimari** prensiplerine uygun olarak geliştirilmiştir:

- **Dil:** Dart
- **Framework:** Flutter
- **Yapay Zeka:** Google Generative AI (Gemini REST API)
- **Veri Saklama:** Shared Preferences (Local Storage)
- **HTTP İstekleri:** `http` paketi ile asenkron veri iletişimi.

### Klasör Yapısı
lib/
├── config/      # Tema ve Renk Konfigürasyonları
├── models/      # Veri Modelleri (JSON Parsing)
├── pages/       # Kullanıcı Arayüzü (UI) Sayfaları
├── services/    # API ve Backend İletişim Servisleri
├── widgets/     # Tekrar Kullanılabilir UI Bileşenleri
└── main.dart    # Uygulama Başlatıcısı

## 🔧 Kurulum

Projeyi yerel ortamınızda çalıştırmak için:

1. Depoyu klonlayın:
   ```bash
   git clone [https://github.com/KULLANICI_ADINIZ/mood-ai.git](https://github.com/KULLANICI_ADINIZ/mood-ai.git)

Gerekli paketleri yükleyin:

flutter pub get

Uygulamayı başlatın:

flutter run
