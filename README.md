# Hestora

Flutter ve Supabase tabanlı emlak CRM mobil uygulaması. İsteğe bağlı web yönetim paneli ayrı klasörde: `../hestora-admin`.

Sunucu ve veritabanı tarafı sizin ortamınızda hazır; aşağıdaki adımlar yalnızca **bilgisayarda projeyi açıp çalıştırmak** içindir.

---

## Gerekli yazılımlar

- [Flutter](https://docs.flutter.dev/get-started/install) — `pubspec.yaml` içindeki SDK sürümüne uyumlu olmalı.
- Terminalde kontrol: `flutter doctor`

Admin panelini de çalıştıracaksanız ek olarak [Node.js](https://nodejs.org/) (LTS) ve `npm`.

---

## Mobil uygulamayı yerelde çalıştırma

### Yapılandırma: `hestora/.env`

Tüm uygulama ayarları **`hestora` klasöründeki `.env`** dosyasından okunur; dosya `pubspec.yaml` içinde asset olarak tanımlıdır, böylece `flutter run` ve derlenmiş uygulama aynı değerleri kullanır.

Örnek alanlar:

| Anahtar | Açıklama |
|---------|-----------|
| `APP_FLAVOR` | `development` veya `production` |
| `SUPABASE_URL` | Supabase proje URL’si |
| `SUPABASE_ANON_KEY` | Aynı projenin anon (public) API anahtarı |
| `OPENAI_API_KEY` | İlan içe aktarma / OG için (isteğe bağlı, boş bırakılabilir) |

Canlıda kullandığınız proje ile yerel geliştirme **aynı Supabase projesine** bağlanacaksa bu dosyadaki URL ve anon key zaten o projenin değerleri olur; proje değişmediği sürece ek bir “yeniden yapılandırma” gerekmez. (Aynı ortam olacak sorun yok)

### Çalıştırma

```bash
cd hestora
flutter pub get
flutter run
```

Cihaz seçimi:

```bash
flutter devices
flutter run -d <cihaz_id>
```

Örnek:

```bash
flutter run -d windows
flutter run -d chrome
```

Uygulama açıldıktan sonra Supabase’te tanımlı kullanıcı bilgileriyle giriş yapılır.

---

## Admin paneli (`hestora-admin`)

### Yerelde kurulum

`hestora-admin` klasöründe **`.env`** dosyası kullanılır (Vite varsayılanı). **`hestora/.env` ile aynı Supabase projesi** için:

| `hestora-admin/.env` | `hestora/.env` ile aynı değer |
|----------------------|-------------------------------|
| `VITE_SUPABASE_URL` | `SUPABASE_URL` |
| `VITE_SUPABASE_ANON_KEY` | `SUPABASE_ANON_KEY` |

```bash
cd hestora-admin
npm install
npm run dev
```

Tarayıcıda açılan adrese gidin (varsayılan port `vite.config.ts` içinde, örn. 5174). Panele yalnızca veritabanında **admin yetkisi** (`profiles.is_admin`) tanımlı Supabase kullanıcılarıyla girilebilir.

### Vercel’e almak (kısa)

Admin paneli statik bir **Vite** ön yüzüdü; [Vercel](https://vercel.com) üzerinde bu alt klasörü ayrı bir proje olarak yayınlayabilirsiniz:

1. Vercel’de yeni proje → GitHub reponuzu seçin.
2. **Root Directory** olarak `hestora-admin` verin.
3. Build: `npm run build`, çıktı klasörü: **`dist`** (Framework Preset: Vite veya “Other” ile bu komutları girin).
4. **Environment Variables** kısmına `VITE_SUPABASE_URL` ve `VITE_SUPABASE_ANON_KEY` ekleyin (Vite bu değişkenleri derleme sırasında pakete gömer; canlı ortamda da buradan okunur).

Ayrıntılı İngilizce özet: [hestora-admin/README.md](../hestora-admin/README.md).

---

## Kısa notlar

- Android’de rehberden kişi içe aktarmak için uygulamanın istediği **kişi izinleri** verilmelidir.
- `.env` asset olarak paketlendiği için anahtarlar uygulama paketinin içinde de bulunur; depoyu herkese açık tutuyorsanız bu riski bilerek yönetin.
- Ek teknik doküman: [Müşteri notları ve zaman çizelgesi](./docs/customer-notes-and-timeline.md)

## Lisans 

Copyright (c) Hestora 2026 Tüm Hakları Saklıdır.
