# PO REVIEW — App Flutter "Thần Số Học / Numerology"

> **Vai trò:** Product Owner review toàn bộ codebase (chỉ đọc code, không build).
> **Phạm vi đã đọc:** `lib/main.dart`, `lib/Pages/home/home.dart`, `lib/Pages/detail/detail.dart` + 4 tabs (`tab1.dart`, `tab2.dart`, `diengiai_tab3.dart`, `tab4.dart`), `lib/Pages/hangngay/hangngay.dart`, `lib/Pages/setting/setting.dart`, `lib/Pages/introl/intro.dart`, `lib/network/tsh_client.dart` + `tsh_client2.dart`, `lib/provider/` (admob, firebase analytics, shared_pref), `assets/data/*.json`, `lib/l10n/*.arb`, `pubspec.yaml`, `android/app/build.gradle`, `android/build.gradle`, `AndroidManifest.xml`, `lib/firebase_options.dart`, `lib/class/*`, `lib/components/*`.
> **Kết luận 1 dòng:** Đây là một MVP thần số học **chỉ xoay quanh ngày sinh** — user chọn ngày sinh → xem 3 tab diễn giải tĩnh lấy từ Firestore. Nội dung có sẵn đa ngôn ngữ là tài sản tốt, nhưng app gần như **chưa có monetization thực tế, không có retention loop, không có test, và tồn nhiều code chết + nợ kỹ thuật nghiêm trọng** (SDK cũ, secret lộ trong code, API HTTP chết).

---

## 1. Inventory tính năng hiện có

### 1.1. Cấu trúc app & điều hướng

| Hạng mục | Thực tế trong code |
|---|---|
| Entry point | `lib/main.dart:25-49` — khởi tạo Firebase (`Firebase.initializeApp` với `DefaultFirebaseOptions`), `MobileAds.instance.initialize()` (chỉ Android), đọc `SharedPreferences`, load locale, chạy `MyApp` |
| Màn hình gốc duy nhất | `MainPage` (`lib/main.dart:127-159`) chỉ render `HomePage()` qua `StreamBuilder` trên `langSteamController`. **Không có** bottom navigation đang hoạt động, không có router khai báo route nào ngoài `initialRoute: '/'` |
| Tổng code | ~5.572 dòng Dart (kể cả ~1.900 dòng generated l10n); code nghiệp vụ thật chỉ ~2.200 dòng |

### 1.2. Tính năng user nhìn thấy được (đang chạy thật)

| # | Tính năng | File | Ghi chú PO |
|---|---|---|---|
| 1 | **Chọn ngày sinh** (DatePicker 1900 → nay, format `dd-MM-yyyy` cho `vi`, `yyyy-MM-dd` cho locale khác) | `lib/Pages/home/home.dart:266-293` (`_buildDate`), `_changeDate` ở `:122-133` | Ngày sinh được lưu vào `SharedPreferences` key `birh_date_store` (sai chính tả "birh" xuyên suốt codebase) và tự khôi phục ở lần mở sau (`_get_birh_date`, `:135-148`) |
| 2 | **Tính Số Chủ Đạo** từ tổng chữ số ngày sinh `yyyyMMdd`, rút gọn đệ quy khi tổng `> 11` | `tinh_scd()` — `lib/Pages/home/home.dart:28-38`, tính lại trong `_submit()` `:175` | Chỉ giữ lại 11; **22 và 33 bị rút gọn mất** (xem mục 3) |
| 3 | **Tab 1 – Tổng quan Số Chủ Đạo**: 6 khối nội dung HTML: Nổi bật, Mục đích cuộc sống, Ưu điểm, Khuyết điểm, Đề xuất phát triển, Nghề nghiệp phù hợp + số chủ đạo khổ lớn 72pt | `lib/Pages/detail/tabs/tab1.dart` (toàn file), dữ liệu map ở `lib/Pages/detail/detail.dart:191-202` | Nội dung render bằng `flutter_html` từ field `scd_*` của Firestore |
| 4 | **Tab 2 – Mốc cuộc đời / 4 Đỉnh cao**: tính 4 đỉnh cao từ ngày/tháng/năm rút gọn, mốc tuổi bắt đầu `36 − số chủ đạo`, các mốc sau +9 năm; timeline 4 vòng tròn tuổi + 4 card tóm tắt đỉnh cao | `lib/Pages/detail/detail.dart:98-109` (`loaded`), `:206-215` (tuổi), `lib/Pages/detail/tabs/tab2.dart`, `lib/components/box_card.dart` | Card chỉ hiển thị `dinh_cao_tom_tat`; field chi tiết/rút gọn có trong dữ liệu nhưng không được dùng hết |
| 5 | **Tab 3 – Biểu đồ ngày sinh**: lưới 3×3 (các số 1–9 gom theo tần suất xuất hiện trong chuỗi ngày+tháng+năm) + danh sách card diễn giải từng `sns_key` có mặt | `lib/Pages/detail/tabs/diengiai_tab3.dart` (`buildTable`, `ListNumber` ở `lib/class/ListNumber.dart`), dữ liệu từ `getNgaySinh()` | Đây chính là "birth chart" dạng cơ bản — có sẵn nhưng trình bày rất thô (ô cao 32px, chỉ hiện chuỗi số lặp, không có mũi tên/mặt phẳng, không diễn giải số vắng mặt) |
| 6 | **Đổi ngôn ngữ**: bottom sheet chọn ngôn ngữ, lưu `langCur` vào SharedPreferences, phát qua stream để rebuild Home | `lib/Pages/setting/setting.dart`, `lib/class/Lang.dart:13-21` | Chỉ **3 ngôn ngữ được bật**: English (`en`), Tiếng Việt (`vi`), Hindi (`hi`). Các ngôn ngữ còn lại trong `listLang` đã bị comment out |
| 7 | **Persist 1 ngày sinh duy nhất** | `lib/provider/local_db/shared_pref.dart` (chỉ 2 dòng: khai báo `late final SharedPreferences myShared`) | Không có khái niệm hồ sơ/tên user — xem mục 4 |

### 1.3. Tính năng có code nhưng KHÔNG tới được user (code mồ côi / đã tắt)

| Tính năng | Bằng chứng | Trạng thái |
|---|---|---|
| **Tử vi hôm nay / hằng ngày** (`HangNgayPage`) | `lib/Pages/hangngay/hangngay.dart` — không file nào import/điều hướng tới; menu "Tử vi hôm nay" trong `lib/main.dart:84,93` đã bị comment | Mồ côi hoàn toàn |
| **Giới thiệu "Thần số học là gì"** (`introPage`) | `lib/Pages/introl/intro.dart` — không được tham chiếu ở đâu | Mồ côi hoàn toàn |
| **Tab 4 biểu đồ ngày sinh (bản cũ)** (`Tab4Page`) | `lib/Pages/detail/tabs/tab4.dart` — `DetailPage` khai `TabController(length: 3)` (`detail.dart:124-128`) và `TabBarView` chỉ có 3 children (`:272-278`); tab4 còn trỏ asset `assets/bg01.jpg` có thể không còn tồn tại trong `assets/` hiện tại | Code chết, trùng lặp logic với tab3 |
| **Interstitial Ad** | Nạp ad trong `home.dart:96-109` (`_createInterstitialAd`), nhưng toàn bộ block `.show()` trong `_submit()` (`:151-168`) đã bị comment → **ad nạp nhưng không bao giờ hiển thị** | Tắt ngầm |
| **Banner Ad / Rewarded Ad** | `AdMobService` định nghĩa đủ 3 ad unit (`lib/provider/admob/admob_service.dart:16-37`) nhưng không widget nào tạo `BannerAd`/`RewardedAd` để gắn vào UI | Chưa từng dùng |
| **Firebase Analytics** | `lib/provider/firebase/analytics/analytics_service.dart` — **toàn bộ 11 dòng đều bị comment**, kể cả import; lời gọi `AnalyticsService.I.analytics.logAppOpen()` trong `home.dart:170` cũng bị comment | Tắt hoàn toàn — app bay mù, không đo được funnel |
| **Tính năng Tết** (chúc Tết 26 lời chúc, gieo quẻ/lì xì, lắc điện thoại…) | 52/95 key trong mỗi file `.arb` là `chuc_tet_title_*`, `chuc_tet_mean_*`, `sowing_hexagrams`, `shake_phone_to_sow_hex`, `open_red_envelopes`… nhưng không còn UI nào dùng; dependencies `confetti`, `card_swiper` khai trong `pubspec.yaml` mà không file Dart nào import | Tính năng mùa vụ đã gỡ UI, để lại "xác" trong i18n + pubspec + thư mục `assets/tet/` (đang bị dùng làm theme chính: `bg.png`, `logo_home.png`) |

### 1.4. Dữ liệu local — `assets/data/*.json`

Các file JSON **không được load ở runtime** (không có `rootBundle.loadString('assets/data/...')` nào đang hoạt động — đoạn duy nhất nằm trong FAB đã comment ở `lib/main.dart:143-157`, vốn dùng để *seed* dữ liệu lên Firestore). Chúng là dữ liệu nguồn/seed:

| File | Số mục | Cấu trúc (keys) | Phân bố ngôn ngữ |
|---|---|---|---|
| `sochudao.json` | 10 | `scd_number, scd_muc_dich, scd_diem_noi_bat, scd_khuyet_diem, scd_uu_diem, scd_de_xuat_phat_trien, scd_nghe_nghiep` (+ metadata Cockpit CMS: `_id, _by, _created…`) | Chỉ `en`: 10 |
| `sochudao_vi.json` | 10 | Như trên, **không có field `lang`** | (vi theo tên file) |
| `sochudao_hi.json` | 10 | Như trên, **không có field `lang`** | (hi theo tên file) |
| `dinhcao.json` | 100 | `dinh_cao_key, dinh_cao_tom_tat, dinh_cao_rut_gon, dinh_cao_chi_tiet, dinh_cao_active, lang` | `vi`: 12, 8 ngôn ngữ còn lại × 11 |
| `ngaysinh.json` | 304 | `sns_key, sns_content, lang` | 8 ngôn ngữ × 38 mục |

Nhận xét PO: kho nội dung diễn giải (số chủ đạo × ~9 ngôn ngữ, đỉnh cao ~100 mục, ngày sinh 304 mục) là **tài sản lớn nhất của app** — nhưng nó sống trên Firestore, còn bản JSON trong repo đã lệch chuẩn (thiếu `lang`, số mục `vi` của đỉnh cao là 12 so với 11 của ngôn ngữ khác).

### 1.5. Đa ngôn ngữ (i18n)

- Có **10 file** `lib/l10n/intl_*.arb`: `en, fr, hi, id, in, lo, pt, ru, vi, zh` (+ generated `messages_*.dart` tương ứng). Lưu ý `id` và `in` là **trùng** (cùng là tiếng Indonesia, `in` là mã cũ).
- `vi` và `en`: **đầy đủ ngang nhau — 95/95 key**. Hầu hết các ngôn ngữ khác cũng 95 key.
- `intl_lo.arb` (tiếng Lào): chỉ **43/95 key — thiếu 52 key** (toàn bộ nhóm Tết).
- Nhưng runtime chỉ cho chọn **3 ngôn ngữ** (`en, vi, hi` — `lib/class/Lang.dart`). Tức là đã dịch tới ~10 ngôn ngữ mà user chỉ chạm được 3; đồng thời nội dung Firestore cho các ngôn ngữ bị tắt vẫn tồn tại — lãng phí tài sản dịch thuật, hoặc ngược lại: mở thêm ngôn ngữ là "quick win" gần như miễn phí (xem mục 5).
- Chất lượng dịch chưa được kiểm chứng trong code; nhóm key Tết chiếm 55% tổng số key nhưng không còn tính năng tương ứng.

---

## 2. Luồng người dùng end-to-end

```
Mở app (main.dart)
  └─ Firebase init + AdMob init + khôi phục langCur / birh_date_store
Home (home.dart)
  └─ [1] User chạm ô ngày → DatePicker (1900–nay) → lưu birh_date_store
  └─ [2] User chạm "Xem" → _submit()
        ├─ tinh_scd(yyyyMMdd): cộng mọi chữ số, đệ quy rút gọn khi > 11  → số chủ đạo (2–11)
        ├─ TSHClient.getSoChuDao(scd_number, lang) → Firestore collection "sochudao"
        └─ Gắn thêm ngay/thang/nam vào res.data → Navigator.push(DetailPage)
Detail (detail.dart) — 3 tab:
  ├─ Tab 1 "Tổng quan": hiển thị ngay từ res.data (scd_*) — KHÔNG gọi thêm mạng
  ├─ Tab 2 "Mốc cuộc đời": loaded() rút gọn ngày/tháng/năm (ngưỡng > 9)
  │     → dinh_1 = ngày+tháng, dinh_2 = tháng+năm, dinh_3 = scd(dinh_1+dinh_2), dinh_4 = ngày+năm
  │     → 4 lần getDinhCao() → Firestore collection "dinhcao" (where dinh_cao_key + lang)
  │     → tuổi các mốc: 36 − scd, +9, +9, +9
  └─ Tab 3 "Biểu đồ ngày sinh": getNgaySinh(ngay+thang+nam, lang)
        → gom các chữ số 1–9 thành chuỗi lặp ("11", "22"...) → Firestore collection "ngaysinh"
          (where sns_key whereIn [danh sách chuỗi] + lang)
        → lưới 3×3 + card sns_content cho từng số có mặt
Setting: icon góc phải Home → bottom sheet đổi ngôn ngữ (en/vi/hi) → S.load + lưu langCur
```

### Những chỉ số thần số học app THỰC SỰ tính được

1. **Số chủ đạo (Life Path)** — từ ngày sinh đầy đủ.
2. **4 số Đỉnh cao (Pinnacles)** + mốc tuổi tương ứng.
3. **Biểu đồ ngày sinh (Birth Chart)** dạng tần suất số 1–9 + diễn giải từng số.

### Những chỉ số phổ biến mà app KHÔNG có (đã kiểm chứng toàn bộ `lib/`)

- ❌ **Không nhập họ tên ở bất kỳ đâu** — do đó không có: Số Linh hồn, Số Nhân cách, Số Sứ mệnh/Đường đời theo tên, Số Thái độ, chỉ số nợ nghiệp theo tên… Trớ trêu là văn bản giới thiệu trong `intro.dart` / key `introl_1` lại tuyên bố app "dựa trên **tên và ngày sinh**" — hứa một đằng, làm một nẻo.
- ❌ Không có **Năm cá nhân / Tháng cá nhân / Ngày cá nhân** (Personal Year/Month/Day) trong luồng chính. Trang `hangngay.dart` có gọi API `get_today` theo *năm sinh* nhưng trang này mồ côi (mục 1.3) và logic của nó cũng không phải công thức năm cá nhân chuẩn.
- ❌ Không có tương hợp, không có lưu lịch sử, không có chia sẻ, không có tài khoản/đăng nhập (Firebase Auth không được dùng dù Firebase đã init).

### Nguồn dữ liệu — kết luận dứt khoát

| Nguồn | Vai trò thực tế |
|---|---|
| **Cloud Firestore** (project `thansohoc-1`, `lib/firebase_options.dart`) | ✅ **Nguồn runtime duy nhất** cho cả 3 loại nội dung: collections `sochudao`, `dinhcao`, `ngaysinh` — qua `TSHClient` (`lib/network/tsh_client.dart:56-133`) |
| Local JSON `assets/data/` | ❌ Không dùng ở runtime; chỉ là bản seed cũ (đoạn seed nằm chết trong FAB comment ở `main.dart`) |
| API `http://app.gulagi.com/api/` (Cockpit CMS, Dio trong `tsh_client.dart:17-27`) | ❌ **Code chết**: mọi lời gọi Dio đều nằm *sau* câu `return` (ví dụ `home.dart:200` `return;` rồi mới `dio.post` ở `:201`; `detail.dart` `get4()`/`get_so_ngay_sinh()` return trước đoạn post) — không bao giờ thực thi |
| API `http://apitwo.gulagi.com/` (`tsh_client2.dart`) | ❌ Tương tự — chỉ còn được tham chiếu trong đoạn chết của `get_so_ngay_sinh()` |
| API `https://edu.gulagi.com/admin/api/.../get_today/` (`hangngay.dart:107-115`, dùng `package:http`) | ⚠️ Chỉ tồn tại trong trang mồ côi `HangNgayPage` — coi như chết cùng trang |

Hệ quả PO cần biết: **app phụ thuộc 100% vào Firestore + kết nối mạng**. Không có cache offline, không có fallback về JSON local dù JSON đã nằm sẵn trong máy — mất mạng là mất toàn bộ nội dung.

---

## 3. Vấn đề phát hiện (bugs / risks — trích file:line)

### 3.1. Bảo mật — secret/API key lộ cứng trong code nguồn

| # | Vị trí | Vấn đề |
|---|---|---|
| S1 | `lib/network/tsh_client.dart:20` | `Cockpit-Token` (token API của CMS gulagi) hardcode trong header Dio. Dù endpoint này đang là code chết, token vẫn nằm trong git history + trong binary |
| S2 | `lib/Pages/hangngay/hangngay.dart:111` | Header `X-Api-Key` hardcode cho `edu.gulagi.com` |
| S3 | `android/app/src/main/AndroidManifest.xml` | Facebook `ApplicationId` + **`ClientToken`** khai thẳng trong manifest; AdMob `APPLICATION_ID` (publisher thật `ca-app-pub-8539908368627646~…`) cũng ở đây. ClientToken lộ trong APK là rủi ro bị lạm dụng app identity |
| S4 | `lib/firebase_options.dart` + `android/app/google-services.json` | Firebase API keys/appId của project `thansohoc-1` nằm trong repo (đây là dạng key client — rủi ro thấp hơn S1/S2 — nhưng bắt buộc phải khóa bằng Firestore Security Rules + API restrictions; trong repo **không thấy** file rules nào để kiểm chứng) |
| S5 | `lib/provider/admob/admob_service.dart:18,26,34` | AdMob ad unit **thật** (cùng publisher `…8539908368627646`: banner `/4176119972`, rewarded `/6003125396`, interstitial `/9674777099`) — có phân biệt test ID khi `kDebugMode` (điểm tốt hiếm hoi), nhưng iOS luôn trả về **test ID** kể cả release → nếu phát hành iOS bằng code này, iOS không có doanh thu thật |

### 3.2. Nền tảng / dependencies quá cũ — rủi ro bị store từ chối & không build nổi với toolchain mới

| # | Vị trí | Vấn đề |
|---|---|---|
| T1 | `pubspec.yaml:22` | Dart SDK constraint `>=2.16.0 <3.0.0` — thời tiền Dart 3 (2022). Mọi nâng cấp Flutter hiện đại đều phải phá constraint này trước |
| T2 | `pubspec.yaml` (toàn file) | Hàng loạt dependency **không ghim version**: `flutter_datetime_picker_plus`, `intl`, `flutter_html`, `flutter_easyloading`, `html`… → build không tái lập được. Các version đã ghim thì rất cũ: `google_mobile_ads: ^1.2.0`, `dio: ^4.0.6`, `google_fonts: ^3.0.1`, `shared_preferences: ^2.0.17`, `firebase_core: ^2.22.0` |
| T3 | `pubspec.yaml` vs code | `package:http` được import ở `diengiai_tab3.dart`, `tab4.dart`, `hangngay.dart` nhưng **không khai báo** trong `pubspec.yaml` (chỉ tồn tại dạng transitive qua package khác) — vi phạm nguyên tắc khai báo, dễ vỡ khi nâng cấp |
| T4 | `pubspec.yaml` | Dependency khai nhưng không dùng: `firebase_database` (chỉ Firestore được dùng), `confetti`, `card_swiper`, `google_fonts` — phình APK, tăng bề mặt rủi ro |
| T5 | `android/build.gradle` | AGP `7.1.2`, Kotlin `1.6.10`, `google-services: 4.3.10` — đều đã cũ nhiều thế hệ |
| T6 | `android/app/build.gradle` | `compileSdkVersion 33` trong khi `targetSdkVersion 34`; release build **ký bằng debug key** (`signingConfig signingConfigs.debug`) — không thể phát hành nghiêm túc bằng cấu hình này; `versionCode 19`/`versionName "1.1.6"` hardcode lệch với `pubspec.yaml` (`1.1.6+18`) |
| T7 | `android/app/build.gradle` (dependencies) | `com.facebook.android:facebook-android-sdk:latest.release` — **version động nguy hiểm nhất**: mỗi lần build có thể kéo bản khác nhau, có thể vỡ build bất cứ lúc nào; và Facebook SDK được nhúng + khai manifest nhưng **không có dòng code Dart nào dùng tới** |
| T8 | `AndroidManifest.xml` | Xin quyền `WRITE_EXTERNAL_STORAGE` (quyền nhạy cảm, không tính năng nào trong code cần ghi bộ nhớ ngoài — share/lưu ảnh đã bị gỡ); không khai `usesCleartextTraffic` trong khi 2 base URL là `http://` (`tsh_client.dart:18`, `tsh_client2.dart:10`) → trên Android 9+ các API HTTP này sẽ bị chặn mặc định (may là chúng đang là code chết) |

### 3.3. Bugs logic & xử lý lỗi

| # | Vị trí | Vấn đề |
|---|---|---|
| B1 | `home.dart:28-38`, `detail.dart:29-40` | **Sai thần số học với số master**: `tinh_scd` rút gọn mọi tổng `> 11` → ngày sinh cho tổng 22 hoặc 33 sẽ mất số master 22/33, trong khi trường phái phổ biến ở VN giữ 11/22 (và nhiều nơi giữ cả 33). Ngược lại `tinh_dinh_cao_1` (ngưỡng `> 9`) lại gọi đệ quy nhầm vào `tinh_scd` (ngưỡng 11) ở `detail.dart:44-53` → đỉnh cao có thể cho ra 10/11 bất nhất với kỳ vọng 1–9 |
| B2 | `detail.dart:185-190` | **Crash khi Firestore trả rỗng**: `build()` gọi thẳng `parse(data['scd_muc_dich'])`… trên các field có thể `null` nếu thiếu bản ghi theo `lang` (rất dễ xảy ra: user chọn Hindi nhưng dữ liệu `sochudao` cho `hi` trong file seed lại thiếu field `lang` để query khớp). `home.dart:188` chỉ chặn `res == null`, mà `getSoChuDao` **không bao giờ trả null** — nó trả `Res` với `data = {}` rỗng (`tsh_client.dart:64-68`). Hệ quả: màn hình chi tiết trắng/crash thay vì thông báo "chưa có dữ liệu" |
| B3 | `home.dart:177-199` | **Không có xử lý lỗi mạng**: `_submit()` dùng `.then(...)` không `.catchError`, không timeout. Firestore lỗi/offline → `EasyLoading` quay vô hạn hoặc future treo, user không có đường lui, không có nút thử lại. Tương tự 5 lời gọi Firestore trong `detail.dart:140-171` đều không có nhánh lỗi |
| B4 | `detail.dart:133-160` | Chuỗi async lồng nhau (`loaded().then` → 4 `get4().then` riêng lẻ, mỗi cái một `setState`) — không `mounted` check: user back sớm có thể gây `setState after dispose`. Tab 2 hiển thị chữ `"loadding"` (sai chính tả) trong lúc chờ (`tab2.dart:66-84`) |
| B5 | `components/box_card.dart` | **Nhầm nhãn hiển thị**: `DetailPage` truyền `dinh: tuoi_X.toString()` (là *tuổi*) vào `box_card`, card lại in `dinh + " tuổi"` làm tiêu đề và in riêng `dinh_cao_key` ở dòng dưới — user đọc rất khó phân biệt "đỉnh cao số mấy" với "ở tuổi nào" |
| B6 | `tsh_client.dart:104-132` (`getNgaySinh`) | Query Firestore dùng đồng thời `.where('sns_key', whereIn: queryData)` + `.where('lang', …)` — phụ thuộc composite index, và `whereIn` bị giới hạn số phần tử; danh sách `queryData` chứa các chuỗi như `"11"`, `"222"`… nếu ngày sinh thiếu hẳn một số thì số đó không có card nào — **app không hề diễn giải "số vắng mặt"** (một phần quan trọng của biểu đồ ngày sinh). Chuỗi logic gom số này còn bị **copy-paste 3 nơi**: `tsh_client.dart`, `diengiai_tab3.dart:44-84`, `tab4.dart` |
| B7 | `hangngay.dart:49` | `dateCur` mặc định hardcode `DateTime.parse("1996-01-01")`; nút bấm trong trang này ghi chữ `"Setting"` cứng (`:243`) thay vì dùng i18n — bằng chứng trang chưa từng được hoàn thiện |
| B8 | Rải rác | `print()`/`log()` dữ liệu response còn nguyên trong release (`home.dart:191-194`, `box_card.dart`, interceptors log cả header chứa token ở `tsh_client.dart:36-38`); biến toàn cục mutable (`langCur`, `myShared`, `dateCur` dạng `static`) khiến trạng thái khó kiểm soát |

### 3.4. Chất lượng / bảo trì

- **Không có thư mục `test/`** — 0 unit test, 0 widget test, dù `flutter_test` đã khai trong `dev_dependencies`. Mọi thay đổi ở hàm tính số (phần lõi nhất của app!) đều không có lưới an toàn.
- **Code chết quy mô lớn**: toàn bộ tầng Dio/Cockpit (sau `return`), `tab4.dart`, `hangngay.dart`, `intro.dart`, Analytics, tính năng Tết. Ước tính 30–40% codebase là chết — người mới vào dự án rất dễ sửa nhầm vào đường chết.
- Quy ước đặt tên/lint yếu: class `tab1_Page`, `box_card`, `settingPage` không theo Dart convention; field `night` thay vì `nine` trong `ListNumber.dart`; typo `birh_date_store`, `loadding`, `langSteamController` lan khắp nơi; rất nhiều block comment dài giữ code cũ thay vì xóa bằng git.
- Không thấy CI, không thấy file Firestore rules, README mặc định của Flutter chưa được thay bằng tài liệu dự án.

---

## 4. Đánh giá monetization & UX gaps

### 4.1. Monetization hiện tại — gần như bằng 0

| Kênh | Trạng thái thực tế |
|---|---|
| AdMob Banner | Định nghĩa ID + listener, **không gắn vào UI nào** → doanh thu 0 |
| AdMob Interstitial | Có nạp ở Home, **code `.show()` bị comment** → doanh thu 0 |
| AdMob Rewarded | Có ID, **không có code load/show** → doanh thu 0 |
| IAP / Subscription / Paywall | **Không tồn tại**: không dependency IAP nào trong `pubspec.yaml`, không màn hình premium, không entitlement |
| Analytics / đo lường | Bị comment toàn bộ → không biết user rơi ở đâu, không tối ưu được gì |
| Affiliate / dẫn link dịch vụ (xem bói, đặt tên, khóa học…) | Không có |

> Nói thẳng kiểu PO: app hiện tại là một "máy xem miễn phí một lần" — không thu tiền, không thu dữ liệu hành vi, không giữ chân. Mọi chi phí Firestore/maintain đều là chi phí chìm cho tới khi sửa mục này.

### 4.2. UX gaps

1. **Không có tên** — trải nghiệm thiếu cá nhân hóa ngay từ input; kết quả của mọi người có cùng ngày sinh là **giống hệt nhau 100%**, user cảm nhận ngay "app nông".
2. **One-shot, không retention loop**: xem xong 3 tab là hết lý do quay lại. Không có nội dung theo ngày (trang hằng ngày thì mồ côi), không thông báo, không widget, không streak/lịch sử.
3. **Không chia sẻ được**: `share_plus`, `screenshot` đều bị comment trong `pubspec.yaml` — mất trắng kênh viral tự nhiên nhất của dòng app tâm linh/giải trí (khoe kết quả lên Facebook/TikTok/Zalo).
4. **Không lưu nhiều người**: chỉ 1 `birh_date_store` duy nhất; muốn xem cho người yêu/bố mẹ/con là phải nhập lại và ghi đè lẫn nhau — trong khi hành vi xem hộ là hành vi cốt lõi của thị trường VN.
5. **Trạng thái lỗi/rỗng không tồn tại**: lỗi mạng = quay vòng; thiếu dữ liệu theo ngôn ngữ = nguy cơ crash (B2); loading tab 2 là chữ "loadding".
6. **Nội dung tĩnh, trình bày thô**: tab 3 chỉ là bảng 3×3 + đoạn văn; không có trực quan hóa (mũi tên sức mạnh, mặt phẳng, số thiếu), không có tóm tắt "điểm nổi bật của bạn" dạng card dễ chụp màn hình.
7. **Theme Tết quanh năm**: background/logo lấy từ `assets/tet/` — ngoài mùa Tết giao diện mang cảm giác "app mùa vụ hết hạn".
8. **Thiếu tin cậy**: không có trang giới thiệu/phương pháp luận tới được user (`intro.dart` mồ côi), không disclaimer "chỉ mang tính tham khảo/giải trí", không chính sách riêng tư trong app — rủi ro khi lên store và khi chạy ads.

---

## 5. Đề xuất tính năng mới (ưu tiên theo Impact / Effort)

> Quy ước effort: **S** ≤ 1 tuần, **M** = 2–4 tuần, **L** > 1 tháng. Ưu tiên: **P0** = làm ngay trong giai đoạn 1, **P1** = giai đoạn 2, **P2** = giai đoạn 3 / khi đã có dữ liệu.

| # | Tính năng | Giá trị cho user / business | Effort | Ưu tiên |
|---|---|---|---|---|
| 1 | **Nhập họ tên đầy đủ → bộ chỉ số theo tên** (Số Sứ mệnh, Linh hồn, Nhân cách, Thái độ) + giữ số master 11/22/33 đúng chuẩn | Sửa lời hứa sai hiện tại ("dựa trên tên và ngày sinh"), kết quả trở nên *của riêng từng người* thay vì trùng lặp theo ngày sinh; đây là nội dung người dùng VN tìm kiếm nhiều nhất khi nói "thần số học" | M (thuật toán chữ→số Pythagoras thuần local; cần biên soạn nội dung diễn giải cho các số theo tên — có thể tái dùng khung nội dung số chủ đạo) | **P0** |
| 2 | **Năm / Tháng / Ngày cá nhân + "Năng lượng hôm nay"** (Personal Year/Month/Day) ngay trên Home, hồi sinh ý tưởng `hangngay.dart` bằng công thức local thay vì API chết | Tạo **lý do mở app mỗi ngày** — retention loop đầu tiên và rẻ nhất; nội dung diễn giải 9 số × chu kỳ có thể tái dùng | S–M (công thức local đơn giản; diễn giải năm cá nhân cần viết mới 9×3 mục) | **P0** |
| 3 | **Chia sẻ kết quả dạng ảnh / story 9:16** (card số chủ đạo + biểu đồ ngày sinh, có watermark tên app) — bật lại `share_plus` + `screenshot` | Kênh tăng trưởng organic gần như miễn phí, đúng hành vi khoe kết quả lên Facebook/TikTok/Zalo của user VN; mỗi ảnh share là một quảng cáo | S | **P0** |
| 4 | **Lưu nhiều hồ sơ** (bản thân, người yêu, bố mẹ, con cái) — danh sách hồ sơ tên + ngày sinh, chuyển đổi 1 chạm, thay cho `birh_date_store` đơn lẻ | Đúng hành vi "xem hộ" của thị trường VN; tăng số phiên xem/user; là nền tảng bắt buộc cho tính năng tương hợp (#5) và paywall gia đình (#7) | S (mở rộng SharedPreferences/local DB, không cần backend) | **P0** |
| 5 | **Tương hợp cặp đôi** (so sánh số chủ đạo + biểu đồ ngày sinh của 2 hồ sơ: điểm hợp, điểm xung, lời khuyên) | Tính năng có tính viral và willingness-to-pay cao nhất trong dòng app này ở VN (xem cho cặp đôi/bạn đời/đối tác làm ăn); nội dung là tổ hợp từ dữ liệu đã có | M (cần biên soạn ma trận tương hợp 11×11 rút gọn theo nhóm + UI so sánh) | **P1** |
| 6 | **Paywall Premium**: bỏ quảng cáo + mở khóa diễn giải sâu (đỉnh cao chi tiết `dinh_cao_chi_tiet` đã có sẵn trong dữ liệu mà UI chưa dùng, tương hợp đầy đủ, báo cáo PDF) + **bật lại AdMob đúng nghĩa** cho bản free (banner ở Detail, interstitial có tần suất hợp lý, rewarded để mở khóa tạm 1 mục) | Biến app từ chi phí chìm thành có doanh thu hai tầng: ads cho số đông, subscription/one-time cho số ít chịu chi — đúng benchmark app-store VN (subscription là mô hình số 1) | M (IAP + entitlement local/server verify + khôi phục mua hàng; phần ads là S vì ID đã sẵn) | **P1** |
| 7 | **Thông báo nhắc + Home widget "Năng lượng hôm nay"** (số ngày cá nhân, 1 câu diễn giải ngắn, nhắc 7–8h sáng) | Đưa nội dung #2 ra ngoài màn hình khóa — đòn bẩy D1/D7 retention mạnh nhất cho app nội dung hằng ngày; kết hợp streak "xem năng lượng mỗi ngày" | M (local notifications + widget Android; iOS widget tốn thêm) | **P1** |
| 8 | **Nâng cấp Biểu đồ ngày sinh thành sản phẩm hoàn chỉnh**: diễn giải số vắng mặt, mũi tên sức mạnh/khuyết điểm, 3 mặt phẳng (thể chất–tinh thần–trí tuệ), trình bày trực quan thay bảng 3×3 thô | Tab 3 hiện là phần "có mà như không"; bản nâng cấp là nội dung chuyên sâu rất được cộng đồng thần số học VN (theo trường phái Pythagoras phổ biến) coi trọng — và là ứng viên nội dung Premium tốt | M (logic suy luận từ lưới 3×3 là local; cần biên soạn nội dung mũi tên/mặt phẳng) | **P1** |
| 9 | **AI diễn giải cá nhân hóa**: gửi tổ hợp chỉ số (chủ đạo + tên + đỉnh cao + năm cá nhân) cho LLM để sinh bản diễn giải mạch lạc, giọng văn riêng, kèm Q&A "hỏi về lá số của bạn" | Tăng chiều sâu vượt trần nội dung tĩnh viết sẵn; tạo khác biệt với hàng chục app/web thần số học copy nhau; gói AI là tầng Premium thuyết phục nhất | L (cần backend proxy để giữ API key — tuyệt đối không lặp lại lỗi hardcode key ở S1/S2 — + kiểm duyệt nội dung + chi phí token theo lượt) | **P2** |
| 10 | **Đặt tên em bé / chọn tên theo thần số học**: nhập họ + danh sách tên dự kiến (hoặc ngày dự sinh) → chấm điểm tên theo số sứ mệnh/linh hồn, gợi ý tên hợp số chủ đạo của bé | Phân khúc cha mẹ VN chi tiêu mạnh và tìm kiếm theo mùa sinh; nối tự nhiên với tệp user nữ 25–40 của app; có thể bán dạng báo cáo một lần | M–L (cần cơ sở dữ liệu tên tiếng Việt + thuật toán chấm điểm; tái dùng engine chữ→số của #1) | **P2** |
| 11 | **Mở khóa các ngôn ngữ đã dịch sẵn** (fr, pt, ru, zh, id — dữ liệu + arb đã có) sau khi rà soát chất lượng dịch & bổ sung dữ liệu Firestore tương ứng | Gần như "tính năng miễn phí": tài sản đã trả tiền dịch đang bị khóa sau `listLang`; mở ra là mở thêm thị trường (đặc biệt id/pt) mà không cần viết tính năng mới | S (bật `listLang` + QA dữ liệu từng ngôn ngữ; `lo` cần dịch bổ sung 52 key Tết hoặc cắt nhóm key đó) | **P2** |

**Loại khỏi danh sách (cân nhắc nhưng không đề xuất):** gamification gieo quẻ/Tết (đã từng có và bị gỡ — tính mùa vụ, không phải lõi), cộng đồng/forum trong app (chi phí kiểm duyệt lớn, không hợp quy mô hiện tại), bản web (Firestore + logic local cho phép làm sau, nhưng ưu tiên thấp hơn retention trên mobile).

---

## 6. Roadmap đề xuất — 3 giai đoạn

### Giai đoạn 1 — "Sửa nền & tạo vòng quay lại" (tháng 1)
- **Dọn nền kỹ thuật (điều kiện tiên quyết):** nâng Dart/Flutter + dependencies lên bản được hỗ trợ, ghim version, gỡ Facebook SDK `latest.release` và các dependency chết, bỏ ký release bằng debug key, xóa code chết (tầng gulagi Dio, tab4, analytics comment), **thu hồi & thay thế các token đã lộ** (S1, S2, S3), thêm Firestore Security Rules, bổ sung unit test cho hàm tính số (kèm sửa bug master number 22/33 — B1) và xử lý lỗi/rỗng (B2, B3).
- **Ship:** tính năng #1 (chỉ số theo tên), #2 (năm/tháng/ngày cá nhân trên Home), #4 (đa hồ sơ), #3 (chia sẻ ảnh).
- **Đo lường:** bật lại Firebase Analytics + gắn event cho funnel *nhập ngày sinh → xem kết quả → share*.
- 🎯 Mục tiêu: app đúng lời hứa, không crash vì thiếu dữ liệu, có analytics, có lý do quay lại mỗi ngày.

### Giai đoạn 2 — "Kiếm tiền & giữ chân" (tháng 2–3)
- **Ship:** #5 (tương hợp cặp đôi), #8 (biểu đồ ngày sinh nâng cấp), #7 (thông báo + widget "năng lượng hôm nay").
- **Monetization:** bật AdMob thật cho bản free (banner + interstitial có cap tần suất + rewarded mở khóa), ra mắt **Premium** (#6): bỏ ads + diễn giải sâu + tương hợp đầy đủ; A/B test giá theo chuẩn thị trường VN (gói tháng thấp, gói năm làm anchor, có trial).
- 🎯 Mục tiêu: có doanh thu thật đầu tiên, D7 retention cải thiện nhờ widget/thông báo + nội dung hằng ngày.

### Giai đoạn 3 — "Khác biệt hóa & mở rộng" (tháng 4–6)
- **Ship:** #9 (AI diễn giải cá nhân hóa — tầng Premium cao nhất, backend proxy giữ key), #10 (đặt tên em bé — báo cáo trả phí một lần), #11 (mở thêm ngôn ngữ đã dịch sẵn để test thị trường quốc tế).
- **Tối ưu:** dựa trên dữ liệu Analytics giai đoạn 1–2 để quyết định đào sâu phân khúc nào (cặp đôi / cha mẹ / sự nghiệp), cân nhắc bản web SEO bắt traffic tìm kiếm "số chủ đạo", "năm cá nhân" tiếng Việt.
- 🎯 Mục tiêu: chuyển từ "app xem bói số" thành sản phẩm có tầng giá trị AI + phân khúc ngách trả phí rõ ràng.

---

## Phụ lục — Bằng chứng nhanh để dev đối chiếu

- Luồng runtime duy nhất: `main.dart` → `home.dart:_submit()` → `TSHClient.getSoChuDao/getDinhCao/getNgaySinh` (Firestore) → `detail.dart` 3 tab.
- Không tồn tại: thư mục `test/`, file Firestore rules, dependency IAP, code load/show Banner/Rewarded Ad, route tới `HangNgayPage`/`introPage`/`Tab4Page`, input họ tên ở bất kỳ màn hình nào.
- Version hiện tại: `pubspec.yaml` ghi `1.1.6+18`, `android/app/build.gradle` ghi `versionCode 19 / versionName "1.1.6"` — đã lệch nhau, cần đồng bộ khi phát hành lại.
