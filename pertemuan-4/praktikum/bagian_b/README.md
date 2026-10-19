# Bagian B — Paket HTTP

Tambahkan package HTTP dari terminal pada folder project Flutter:

```bash
flutter pub add http
```

Untuk Android, pastikan izin internet ada di `android/app/src/main/AndroidManifest.xml`, di luar tag `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

Package `http` digunakan untuk mengirim request ke REST API dan menerima respons dari server.
