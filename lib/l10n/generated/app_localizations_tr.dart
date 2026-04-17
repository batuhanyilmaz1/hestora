// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Hestora CRM';

  @override
  String get homeTitle => 'Ana sayfa';

  @override
  String get homeSubtitle => 'Emlak CRM temel uygulaması hazır.';

  @override
  String get buildEnvironmentTitle => 'Ortam';

  @override
  String get flavorDevelopment => 'Geliştirme';

  @override
  String get flavorProduction => 'Üretim';

  @override
  String get supabaseSectionTitle => 'Supabase';

  @override
  String get supabaseStatusConnected => 'Supabase: bağlı';

  @override
  String get supabaseStatusNotConfigured =>
      'Supabase: yapılandırılmadı (.env içindeki değerleri ayarlayın)';

  @override
  String get languageEnglish => 'İngilizce';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageArabic => 'Arapça';

  @override
  String get languageSystem => 'Sistem varsayılanı';

  @override
  String get languageSectionTitle => 'Dil';

  @override
  String get demoSectionTitle => 'Demo';

  @override
  String get demoSectionSubtitle => 'Yeniden kullanılabilir alan';

  @override
  String get demoSearchLabel => 'Ara';

  @override
  String get demoSearchHint => 'RTL için Arapça seçin…';

  @override
  String get navHome => 'Ana sayfa';

  @override
  String get navCustomers => 'Müşteriler';

  @override
  String get navProperties => 'Emlaklar';

  @override
  String get navProfile => 'Profil';

  @override
  String get splashLoading => 'Yükleniyor…';

  @override
  String get onboardingNext => 'İleri';

  @override
  String get onboardingSkip => 'Atla';

  @override
  String get onboardingStart => 'Başla';

  @override
  String get navTasks => 'Görevler';

  @override
  String get tasksTitle => 'Görevler';

  @override
  String get tasksSubtitle => 'Takip ve iç işler';

  @override
  String get tasksEmpty => 'Henüz görev yok';

  @override
  String get taskNewTitle => 'Yeni görev';

  @override
  String get taskFieldTitle => 'Başlık';

  @override
  String get taskFieldDue => 'Bitiş tarihi (isteğe bağlı)';

  @override
  String get taskLinkedCustomer => 'Müşteri (isteğe bağlı)';

  @override
  String get taskLinkedProperty => 'İlan (isteğe bağlı)';

  @override
  String get taskNoneSelected => 'Yok';

  @override
  String get taskMarkDone => 'Tamamla';

  @override
  String get taskMarkedDone => 'Görev tamamlandı';

  @override
  String get aiExtractWithOpenAi => 'OpenAI ile çıkar';

  @override
  String get aiExtractNeedInput => 'Önce görsel seçin veya metin yapıştırın.';

  @override
  String get aiExtractNoApiKey =>
      'OPENAI_API_KEY tanımlı değil. .env dosyasına ekleyin.';

  @override
  String get aiExtractFailed => 'AI çıkarma başarısız';

  @override
  String get listingImportTitle => 'Linkten içe aktar';

  @override
  String get listingUrlLabel => 'İlan bağlantısı';

  @override
  String get listingImportHint => 'Herkese açık ilan bağlantısını yapıştır';

  @override
  String get listingImportAction => 'Önizleme getir';

  @override
  String get onboardingSlide1Title => 'Müşterileri tek yerden yönet';

  @override
  String get onboardingSlide1Body =>
      'Adayları, notları, bütçeyi ve tercihleri bağlamı kaybetmeden takip et.';

  @override
  String get onboardingSlide2Title => 'Düzenli ilan portföyü';

  @override
  String get onboardingSlide2Body =>
      'Satılık ve kiralık portföyünü arama ve filtrelerle yapılandır.';

  @override
  String get onboardingSlide3Title => 'Görev ve hatırlatıcılar';

  @override
  String get onboardingSlide3Body =>
      'Takipte kal. İşleri kişi ve ilanlarla ilişkilendir.';

  @override
  String get welcomeShort => 'Hoş geldin';

  @override
  String get dashboardHeadline => 'Hestora\'ya başlayalım';

  @override
  String get heroCardTitle => 'Her şey tek yerden yönetilsin';

  @override
  String get heroCardBody =>
      'Müşterilerini, portföylerini ve günlük işlerini tek uygulamada yönetmeye başlayabilirsin.';

  @override
  String get ctaAddFirstCustomer => 'İlk müşterini ekle';

  @override
  String get ctaAddListing => 'İlan ekle';

  @override
  String get ctaReminder => 'Hatırlatıcı';

  @override
  String get fabTip =>
      'İşlemleri ortadaki + butonuyla hızlıca başlatabilirsin.';

  @override
  String get customersTitle => 'Müşteriler';

  @override
  String customersSubtitle(int count) {
    return '$count müşteri kayıtlı';
  }

  @override
  String get propertiesTitle => 'Emlaklar';

  @override
  String propertiesSubtitle(int count) {
    return '$count müşteri kayıtlı';
  }

  @override
  String get searchCustomersHint => 'Müşteri ara (isim, telefon, not)';

  @override
  String customersMatchesCount(int count) {
    return '$count eşleşme';
  }

  @override
  String get chipBuyer => 'Alıcı';

  @override
  String get chipTenant => 'Kiracı';

  @override
  String get chipSeller => 'Satıcı';

  @override
  String get chipLandlord => 'Ev sahibi';

  @override
  String get customersFilterTooltip => 'Sıralama';

  @override
  String get customersSortTitle => 'Sıralama';

  @override
  String get customersSortNameAsc => 'İsim (A–Z)';

  @override
  String get customersSortNameDesc => 'İsim (Z–A)';

  @override
  String get customersFilteredEmpty => 'Bu filtre veya arama için sonuç yok.';

  @override
  String get customersFilteredEmptyClear => 'Sıfırla';

  @override
  String get searchListingsHint => 'İlan ara (lokasyon, fiyat, tip)';

  @override
  String get chipAll => 'Tümü';

  @override
  String get chipSale => 'Satılık';

  @override
  String get chipRent => 'Kiralık';

  @override
  String get chipActive => 'Aktif';

  @override
  String get chipPassive => 'Pasif';

  @override
  String get ctaAddFirstListing => 'İlk ilanını ekle';

  @override
  String get emptyCustomersTitle => 'Henüz müşteri yok';

  @override
  String get emptyCustomersBody =>
      'Müşteri ekleyerek listeyi burada görüntüle.';

  @override
  String get emptyPropertiesTitle => 'Henüz ilan yok';

  @override
  String get emptyPropertiesBody => 'Portföyünü oluşturmak için ilan ekle.';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileRoleConsultant => 'Gayrimenkul Danışmanı';

  @override
  String profileStatsLine(int listingCount, int customerCount) {
    return '$listingCount ilan • $customerCount müşteri';
  }

  @override
  String get profileStatActiveListings => 'Aktif ilan';

  @override
  String get profileStatTotalCustomers => 'Toplam müşteri';

  @override
  String get profileStatOpenTasks => 'Açık görev';

  @override
  String get profileMenuAccount => 'Hesap bilgileri';

  @override
  String get accountSettingsTitle => 'Hesap ayarları';

  @override
  String get accountProfileEditorTitle => 'Profil ve e-posta';

  @override
  String get accountHubProfileTitle => 'Profil ve e-posta';

  @override
  String get accountHubProfileSubtitle => 'İsim, fotoğraf ve e-posta adresi';

  @override
  String get accountHubChangePasswordTitle => 'Şifre değiştir';

  @override
  String get accountHubChangePasswordSubtitle => 'Giriş şifrenizi güncelleyin';

  @override
  String get accountHubChangeEmailTitle => 'E-posta değiştir';

  @override
  String get accountHubChangeEmailSubtitle =>
      'Girişte kullandığınız adresi güncelleyin';

  @override
  String get accountHubIntro => 'Profil, şifre ve e-postanızı yönetin.';

  @override
  String get profileDisplayNameLabel => 'Görünen ad';

  @override
  String get profileMenuNotifications => 'Bildirim ayarları';

  @override
  String get profileMenuAnalytics => 'Analiz & raporlar';

  @override
  String get profileMenuSupport => 'Destek / yardım';

  @override
  String get profileAppVersion => 'Hestora CRM v1.0.0';

  @override
  String get profileAccountSheetTitle => 'Hesap';

  @override
  String get profileMoreMenu => 'Diğer';

  @override
  String get signOut => 'Çıkış yap';

  @override
  String get signOutConfirm => 'Çıkış yapmak istediğine emin misin?';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get loginTitle => 'Giriş yap';

  @override
  String get registerTitle => 'Kayıt ol';

  @override
  String get forgotTitle => 'Şifremi unuttum';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get confirmPasswordLabel => 'Şifre tekrar';

  @override
  String get loginSubmit => 'Giriş yap';

  @override
  String get registerSubmit => 'Kayıt ol';

  @override
  String get forgotSubmit => 'Sıfırlama bağlantısı gönder';

  @override
  String get noAccount => 'Hesabın yok mu? Kayıt ol';

  @override
  String get haveAccount => 'Zaten hesabın var mı? Giriş yap';

  @override
  String get forgotLink => 'Şifremi unuttum';

  @override
  String get authErrorGeneric =>
      'Bir şeyler ters gitti. Bilgilerini kontrol edip tekrar dene.';

  @override
  String get validationRequired => 'Bu alan gerekli';

  @override
  String get validationEmail => 'Geçerli bir e-posta gir';

  @override
  String get validationPasswordLength => 'En az 6 karakter kullan';

  @override
  String get validationPasswordMatch => 'Şifreler eşleşmiyor';

  @override
  String get quickActionsTitle => 'Hızlı işlemler';

  @override
  String get quickAddCustomer => 'Müşteri ekle';

  @override
  String get quickAddProperty => 'İlan ekle';

  @override
  String get quickAddReminder => 'Hatırlatıcı (yakında)';

  @override
  String get quickAiImportCustomer => 'Ekran görüntüsünden müşteri';

  @override
  String get customerCreateMethodTitle => 'Müşteriyi nasıl eklemek istersin?';

  @override
  String get customerCreateOptionManual => 'Manuel';

  @override
  String get customerCreateOptionManualBody =>
      'Klasik formu aç ve müşteri bilgilerini kendin gir.';

  @override
  String get customerCreateOptionAi => 'Yapay zeka desteği ile';

  @override
  String get customerCreateOptionAiBody =>
      'Ekran görüntüsünden isim ve telefonu çıkarıp müşteriyi hızlıca oluştur.';

  @override
  String get demoModeBanner =>
      'Demo: bulut senkronu ve giriş için .env ile Supabase yapılandır.';

  @override
  String get back => 'Geri';

  @override
  String get save => 'Kaydet';

  @override
  String get customerDetailTitle => 'Müşteri';

  @override
  String get propertyDetailTitle => 'İlan';

  @override
  String get fieldName => 'Ad';

  @override
  String get fieldPhone => 'Telefon';

  @override
  String get fieldNotes => 'Notlar';

  @override
  String get createCustomerTitle => 'Yeni müşteri';

  @override
  String get createPropertyTitle => 'Yeni ilan';

  @override
  String get listingTitleLabel => 'Başlık';

  @override
  String get listingTypeLabel => 'İlan tipi';

  @override
  String get listingPriceLabel => 'Fiyat';

  @override
  String get listingLocationLabel => 'Konum';

  @override
  String get listingDescriptionLabel => 'Açıklama';

  @override
  String get comingSoon => 'Çok yakında';

  @override
  String get registerSuccess =>
      'Hesap oluşturuldu. E-posta onayı açıksa gelen kutunu kontrol et.';

  @override
  String get resetEmailSent =>
      'Bu e-posta kayıtlıysa sıfırlama bağlantısı gönderildi.';

  @override
  String get fieldRoomCountShort => 'Oda';

  @override
  String get fieldBathroomCountShort => 'Banyo';

  @override
  String get fieldAreaSqmShort => 'Alan (m²)';

  @override
  String get ogFetchError =>
      'Sayfa meta verisi alınamadı. Başka URL deneyin veya elle doldurun.';

  @override
  String get ogPartialData =>
      'Bazı alanlar boş olabilir — kaydetmeden düzenleyebilirsin.';

  @override
  String get matchesForCustomer => 'Uyumlu ilanlar';

  @override
  String get matchesForProperty => 'Uyumlu müşteriler';

  @override
  String matchScoreLabel(String score) {
    return '$score% uyum';
  }

  @override
  String get matchStrong => 'Güçlü eşleşme';

  @override
  String get syncMatchesToCloud => 'Eşleşmeleri buluta kaydet';

  @override
  String get shareClicksTotal => 'Paylaşım linki tıklamaları (toplam)';

  @override
  String get redirectLinkTitle => 'Takip linki';

  @override
  String get createTrackingLink => 'Takip linki oluştur';

  @override
  String get copyTrackingLink => 'Linki kopyala';

  @override
  String get trackingLinkHelp =>
      'Orijinal ilan URL’sini açar ve toplam tıklamayı artırır. Edge Function’ı Supabase’e deploy edin.';

  @override
  String get shareCardTitle => 'Paylaşım kartı';

  @override
  String get templateStory => 'Hikaye 9:16';

  @override
  String get templateSquare => 'Kare 1:1';

  @override
  String get exportPng => 'PNG dışa aktar';

  @override
  String get shareCardPickTheme => 'Kart teması';

  @override
  String get shareCardAllThemesSample => 'Tüm temalar (örnek önizleme)';

  @override
  String get shareCardMockOverlay => 'Ana önizlemede örnek veri kullan';

  @override
  String shareCardBathroomsShort(int count) {
    return '$count banyo';
  }

  @override
  String shareCardAreaSqmShort(String sqm) {
    return '$sqm m²';
  }

  @override
  String get shareCardTuneListingPhoto => 'Fotoğraf kırılımını ayarla';

  @override
  String get shareCardAdjustPhotoTitle => 'İlan fotoğrafı kırılımı';

  @override
  String get shareCardAdjustPhotoHint =>
      'Kaydırıcılar, cover sığdırmada görünen bölgeyi değiştirir. Hızlı kutular yaygın kırılımlara gider.';

  @override
  String get shareCardAdjustPhotoHorizontal => 'Yatay';

  @override
  String get shareCardAdjustPhotoVertical => 'Dikey';

  @override
  String get shareCardAdjustPhotoPresets => 'Hızlı konumlar';

  @override
  String get shareCardAdjustPhotoReset => 'Sıfırla';

  @override
  String get shareCardAdjustPhotoDone => 'Tamam';

  @override
  String get shareCard => 'Paylaş';

  @override
  String get aiImportTitle => 'Ekran görüntüsünden';

  @override
  String get aiImportSubtitle =>
      'Numaranın yer aldığı WhatsApp veya sohbet ekran görüntüsünü seç. Sistem isim ve telefonu algılayıp müşteriyi yalnızca bu alanlarla oluşturur.';

  @override
  String get aiPickGallery => 'Görsel seç';

  @override
  String get aiSuggestedPhone => 'Algılanan telefon';

  @override
  String get aiOpenForm => 'Müşteri formuna devam';

  @override
  String get aiDetectedNameHint =>
      'İsim bulunamazsa kayıt Bilinmeyen müşteri adıyla açılır.';

  @override
  String get aiCreateCustomer => 'Müşteriyi oluştur';

  @override
  String get aiCreateNeedsPhone =>
      'Telefon numarası algılanamadı. Farklı bir görsel deneyin veya numarayı düzenleyin.';

  @override
  String get aiCustomerCreated => 'Müşteri oluşturuldu.';

  @override
  String get listingUrlOpen => 'Orijinal ilanı aç';

  @override
  String get fieldListingIntent => 'Niyet';

  @override
  String get fieldPreferredLocation => 'Tercih edilen konum';

  @override
  String get fieldBudgetMin => 'Bütçe min';

  @override
  String get fieldBudgetMax => 'Bütçe max';

  @override
  String get fieldRoomCount => 'Oda sayısı';

  @override
  String get fieldAreaMin => 'Min alan (m²)';

  @override
  String get fieldAreaMax => 'Max alan (m²)';

  @override
  String get intentNotSet => 'Seçilmedi';

  @override
  String get loginFooterQuestion => 'Hesabın yok mu?';

  @override
  String get registerFooterQuestion => 'Zaten hesabın var mı?';

  @override
  String get loginWelcomeTitle => 'Tekrar hoş geldin';

  @override
  String get loginWelcomeSubtitle => 'Hesabına giriş yap';

  @override
  String get registerHeadline => 'Hesap oluştur';

  @override
  String get registerSubtitle => 'Premium CRM\'e katıl';

  @override
  String get fieldFullName => 'Ad Soyad';

  @override
  String get forgotHeaderSubtitle => 'Şifre sıfırlama';

  @override
  String get forgotHeroTitle => 'Şifreni sıfırla';

  @override
  String get forgotHeroBody => 'Şifreni sıfırlamak için e-posta adresini gir.';

  @override
  String get forgotEmailLabelCaps => 'E-POSTA ADRESİN';

  @override
  String get forgotRememberedLogin => 'Şifreni hatırladın mı?';

  @override
  String get passwordUpdatedTitle => 'Şifren güncellendi';

  @override
  String get passwordUpdatedBody => 'Artık yeni şifrenle giriş yapabilirsin.';

  @override
  String get passwordUpdatedB1 => 'Şifren başarıyla değiştirildi.';

  @override
  String get passwordUpdatedB2 => 'Diğer cihazlardaki oturumların kapatıldı.';

  @override
  String get passwordUpdatedB3 => 'Hesabın artık daha güvende.';

  @override
  String get goToLogin => 'Girişe git';

  @override
  String get updatePasswordScreenTitle => 'Yeni şifre oluştur';

  @override
  String get updatePasswordScreenSubtitle => 'Şifre yenileme';

  @override
  String get updatePasswordHero => 'Hesabın için yeni şifreni belirle.';

  @override
  String get updatePasswordCta => 'Şifreyi güncelle';

  @override
  String get newPasswordLabel => 'Yeni şifre';

  @override
  String get repeatNewPasswordLabel => 'Yeni şifre tekrar';

  @override
  String get passwordReqTitle => 'Şifre gereksinimleri';

  @override
  String get reqMin8 => 'En az 8 karakter';

  @override
  String get reqOneNumber => 'En az 1 rakam';

  @override
  String get reqOneUpper => 'En az 1 büyük harf';

  @override
  String get strengthStrong => 'Güçlü';

  @override
  String get strengthMedium => 'Orta';

  @override
  String get strengthWeak => 'Zayıf';

  @override
  String get authKvkk => 'Aydınlatma metnini okudum ve kabul ediyorum.';

  @override
  String get authKvkkLink => 'KVKK Aydınlatma Metni';

  @override
  String get authKvkkDialogTitle => 'Aydınlatma metni';

  @override
  String get authKvkkDialogBody =>
      'Kişisel verileriniz 6698 sayılı KVKK kapsamında işlenir. Bu metin özet bilgilendirme amaçlıdır; hukuki metni danışmanınızla tamamlayın.';

  @override
  String get emailLabelCaps => 'E-POSTA';

  @override
  String get passwordLabelCaps => 'ŞİFRE';

  @override
  String get registerPasswordHint => 'En az 8 karakter';

  @override
  String get validationPasswordLength8 => 'En az 8 karakter kullan';

  @override
  String get profileNotificationsTitle => 'Bildirim ayarları';

  @override
  String get profileNotificationsSubtitle =>
      'Hangi güncellemeler için uyarı almak istediğini seç.';

  @override
  String get profileNotifyMatches => 'Eşleşme önerileri';

  @override
  String get profileNotifyMatchesSubtitle =>
      'Yeni uyumlu ilan veya müşteri olduğunda.';

  @override
  String get profileNotifyTasks => 'Görevler ve hatırlatmalar';

  @override
  String get profileNotifyTasksSubtitle =>
      'Bitiş tarihi yaklaşan veya yeni görevler.';

  @override
  String get profileNotifyMarketing => 'Ürün haberleri';

  @override
  String get profileNotifyMarketingSubtitle =>
      'Yeni özellikler ve ipuçları (nadiren).';

  @override
  String get profileAnalyticsTitle => 'Analiz ve raporlar';

  @override
  String get profileAnalyticsSubtitle =>
      'Özet metrikler — detaylı raporlar yakında.';

  @override
  String get profileAnalyticsCustomers => 'Müşteri';

  @override
  String get profileAnalyticsListings => 'İlan';

  @override
  String get profileAnalyticsTasksOpen => 'Açık görev';

  @override
  String get profileAnalyticsShareClicks => 'Takip linki tıklaması';

  @override
  String get profileSupportTitle => 'Destek ve yardım';

  @override
  String get profileSupportSubtitle =>
      'Soruların için iletişim ve sık sorulanlar.';

  @override
  String get profileSupportFaqHeading => 'Sık sorulanlar';

  @override
  String get profileSupportEmailAddress => 'destek@hestora.app';

  @override
  String get profileSupportEmailCta => 'E-posta ile yaz';

  @override
  String get profileSupportEmailSubject => 'Hestora CRM destek';

  @override
  String get profileSupportFaq1Title => 'Takip linki nasıl çalışır?';

  @override
  String get profileSupportFaq1Body =>
      'İlan detayından takip linki oluşturur, paylaşırsın. Tıklanınca orijinal ilan açılır ve toplam tıklama sayacı artar.';

  @override
  String get profileSupportFaq2Title => 'Verilerim nerede saklanıyor?';

  @override
  String get profileSupportFaq2Body =>
      'Supabase üzerinde hesabına bağlı kayıtlar; yalnızca sen ve yetkili servisler erişebilir (RLS ile).';

  @override
  String get listingPhotosSection => 'İlan fotoğrafları';

  @override
  String get listingPhotosHint => 'En fazla 12 görsel. JPEG, PNG veya WebP.';

  @override
  String get addListingPhotos => 'Fotoğraf seç';

  @override
  String get listingGalleryTitle => 'Görseller';

  @override
  String get profileChangePhoto => 'Profil fotoğrafını değiştir';

  @override
  String get profilePhotoUpdated => 'Profil fotoğrafı güncellendi';

  @override
  String get propertyEditTitle => 'İlanı düzenle';

  @override
  String get propertyEditSubtitle => 'Bilgileri güncelle ve kaydet';

  @override
  String get propertySectionBasics => 'Temel bilgiler';

  @override
  String get propertySectionFeatures => 'Özellikler';

  @override
  String get propertySectionMedia => 'Medya ve bağlantı';

  @override
  String get listingExistingPhotos => 'Mevcut fotoğraflar';

  @override
  String get propertyDetailSubtitle => 'Emlak Detayı';

  @override
  String get tabPropertyInfo => 'Bilgiler';

  @override
  String get tabPropertyCustomers => 'Müşteriler';

  @override
  String get tabPropertyActions => 'Aksiyonlar';

  @override
  String get propertyFeaturesTitle => 'Emlak özellikleri';

  @override
  String get featureRoom => 'Oda';

  @override
  String get featureArea => 'Alan';

  @override
  String get featureFloor => 'Kat';

  @override
  String get featureAge => 'Yaş';

  @override
  String get featureParking => 'Otopark';

  @override
  String get featureHeating => 'Isıtma';

  @override
  String get featureUnknown => '—';

  @override
  String get markAsSold => 'Satıldı olarak işaretle';

  @override
  String get customerDetailSubtitle => 'Müşteri Detayı';

  @override
  String get searchCriteriaTitle => 'Arama Kriterleri';

  @override
  String get tabCustomerHistory => 'Geçmiş';

  @override
  String get tabCustomerNotes => 'Notlar';

  @override
  String get tabCustomerMatching => 'Eşleşme';

  @override
  String get activityHistoryTitle => 'Aktivite Geçmişi';

  @override
  String activityRecordsCount(int count) {
    return '$count kayıt';
  }

  @override
  String get customerBadgeBuyer => 'Alıcı';

  @override
  String get customerBadgeSeller => 'Satıcı';

  @override
  String get customerCall => 'Ara';

  @override
  String get customerWhatsapp => 'WhatsApp';

  @override
  String get customerMessage => 'Mesaj';

  @override
  String get localeRegionTitle => 'Dil ve bölge';

  @override
  String get localeRegionSavedTitle => 'Kaydedildi';

  @override
  String get localeRegionSavedBody =>
      'Dil ve bölge ayarlarınız kaydedildi. İstediğiniz zaman profilden değiştirebilirsiniz.';

  @override
  String get localeRegionIntro =>
      'Uygulama dilini ve bölge ayarlarını kontrol edin. İstersen daha sonra değiştirebilirsin.';

  @override
  String get fieldRegionCountry => 'Bölge / Ülke';

  @override
  String get fieldCurrency => 'Para birimi';

  @override
  String get currencyTry => 'TRY — Türk Lirası';

  @override
  String get regionTurkey => 'Türkiye';

  @override
  String get regionSettingHint => 'Bölge ayarı';

  @override
  String get currencySettingHint => 'Para birimi';

  @override
  String get appLanguageHint => 'Uygulama dili';

  @override
  String get editCustomerTitle => 'Müşteriyi düzenle';

  @override
  String get customerNoLastCallInfo => 'Son arama bilgisi yok';

  @override
  String customerLastActivitySummary(String when) {
    return 'Son iletişim: $when';
  }

  @override
  String get customerLastActivityJustNow => 'Az önce';

  @override
  String customerLastActivityMinutesAgo(int count) {
    return '$count dk önce';
  }

  @override
  String customerLastActivityHoursAgo(int count) {
    return '$count saat önce';
  }

  @override
  String customerLastActivityDaysAgo(int count) {
    return '$count gün önce';
  }

  @override
  String get customerUrgentTag => 'Acil';

  @override
  String get criteriaLabelLocation => 'Konum';

  @override
  String get criteriaLabelBudget => 'Bütçe';

  @override
  String get criteriaLabelRooms => 'Oda';

  @override
  String get criteriaLabelArea => 'Alan';

  @override
  String customerAreaAtLeast(String sqm) {
    return '$sqm m² ve üzeri';
  }

  @override
  String get customerQuickAddNote => 'Hızlı not ekle';

  @override
  String get customerViewListingDetail => 'Detay Gör';

  @override
  String get customerSendToClient => 'Müşteriye gönder';

  @override
  String customerStrongMatchesTitle(int threshold) {
    return '$threshold% üzeri eşleşmeler';
  }

  @override
  String customerListingCountBadge(int count) {
    return '$count ilan';
  }

  @override
  String get customerActivityNoteAdded => 'Not eklendi';

  @override
  String get customerActivityRegistration => 'Kayıt';

  @override
  String get customerActivityRegistrationBody => 'Müşteri kartı oluşturuldu.';

  @override
  String get customerActivityTimeUnknown => '—';

  @override
  String get customerNotesEmpty => 'Henüz not yok.';

  @override
  String get customerBadgeTenant => 'Kiracı';

  @override
  String get propertySuitableCustomersTitle => 'Uygun Müşteriler';

  @override
  String propertySuitableCustomerCountBadge(int count) {
    return '$count müşteri';
  }

  @override
  String propertyCustomerSeekingBoth(String location, String rooms) {
    return '$location $rooms arıyor';
  }

  @override
  String propertyCustomerSeekingRoomsOnly(String rooms) {
    return '$rooms arıyor';
  }

  @override
  String propertyCustomerSeekingLocationOnly(String location) {
    return '$location bölgesinde arıyor';
  }

  @override
  String get propertyCustomerSeekingUnknown => 'Tercih bilgisi yok';

  @override
  String get propertyListingSend => 'İlan Gönder';

  @override
  String get propertyQuickActionsTitle => 'Hızlı Aksiyonlar';

  @override
  String get propertyActionSendCustomersTitle => 'Müşteriye Gönder';

  @override
  String get propertyActionSendCustomersSubtitle =>
      'Uygun müşterilere ilanı ilet';

  @override
  String get propertyActionShareTitle => 'Paylaş';

  @override
  String get propertyActionShareSubtitle => 'Link veya görsel olarak paylaş';

  @override
  String get propertyActionEditTitle => 'Düzenle';

  @override
  String get propertyActionEditSubtitle => 'İlan bilgilerini güncelle';

  @override
  String get propertyActionNoteTitle => 'Not / Hatırlatıcı Ekle';

  @override
  String get propertyActionNoteSubtitle =>
      'Bu ilan için not veya görev oluştur';

  @override
  String get propertyActionSyncMatchesTitle => 'Eşleşmeleri buluta kaydet';

  @override
  String get propertyActionSyncMatchesSubtitle =>
      'Müşteri eşleşmelerini senkronize et';

  @override
  String get propertyNoteComingSoon => 'Bu özellik yakında eklenecek.';

  @override
  String get validationUrl => 'Geçerli bir bağlantı gir';

  @override
  String get taskEditTitle => 'Görevi düzenle';

  @override
  String get taskFieldPriority => 'Öncelik';

  @override
  String get taskFieldStatus => 'Durum';

  @override
  String get taskPriorityLow => 'Düşük';

  @override
  String get taskPriorityNormal => 'Normal';

  @override
  String get taskPriorityHigh => 'Yüksek';

  @override
  String get taskPriorityUrgent => 'Acil';

  @override
  String get taskStatusOpen => 'Açık';

  @override
  String get taskStatusDone => 'Tamamlandı';

  @override
  String get taskStatusClosed => 'Kapalı';

  @override
  String get taskClearDueDate => 'Bitiş tarihini temizle';

  @override
  String get taskLoadErrorTitle => 'Görev yüklenemedi';

  @override
  String get taskNotFoundTitle => 'Görev bulunamadı';

  @override
  String get taskNotFoundBody => 'Bu görev bulunamadı veya erişim izniniz yok.';

  @override
  String get taskRetryLoad => 'Tekrar dene';

  @override
  String get taskNoDueDate => 'Bitiş tarihi yok';

  @override
  String get customerActivityTaskLinked => 'Görev bağlandı';

  @override
  String get customerActivityPropertyMatched => 'İlan eşleşti';

  @override
  String get customerActivityPropertyShared => 'İlan paylaşıldı';

  @override
  String get customerActivityEmpty => 'Henüz aktivite kaydı yok.';

  @override
  String get customerNoteInputHint => 'Hızlı bir takip notu ekle';

  @override
  String get customerSummaryNoteTitle => 'Müşteri özeti';

  @override
  String get customerUnknownName => 'Bilinmeyen müşteri';

  @override
  String get customerImportContacts => 'Rehberden aktar';

  @override
  String get customerImportPermissionDenied => 'Rehber izni verilmedi.';

  @override
  String get customerImportNoContacts => 'Cihazda uygun kişi bulunamadı.';

  @override
  String get customerImportUnsupported =>
      'Rehber aktarımı yalnızca desteklenen mobil cihazlarda kullanılabilir.';

  @override
  String get customerImportPickerTitle => 'Kişi seç';

  @override
  String get listingImportFallbackTitle => 'Elle devam et';

  @override
  String get listingImportFallbackBody =>
      'Önizleme verisi boş veya engelli. Formu açıp ilanı elle tamamlayabilirsin.';

  @override
  String get listingImportContinueManual => 'Elle devam et';
}
