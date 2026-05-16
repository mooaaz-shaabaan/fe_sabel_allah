<div align="center">

<img src="https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white"/>
<img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter"/>
<img src="https://img.shields.io/badge/Firebase-Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black"/>
<img src="https://img.shields.io/badge/Architecture-BLoC-6C63FF?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Offline-Hive-success?style=for-the-badge"/>

<br/>

# 🕌 في سبيل الله — Fe Sabel Allah

### Organize Da'wah groups with smart tracking, reminders and member management.

تطبيق Flutter لإدارة المجموعات الدعوية ومتابعة الأعضاء والزيارات وتنظيم العمل الدعوي بشكل سهل ومنظم.

<br/>

<img src="assets/banner.png" width="100%">

</div>

---

# 📱 نبذة عن التطبيق

**في سبيل الله** هو تطبيق موبايل مخصص للعمل الدعوي والتنظيمي، يتيح لقادة المجموعات إدارة الأعضاء ومتابعة الزيارات والخروج والعودة بشكل منظم وآلي.

بدل الاعتماد على الطرق التقليدية، التطبيق يجمع كل المهام في مكان واحد:

- إدارة المجموعات
- متابعة الأعضاء
- تسجيل الزيارات
- نظام الخروج والعودة
- التنبيهات التلقائية
- العمل بدون إنترنت

---

# ✨ المميزات

### 👥 إدارة المجموعات
- إنشاء مجموعات دعوية
- الانضمام عبر كود
- استقبال طلبات الانضمام وقبولها أو رفضها

### 🧑‍🤝‍🧑 إدارة الأعضاء
- إضافة وتعديل وحذف الأعضاء
- ملفات أعضاء كاملة:
   - الاسم
   - الهاتف
   - العمر
   - الكلية
   - الجامعة

- أفاتارات إسلامية عشوائية
- بحث سريع بالاسم أو رقم الهاتف

### 📋 الزيارات

- تسجيل الزيارات
- حفظ سجل كامل لكل عضو
- الرجوع لسجل الزيارات بسهولة

### 🚗 نظام الخروج في سبيل الله

يمكن تسجيل خروج العضو لمدة:

- 3 أيام
- 40 يوم
- 4 شهور

مع:

- حفظ تاريخ البداية
- حساب تاريخ الانتهاء تلقائياً
- إعادة العضو تلقائياً لحالة "موجود"

### 🔔 التنبيهات الذكية

- تذكير بانتهاء مدة الخروج
- إشعارات تعمل بالخلفية
- تعمل حتى والتطبيق مغلق

### 📡 Offline First

- تخزين محلي عبر Hive
- مزامنة تلقائية مع Firestore
- استمرار العمل بدون إنترنت

### 🌙 واجهة محسنة

- دعم الوضع الليلي
- تصميم RTL كامل
- خط Tajawal

---

# 🎬 لقطات الشاشة

<p align="center">

<img src="screenshots/1.png" width="220"/>
<img src="screenshots/2.png" width="220"/>
<img src="screenshots/3.png" width="220"/>

</p>

> يمكنك استبدال الصور بصور حقيقية أو GIF للتطبيق.

---

# 🏗 Architecture

يعتمد المشروع على فصل المسؤوليات باستخدام Cubit:

```text
Presentation
      ↓
Cubit (Business Logic)
      ↓
Repository
      ↓
Firebase + Hive
```

ويستخدم نمط BLoC/Cubit لتنظيم الـ Business Logic.

---

# 🛠 التقنيات المستخدمة

| التقنية | الاستخدام |
|---|---|
| Flutter | واجهة المستخدم |
| Dart SDK ^3.11 | لغة البرمجة |
| flutter_bloc | إدارة الحالة |
| Firebase Firestore | قاعدة البيانات |
| Firebase Auth | المصادقة |
| Google Sign In | تسجيل الدخول بجوجل |
| Facebook Auth | تسجيل الدخول بفيسبوك |
| Hive CE | التخزين المحلي |
| flutter_local_notifications | الإشعارات |
| WorkManager | تشغيل المهام بالخلفية |
| flutter_screenutil | Responsive |
| url_launcher | الهاتف وواتساب |
| Equatable | مقارنة الحالات |

---

# 📂 هيكل المشروع

```bash
lib/
│
├── screens/
│
├── logic/
│   ├── add_khrog_and_visit/
│   ├── add_member/
│   ├── details_groub/
│   └── cubits/
│
├── model/
│   ├── member_model.dart
│   └── user_model.dart
│
├── shared/
│   ├── services/
│   ├── notifications/
│   └── permissions/
│
├── const/
│
├── firebase_options.dart
│
└── main.dart


assets/
│
├── logo/
├── islamic_avatar/
└── fonts/Tajawal/
```

---

# 🚀 تشغيل المشروع

### المتطلبات

- Flutter SDK ≥ 3.x
- Dart SDK ≥ 3.11
- Firebase configured

### التثبيت

```bash
git clone https://github.com/your-username/fe_sabel_allah.git

cd fe_sabel_allah

flutter pub get

dart run build_runner build --delete-conflicting-outputs

flutter run
```

بناء نسخة Release:

```bash
flutter build apk --release
```

---

# 🔥 إعداد Firebase

الملفات المطلوبة:

```text
android/app/google-services.json

lib/firebase_options.dart

firebase.json
```

⚠️ لا ترفع مفاتيح Firebase أو ملفات API لمستودع عام.

---

# 📦 Dependencies الرئيسية

```yaml
dependencies:
  firebase_core:
  cloud_firestore:
  firebase_auth:
  flutter_bloc:
  google_sign_in:
  flutter_facebook_auth:
  hive_ce:
  flutter_screenutil:
  flutter_local_notifications:
  workmanager:
  url_launcher:
```

---

# 🌱 الخطط المستقبلية

- [ ] دعم iOS
- [ ] صفحة إحصائيات وتقارير
- [ ] تصدير PDF
- [ ] لوحة تحكم Admin
- [ ] دعم تعدد اللغات
- [ ] تحسين الإشعارات الذكية

---

# 🌙 الخطوط المستخدمة

Tajawal:

- Light
- Regular
- Medium
- Bold
- ExtraBold
- Black

---

<div align="center">

Made with ❤️ for the sake of Allah

صُنع بنية صالحة لوجه الله

</div>
