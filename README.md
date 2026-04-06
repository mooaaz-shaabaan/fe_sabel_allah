# في سبيل الله — Fe Sabel Allah 🕌

تطبيق Flutter لإدارة المجموعات الدعوية ومتابعة الأعضاء، مبني بأحدث تقنيات Dart وFirebase.

---

## 📱 نبذة عن التطبيق

**في سبيل الله** هو تطبيق موبايل مخصص للعمل الدعوي والتنظيمي، يتيح لقادة المجموعات إدارة الأعضاء، تسجيل الزيارات، ومتابعة الخروج والعودة بشكل منظم وآلي.

---

## ✨ المميزات الرئيسية

- **إدارة المجموعات** — إنشاء مجموعات دعوية ومتابعتها
- **إدارة الأعضاء** — إضافة، تعديل، وحذف الأعضاء مع بياناتهم الكاملة (الاسم، الهاتف، العمر، الكلية، الجامعة)
- **تسجيل الزيارات** — تسجيل زيارات الأعضاء مع حفظ تاريخ كل زيارة
- **نظام الخروج (خروج في سبيل الله)** — تسجيل خروج العضو مع تحديد المدة (3 أيام / 40 يوم / 4 شهور) وتاريخ الانتهاء
- **إعادة الضبط التلقائي** — يُعاد تلقائياً وضع العضو كـ"موجود" بعد انتهاء مدة الخروج
- **البحث الفوري** — البحث عن الأعضاء بالاسم أو رقم الهاتف
- **طلبات الانضمام** — قبول أو رفض طلبات الانضمام للمجموعات
- **التواصل المباشر** — الاتصال بالأعضاء أو مراسلتهم عبر WhatsApp مباشرةً من التطبيق
- **صور أفاتار إسلامية** — يُعيَّن لكل عضو أفاتار إسلامي عشوائي
- **دعم الوضع الليلي** — واجهة مصممة لتدعم Dark Mode

---

## 🛠️ التقنيات المستخدمة

| التقنية | الاستخدام |
|---|---|
| **Flutter** | إطار عمل الواجهة (Android & iOS) |
| **Dart SDK ^3.11.1** | لغة البرمجة |
| **Firebase Firestore** | قاعدة البيانات السحابية |
| **Firebase Auth** | المصادقة وتسجيل الدخول |
| **Google Sign-In** | تسجيل الدخول بجوجل |
| **Flutter Facebook Auth** | تسجيل الدخول بفيسبوك |
| **Flutter BLoC** | إدارة الحالة (State Management) |
| **Hive CE** | التخزين المحلي |
| **flutter_screenutil** | تكييف الحجم لشاشات مختلفة |
| **url_launcher** | فتح الهاتف وWhatsApp |
| **Equatable** | مقارنة الحالات في BLoC |

---

## 🗂️ هيكل المشروع

```
lib/
├── logic/
│   ├── add_khrog_and_visit/   # Cubit: تسجيل الخروج والزيارات
│   ├── add_member/            # Cubit: إضافة وتعديل الأعضاء
│   └── details_groub/         # Cubit: تفاصيل المجموعة والأعضاء
├── model/
│   ├── member_model.dart      # موديل العضو
│   └── user_model.dart        # موديل المستخدم
├── const/
│   └── images.dart            # مسارات الأفاتار الإسلامية
├── firebase_options.dart      # إعدادات Firebase
└── main.dart                  # نقطة البداية
assets/
├── logo/
├── islamic_avatar/
└── fonts/Tajawal/             # خط تجوال (خفيف → أسود)
```

---

## 🚀 تشغيل المشروع

### المتطلبات

- Flutter SDK ≥ 3.11.1
- Dart SDK ^3.11.1
- حساب Firebase (الـ project موجود: `fe-sabel-allah`)

### خطوات التشغيل

```bash
# 1. استنسخ المستودع
git clone https://github.com/your-username/fe_sabel_allah.git
cd fe_sabel_allah

# 2. ثبّت الـ dependencies
flutter pub get

# 3. ولّد ملفات Hive
dart run build_runner build --delete-conflicting-outputs

# 4. شغّل التطبيق
flutter run
```

---

## 🔥 إعداد Firebase

ملفات Firebase موجودة بالفعل في المشروع:

- `android/app/google-services.json`
- `lib/firebase_options.dart`
- `firebase.json`

> ⚠️ **تنبيه:** لا ترفع `google-services.json` أو مفاتيح API على مستودع عام. أضف هذه الملفات إلى `.gitignore`.

---

## 📦 Dependencies الرئيسية

```yaml
dependencies:
  firebase_core: ^4.6.0
  cloud_firestore: ^6.2.0
  firebase_auth: ^6.3.0
  flutter_bloc: ^9.1.1
  google_sign_in: 6.2.1
  flutter_facebook_auth: ^7.1.6
  hive_ce: ^2.19.3
  url_launcher: ^6.3.2
  flutter_screenutil: ^5.9.3
  equatable: ^2.0.8

dev_dependencies:
  hive_ce_generator: ^1.11.1
  build_runner: ^2.13.1
```

---

## 🌙 الخطوط المستخدمة

خط **Tajawal** بمختلف الأوزان:

| الوزن | الملف |
|---|---|
| 300 | Tajawal-Light.ttf |
| 400 | Tajawal-Regular.ttf |
| 500 | Tajawal-Medium.ttf |
| 700 | Tajawal-Bold.ttf |
| 800 | Tajawal-ExtraBold.ttf |
| 900 | Tajawal-Black.ttf |

---

## 🤝 المساهمة

المشروع خاص حالياً (`publish_to: none`). للمساهمة، تواصل مع صاحب المشروع.

---

## 📄 الترخيص

جميع الحقوق محفوظة © 2024 — Moaz