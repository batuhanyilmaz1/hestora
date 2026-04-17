// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'هيستورا CRM';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get homeSubtitle =>
      'تطبيق أساسي لإدارة علاقات العملاء في العقارات جاهز.';

  @override
  String get buildEnvironmentTitle => 'البيئة';

  @override
  String get flavorDevelopment => 'تطوير';

  @override
  String get flavorProduction => 'إنتاج';

  @override
  String get supabaseSectionTitle => 'Supabase';

  @override
  String get supabaseStatusConnected => 'Supabase: متصل';

  @override
  String get supabaseStatusNotConfigured =>
      'Supabase: غير مُعد (اضبط القيم في .env)';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageTurkish => 'التركية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageSystem => 'افتراضي النظام';

  @override
  String get languageSectionTitle => 'اللغة';

  @override
  String get demoSectionTitle => 'تجربة';

  @override
  String get demoSectionSubtitle => 'حقل قابل لإعادة الاستخدام';

  @override
  String get demoSearchLabel => 'بحث';

  @override
  String get demoSearchHint => 'جرّب العربية لرؤية RTL…';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navCustomers => 'العملاء';

  @override
  String get navProperties => 'العقارات';

  @override
  String get navProfile => 'الملف';

  @override
  String get splashLoading => 'جارٍ التحميل…';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingStart => 'ابدأ';

  @override
  String get navTasks => 'المهام';

  @override
  String get tasksTitle => 'المهام';

  @override
  String get tasksSubtitle => 'المتابعات والعمل الداخلي';

  @override
  String get tasksEmpty => 'لا توجد مهام بعد';

  @override
  String get taskNewTitle => 'مهمة جديدة';

  @override
  String get taskFieldTitle => 'العنوان';

  @override
  String get taskFieldDue => 'تاريخ الاستحقاق (اختياري)';

  @override
  String get taskLinkedCustomer => 'عميل (اختياري)';

  @override
  String get taskLinkedProperty => 'عقار (اختياري)';

  @override
  String get taskNoneSelected => 'بدون';

  @override
  String get taskMarkDone => 'إكمال';

  @override
  String get taskMarkedDone => 'تم إكمال المهمة';

  @override
  String get aiExtractWithOpenAi => 'استخراج عبر OpenAI';

  @override
  String get aiExtractNeedInput => 'اختر صورة أو الصق نصًا أولًا.';

  @override
  String get aiExtractNoApiKey =>
      'OPENAI_API_KEY غير معرّف. أضفه إلى ملف .env.';

  @override
  String get aiExtractFailed => 'فشل استخراج الذكاء الاصطناعي';

  @override
  String get listingImportTitle => 'استيراد من رابط';

  @override
  String get listingUrlLabel => 'رابط الإعلان';

  @override
  String get listingImportHint => 'الصق رابط إعلان عام';

  @override
  String get listingImportAction => 'جلب المعاينة';

  @override
  String get onboardingSlide1Title => 'إدارة العملاء من مكان واحد';

  @override
  String get onboardingSlide1Body =>
      'تتبع العملاء والملاحظات والميزانيات دون فقدان السياق.';

  @override
  String get onboardingSlide2Title => 'قوائم منظمة';

  @override
  String get onboardingSlide2Body =>
      'نظم عروض البيع والإيجار مع البحث والمرشحات.';

  @override
  String get onboardingSlide3Title => 'مهام وتذكيرات';

  @override
  String get onboardingSlide3Body => 'تابع المهام واربطها بالأشخاص والعقارات.';

  @override
  String get welcomeShort => 'مرحبًا';

  @override
  String get dashboardHeadline => 'لنبدأ مع هيستورا';

  @override
  String get heroCardTitle => 'إدارة كل شيء من مكان واحد';

  @override
  String get heroCardBody =>
      'ابدأ بإدارة العملاء والمحفظة والمهام اليومية في تطبيق واحد.';

  @override
  String get ctaAddFirstCustomer => 'أضف أول عميل';

  @override
  String get ctaAddListing => 'أضف إعلانًا';

  @override
  String get ctaReminder => 'تذكير';

  @override
  String get fabTip => 'يمكنك بدء الإجراءات بسرعة عبر زر + في المنتصف.';

  @override
  String get customersTitle => 'العملاء';

  @override
  String customersSubtitle(int count) {
    return '$count عميل مسجل';
  }

  @override
  String get propertiesTitle => 'العقارات';

  @override
  String propertiesSubtitle(int count) {
    return '$count عميل مسجل';
  }

  @override
  String get searchCustomersHint =>
      'ابحث عن العملاء (الاسم، الهاتف، الملاحظات)';

  @override
  String customersMatchesCount(int count) {
    return '$count تطابقًا';
  }

  @override
  String get chipBuyer => 'مشتري';

  @override
  String get chipTenant => 'مستأجر';

  @override
  String get chipSeller => 'بائع';

  @override
  String get chipLandlord => 'مالك';

  @override
  String get customersFilterTooltip => 'الترتيب';

  @override
  String get customersSortTitle => 'الترتيب';

  @override
  String get customersSortNameAsc => 'الاسم (أ–ي)';

  @override
  String get customersSortNameDesc => 'الاسم (ي–أ)';

  @override
  String get customersFilteredEmpty => 'لا توجد نتائج لهذا التصفية أو البحث.';

  @override
  String get customersFilteredEmptyClear => 'إعادة ضبط';

  @override
  String get searchListingsHint => 'ابحث في الإعلانات (الموقع، السعر، النوع)';

  @override
  String get chipAll => 'الكل';

  @override
  String get chipSale => 'للبيع';

  @override
  String get chipRent => 'للإيجار';

  @override
  String get chipActive => 'نشط';

  @override
  String get chipPassive => 'غير نشط';

  @override
  String get ctaAddFirstListing => 'أضف أول إعلان';

  @override
  String get emptyCustomersTitle => 'لا يوجد عملاء بعد';

  @override
  String get emptyCustomersBody => 'أضف عميلًا لعرضه هنا.';

  @override
  String get emptyPropertiesTitle => 'لا توجد إعلانات بعد';

  @override
  String get emptyPropertiesBody => 'أنشئ إعلانًا لبناء المحفظة.';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profileRoleConsultant => 'مستشار عقاري';

  @override
  String profileStatsLine(int listingCount, int customerCount) {
    return '$listingCount إعلان • $customerCount عميل';
  }

  @override
  String get profileStatActiveListings => 'إعلانات نشطة';

  @override
  String get profileStatTotalCustomers => 'إجمالي العملاء';

  @override
  String get profileStatOpenTasks => 'مهام مفتوحة';

  @override
  String get profileMenuAccount => 'معلومات الحساب';

  @override
  String get accountSettingsTitle => 'إعدادات الحساب';

  @override
  String get accountProfileEditorTitle => 'الملف والبريد';

  @override
  String get accountHubProfileTitle => 'الملف والبريد';

  @override
  String get accountHubProfileSubtitle => 'الاسم والصورة وعنوان البريد';

  @override
  String get accountHubChangePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get accountHubChangePasswordSubtitle => 'تحديث كلمة مرور تسجيل الدخول';

  @override
  String get accountHubChangeEmailTitle => 'تغيير البريد';

  @override
  String get accountHubChangeEmailSubtitle =>
      'تحديث عنوان البريد المستخدم للدخول';

  @override
  String get accountHubIntro => 'إدارة ملفك وكلمة المرور والبريد.';

  @override
  String get profileDisplayNameLabel => 'الاسم المعروض';

  @override
  String get profileMenuNotifications => 'إعدادات الإشعارات';

  @override
  String get profileMenuAnalytics => 'التحليلات والتقارير';

  @override
  String get profileMenuSupport => 'الدعم / المساعدة';

  @override
  String get profileAppVersion => 'Hestora CRM v1.0.0';

  @override
  String get profileAccountSheetTitle => 'الحساب';

  @override
  String get profileMoreMenu => 'المزيد';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get signOutConfirm => 'هل تريد تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get forgotTitle => 'نسيت كلمة المرور';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get loginSubmit => 'تسجيل الدخول';

  @override
  String get registerSubmit => 'إنشاء الحساب';

  @override
  String get forgotSubmit => 'إرسال رابط الاستعادة';

  @override
  String get noAccount => 'لا حساب؟ سجّل';

  @override
  String get haveAccount => 'لديك حساب؟ سجّل الدخول';

  @override
  String get forgotLink => 'نسيت كلمة المرور؟';

  @override
  String get authErrorGeneric => 'حدث خطأ. تحقق من البيانات وحاول مرة أخرى.';

  @override
  String get validationRequired => 'هذا الحقل مطلوب';

  @override
  String get validationEmail => 'أدخل بريدًا صالحًا';

  @override
  String get validationPasswordLength => 'استخدم 6 أحرف على الأقل';

  @override
  String get validationPasswordMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get quickActionsTitle => 'إجراءات سريعة';

  @override
  String get quickAddCustomer => 'إضافة عميل';

  @override
  String get quickAddProperty => 'إضافة إعلان';

  @override
  String get quickAddReminder => 'تذكير (قريبًا)';

  @override
  String get quickAiImportCustomer => 'عميل من لقطة شاشة';

  @override
  String get customerCreateMethodTitle => 'كيف تريد إضافة العميل؟';

  @override
  String get customerCreateOptionManual => 'يدويًا';

  @override
  String get customerCreateOptionManualBody =>
      'افتح النموذج الكلاسيكي وأدخل بيانات العميل بنفسك.';

  @override
  String get customerCreateOptionAi => 'بمساعدة الذكاء الاصطناعي';

  @override
  String get customerCreateOptionAiBody =>
      'اختر لقطة شاشة لاستخراج الاسم ورقم الهاتف وإنشاء العميل بسرعة.';

  @override
  String get demoModeBanner =>
      'وضع تجريبي: اضبط Supabase في .env للمزامنة وتسجيل الدخول.';

  @override
  String get back => 'رجوع';

  @override
  String get save => 'حفظ';

  @override
  String get customerDetailTitle => 'عميل';

  @override
  String get propertyDetailTitle => 'إعلان';

  @override
  String get fieldName => 'الاسم';

  @override
  String get fieldPhone => 'الهاتف';

  @override
  String get fieldNotes => 'ملاحظات';

  @override
  String get createCustomerTitle => 'عميل جديد';

  @override
  String get createPropertyTitle => 'إعلان جديد';

  @override
  String get listingTitleLabel => 'العنوان';

  @override
  String get listingTypeLabel => 'نوع الإعلان';

  @override
  String get listingPriceLabel => 'السعر';

  @override
  String get listingLocationLabel => 'الموقع';

  @override
  String get listingDescriptionLabel => 'الوصف';

  @override
  String get comingSoon => 'قريبًا';

  @override
  String get registerSuccess =>
      'تم إنشاء الحساب. راجع بريدك إذا كان التأكيد مفعّلًا.';

  @override
  String get resetEmailSent => 'إن وُجد البريد، أُرسل رابط الاستعادة.';

  @override
  String get fieldRoomCountShort => 'غرف';

  @override
  String get fieldBathroomCountShort => 'حمامات';

  @override
  String get fieldAreaSqmShort => 'المساحة (م²)';

  @override
  String get ogFetchError =>
      'تعذر جلب بيانات الصفحة. جرّب رابطًا آخر أو املأ يدويًا.';

  @override
  String get ogPartialData =>
      'قد تكون بعض الحقول فارغة — يمكنك التعديل قبل الحفظ.';

  @override
  String get matchesForCustomer => 'إعلانات مطابقة';

  @override
  String get matchesForProperty => 'عملاء مطابقون';

  @override
  String matchScoreLabel(String score) {
    return 'تطابق $score%';
  }

  @override
  String get matchStrong => 'تطابق قوي';

  @override
  String get syncMatchesToCloud => 'حفظ التطابقات في السحابة';

  @override
  String get shareClicksTotal => 'نقرات رابط المشاركة (الإجمالي)';

  @override
  String get redirectLinkTitle => 'رابط التتبع';

  @override
  String get createTrackingLink => 'إنشاء رابط تتبع';

  @override
  String get copyTrackingLink => 'نسخ الرابط';

  @override
  String get trackingLinkHelp =>
      'يفتح رابط الإعلان الأصلي ويزيد عداد النقرات الإجمالي. انشر دالة Edge في Supabase.';

  @override
  String get shareCardTitle => 'بطاقة مشاركة';

  @override
  String get templateStory => 'قصة 9:16';

  @override
  String get templateSquare => 'مربع 1:1';

  @override
  String get exportPng => 'تصدير PNG';

  @override
  String get shareCardPickTheme => 'مظهر البطاقة';

  @override
  String get shareCardAllThemesSample => 'كل القوالب (معاينة تجريبية)';

  @override
  String get shareCardMockOverlay =>
      'استخدم بيانات تجريبية في المعاينة الرئيسية';

  @override
  String shareCardBathroomsShort(int count) {
    return '$count حمام';
  }

  @override
  String shareCardAreaSqmShort(String sqm) {
    return '$sqm م²';
  }

  @override
  String get shareCardTuneListingPhoto => 'ضبط إطار الصورة';

  @override
  String get shareCardAdjustPhotoTitle => 'إطار صورة العقار';

  @override
  String get shareCardAdjustPhotoHint =>
      'تغيّر المنزلقات الجزء الظاهر من الصورة مع وضع التغطية. البلاط السريع ينتقل إلى مواضع شائعة.';

  @override
  String get shareCardAdjustPhotoHorizontal => 'أفقي';

  @override
  String get shareCardAdjustPhotoVertical => 'عمودي';

  @override
  String get shareCardAdjustPhotoPresets => 'مواضع سريعة';

  @override
  String get shareCardAdjustPhotoReset => 'إعادة ضبط';

  @override
  String get shareCardAdjustPhotoDone => 'تم';

  @override
  String get shareCard => 'مشاركة';

  @override
  String get aiImportTitle => 'من لقطة شاشة';

  @override
  String get aiImportSubtitle =>
      'اختر لقطة شاشة من واتساب أو الدردشة تحتوي على بيانات التواصل. سيتم اكتشاف الاسم والهاتف ثم إنشاء العميل بهذه الحقول فقط.';

  @override
  String get aiPickGallery => 'اختيار صورة';

  @override
  String get aiSuggestedPhone => 'هاتف مكتشف';

  @override
  String get aiOpenForm => 'متابعة إلى نموذج العميل';

  @override
  String get aiDetectedNameHint =>
      'إذا لم يُكتشف الاسم فسيُنشأ السجل باسم عميل غير معروف.';

  @override
  String get aiCreateCustomer => 'إنشاء عميل';

  @override
  String get aiCreateNeedsPhone =>
      'لم يتم اكتشاف رقم الهاتف. جرّب لقطة أخرى أو عدّل حقل الهاتف.';

  @override
  String get aiCustomerCreated => 'تم إنشاء العميل.';

  @override
  String get listingUrlOpen => 'فتح الإعلان الأصلي';

  @override
  String get fieldListingIntent => 'النية';

  @override
  String get fieldPreferredLocation => 'الموقع المفضل';

  @override
  String get fieldBudgetMin => 'الميزانية الدنيا';

  @override
  String get fieldBudgetMax => 'الميزانية القصوى';

  @override
  String get fieldRoomCount => 'عدد الغرف';

  @override
  String get fieldAreaMin => 'أدنى مساحة (م²)';

  @override
  String get fieldAreaMax => 'أقصى مساحة (م²)';

  @override
  String get intentNotSet => 'غير محدد';

  @override
  String get loginFooterQuestion => 'ليس لديك حساب؟';

  @override
  String get registerFooterQuestion => 'لديك حساب بالفعل؟';

  @override
  String get loginWelcomeTitle => 'مرحبًا بعودتك';

  @override
  String get loginWelcomeSubtitle => 'سجّل الدخول إلى حسابك';

  @override
  String get registerHeadline => 'إنشاء حساب';

  @override
  String get registerSubtitle => 'انضم إلى CRM المميز';

  @override
  String get fieldFullName => 'الاسم الكامل';

  @override
  String get forgotHeaderSubtitle => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotHeroTitle => 'أعد تعيين كلمة المرور';

  @override
  String get forgotHeroBody => 'أدخل بريدك الإلكتروني لإعادة التعيين.';

  @override
  String get forgotEmailLabelCaps => 'عنوان بريدك';

  @override
  String get forgotRememberedLogin => 'تذكرت كلمة المرور؟';

  @override
  String get passwordUpdatedTitle => 'تم تحديث كلمة المرور';

  @override
  String get passwordUpdatedBody =>
      'يمكنك الآن تسجيل الدخول بكلمة المرور الجديدة.';

  @override
  String get passwordUpdatedB1 => 'تم تغيير كلمة المرور بنجاح.';

  @override
  String get passwordUpdatedB2 => 'أُغلقت الجلسات على الأجهزة الأخرى.';

  @override
  String get passwordUpdatedB3 => 'حسابك أصبح أكثر أمانًا.';

  @override
  String get goToLogin => 'الذهاب لتسجيل الدخول';

  @override
  String get updatePasswordScreenTitle => 'إنشاء كلمة مرور جديدة';

  @override
  String get updatePasswordScreenSubtitle => 'تجديد كلمة المرور';

  @override
  String get updatePasswordHero => 'عيّن كلمة مرور جديدة لحسابك.';

  @override
  String get updatePasswordCta => 'تحديث كلمة المرور';

  @override
  String get newPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get repeatNewPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get passwordReqTitle => 'متطلبات كلمة المرور';

  @override
  String get reqMin8 => '8 أحرف على الأقل';

  @override
  String get reqOneNumber => 'رقم واحد على الأقل';

  @override
  String get reqOneUpper => 'حرف كبير واحد على الأقل';

  @override
  String get strengthStrong => 'قوية';

  @override
  String get strengthMedium => 'متوسطة';

  @override
  String get strengthWeak => 'ضعيفة';

  @override
  String get authKvkk => 'قرأت وأوافق على نص الإخطار.';

  @override
  String get authKvkkLink => 'نص الإخطار KVKK';

  @override
  String get authKvkkDialogTitle => 'نص الإخطار';

  @override
  String get authKvkkDialogBody =>
      'تُعالج بياناتك وفق القوانين المعمول بها. استبدل هذا النص بنسختك القانونية.';

  @override
  String get emailLabelCaps => 'البريد الإلكتروني';

  @override
  String get passwordLabelCaps => 'كلمة المرور';

  @override
  String get registerPasswordHint => '8 أحرف على الأقل';

  @override
  String get validationPasswordLength8 => 'استخدم 8 أحرف على الأقل';

  @override
  String get profileNotificationsTitle => 'إعدادات الإشعارات';

  @override
  String get profileNotificationsSubtitle => 'اختر ما تريد أن يتم إشعارك به.';

  @override
  String get profileNotifyMatches => 'اقتراحات التطابق';

  @override
  String get profileNotifyMatchesSubtitle =>
      'عند ظهور إعلان أو عميل متوافق جديد.';

  @override
  String get profileNotifyTasks => 'المهام والتذكيرات';

  @override
  String get profileNotifyTasksSubtitle => 'المواعيد النهائية والمهام الجديدة.';

  @override
  String get profileNotifyMarketing => 'تحديثات المنتج';

  @override
  String get profileNotifyMarketingSubtitle => 'ميزات جديدة ونصائح (نادرًا).';

  @override
  String get profileAnalyticsTitle => 'التحليلات والتقارير';

  @override
  String get profileAnalyticsSubtitle => 'مقاييس ملخصة — تقارير مفصلة قريبًا.';

  @override
  String get profileAnalyticsCustomers => 'العملاء';

  @override
  String get profileAnalyticsListings => 'الإعلانات';

  @override
  String get profileAnalyticsTasksOpen => 'مهام مفتوحة';

  @override
  String get profileAnalyticsShareClicks => 'نقرات رابط التتبع';

  @override
  String get profileSupportTitle => 'الدعم والمساعدة';

  @override
  String get profileSupportSubtitle => 'التواصل والأسئلة الشائعة.';

  @override
  String get profileSupportFaqHeading => 'الأسئلة الشائعة';

  @override
  String get profileSupportEmailAddress => 'support@hestora.app';

  @override
  String get profileSupportEmailCta => 'راسلنا بالبريد';

  @override
  String get profileSupportEmailSubject => 'دعم Hestora CRM';

  @override
  String get profileSupportFaq1Title => 'كيف يعمل رابط التتبع؟';

  @override
  String get profileSupportFaq1Body =>
      'أنشئه من تفاصيل الإعلان وشاركه. عند الفتح يُحمَّل الإعلان الأصلي ويزداد عداد النقرات.';

  @override
  String get profileSupportFaq2Title => 'أين تُخزَّن بياناتي؟';

  @override
  String get profileSupportFaq2Body =>
      'في Supabase ضمن حسابك؛ يمكنك أنت فقط الوصول إلى صفوفك (عبر RLS).';

  @override
  String get listingPhotosSection => 'صور الإعلان';

  @override
  String get listingPhotosHint => 'حتى 12 صورة. JPEG أو PNG أو WebP.';

  @override
  String get addListingPhotos => 'اختيار صور';

  @override
  String get listingGalleryTitle => 'الصور';

  @override
  String get profileChangePhoto => 'تغيير صورة الملف الشخصي';

  @override
  String get profilePhotoUpdated => 'تم تحديث صورة الملف الشخصي';

  @override
  String get propertyEditTitle => 'تعديل الإعلان';

  @override
  String get propertyEditSubtitle => 'حدّث المعلومات واحفظ';

  @override
  String get propertySectionBasics => 'المعلومات الأساسية';

  @override
  String get propertySectionFeatures => 'الميزات';

  @override
  String get propertySectionMedia => 'الوسائط والرابط';

  @override
  String get listingExistingPhotos => 'الصور الحالية';

  @override
  String get propertyDetailSubtitle => 'تفاصيل العقار';

  @override
  String get tabPropertyInfo => 'معلومات';

  @override
  String get tabPropertyCustomers => 'العملاء';

  @override
  String get tabPropertyActions => 'إجراءات';

  @override
  String get propertyFeaturesTitle => 'ميزات العقار';

  @override
  String get featureRoom => 'غرف';

  @override
  String get featureArea => 'مساحة';

  @override
  String get featureFloor => 'طابق';

  @override
  String get featureAge => 'عمر';

  @override
  String get featureParking => 'موقف';

  @override
  String get featureHeating => 'تدفئة';

  @override
  String get featureUnknown => '—';

  @override
  String get markAsSold => 'تعيين كمباع';

  @override
  String get customerDetailSubtitle => 'تفاصيل العميل';

  @override
  String get searchCriteriaTitle => 'معايير البحث';

  @override
  String get tabCustomerHistory => 'السجل';

  @override
  String get tabCustomerNotes => 'ملاحظات';

  @override
  String get tabCustomerMatching => 'تطابق';

  @override
  String get activityHistoryTitle => 'سجل النشاط';

  @override
  String activityRecordsCount(int count) {
    return '$count سجل';
  }

  @override
  String get customerBadgeBuyer => 'مشتري';

  @override
  String get customerBadgeSeller => 'بائع';

  @override
  String get customerCall => 'اتصال';

  @override
  String get customerWhatsapp => 'واتساب';

  @override
  String get customerMessage => 'رسالة';

  @override
  String get localeRegionTitle => 'اللغة والمنطقة';

  @override
  String get localeRegionSavedTitle => 'تم الحفظ';

  @override
  String get localeRegionSavedBody =>
      'تم حفظ إعدادات اللغة والمنطقة. يمكنك تغييرها لاحقًا من الملف الشخصي.';

  @override
  String get localeRegionIntro =>
      'راجع لغة التطبيق والمنطقة. يمكنك تغييرها لاحقًا.';

  @override
  String get fieldRegionCountry => 'المنطقة / الدولة';

  @override
  String get fieldCurrency => 'العملة';

  @override
  String get currencyTry => 'TRY — ليرة تركية';

  @override
  String get regionTurkey => 'تركيا';

  @override
  String get regionSettingHint => 'إعداد المنطقة';

  @override
  String get currencySettingHint => 'العملة';

  @override
  String get appLanguageHint => 'لغة التطبيق';

  @override
  String get editCustomerTitle => 'تعديل العميل';

  @override
  String get customerNoLastCallInfo => 'لا يوجد سجل مكالمات بعد';

  @override
  String customerLastActivitySummary(String when) {
    return 'آخر تواصل: $when';
  }

  @override
  String get customerLastActivityJustNow => 'الآن';

  @override
  String customerLastActivityMinutesAgo(int count) {
    return 'منذ $count د';
  }

  @override
  String customerLastActivityHoursAgo(int count) {
    return 'منذ $count س';
  }

  @override
  String customerLastActivityDaysAgo(int count) {
    return 'منذ $count يوم';
  }

  @override
  String get customerUrgentTag => 'عاجل';

  @override
  String get criteriaLabelLocation => 'الموقع';

  @override
  String get criteriaLabelBudget => 'الميزانية';

  @override
  String get criteriaLabelRooms => 'الغرف';

  @override
  String get criteriaLabelArea => 'المساحة';

  @override
  String customerAreaAtLeast(String sqm) {
    return '$sqm م² فأكثر';
  }

  @override
  String get customerQuickAddNote => 'إضافة ملاحظة سريعة';

  @override
  String get customerViewListingDetail => 'عرض التفاصيل';

  @override
  String get customerSendToClient => 'إرسال للعميل';

  @override
  String customerStrongMatchesTitle(int threshold) {
    return 'تطابقات فوق $threshold٪';
  }

  @override
  String customerListingCountBadge(int count) {
    return '$count قائمة';
  }

  @override
  String get customerActivityNoteAdded => 'تمت إضافة ملاحظة';

  @override
  String get customerActivityRegistration => 'تسجيل';

  @override
  String get customerActivityRegistrationBody => 'تم إنشاء بطاقة العميل.';

  @override
  String get customerActivityTimeUnknown => '—';

  @override
  String get customerNotesEmpty => 'لا توجد ملاحظات بعد.';

  @override
  String get customerBadgeTenant => 'مستأجر';

  @override
  String get propertySuitableCustomersTitle => 'العملاء المناسبون';

  @override
  String propertySuitableCustomerCountBadge(int count) {
    return '$count عميل';
  }

  @override
  String propertyCustomerSeekingBoth(String location, String rooms) {
    return 'يبحث عن $rooms في $location';
  }

  @override
  String propertyCustomerSeekingRoomsOnly(String rooms) {
    return 'يبحث عن $rooms';
  }

  @override
  String propertyCustomerSeekingLocationOnly(String location) {
    return 'يبحث في $location';
  }

  @override
  String get propertyCustomerSeekingUnknown => 'لا تفاصيل تفضيل';

  @override
  String get propertyListingSend => 'إرسال الإعلان';

  @override
  String get propertyQuickActionsTitle => 'إجراءات سريعة';

  @override
  String get propertyActionSendCustomersTitle => 'إرسال للعملاء';

  @override
  String get propertyActionSendCustomersSubtitle =>
      'توجيه الإعلان للعملاء المناسبين';

  @override
  String get propertyActionShareTitle => 'مشاركة';

  @override
  String get propertyActionShareSubtitle => 'مشاركة كرابط أو صورة';

  @override
  String get propertyActionEditTitle => 'تعديل';

  @override
  String get propertyActionEditSubtitle => 'تحديث بيانات الإعلان';

  @override
  String get propertyActionNoteTitle => 'إضافة ملاحظة / تذكير';

  @override
  String get propertyActionNoteSubtitle => 'إنشاء ملاحظة أو مهمة لهذا الإعلان';

  @override
  String get propertyActionSyncMatchesTitle => 'حفظ التطابقات على السحابة';

  @override
  String get propertyActionSyncMatchesSubtitle =>
      'مزامنة تطابقات العملاء لهذا الإعلان';

  @override
  String get propertyNoteComingSoon => 'هذه الميزة قريبًا.';

  @override
  String get validationUrl => 'أدخل رابطًا صالحًا';

  @override
  String get taskEditTitle => 'تعديل المهمة';

  @override
  String get taskFieldPriority => 'الأولوية';

  @override
  String get taskFieldStatus => 'الحالة';

  @override
  String get taskPriorityLow => 'منخفضة';

  @override
  String get taskPriorityNormal => 'عادية';

  @override
  String get taskPriorityHigh => 'مرتفعة';

  @override
  String get taskPriorityUrgent => 'عاجلة';

  @override
  String get taskStatusOpen => 'مفتوحة';

  @override
  String get taskStatusDone => 'مكتملة';

  @override
  String get taskStatusClosed => 'مغلقة';

  @override
  String get taskClearDueDate => 'مسح تاريخ الاستحقاق';

  @override
  String get taskLoadErrorTitle => 'تعذر تحميل المهمة';

  @override
  String get taskNotFoundTitle => 'المهمة غير موجودة';

  @override
  String get taskNotFoundBody =>
      'تعذر العثور على هذه المهمة أو لا تملك صلاحية الوصول إليها.';

  @override
  String get taskRetryLoad => 'إعادة المحاولة';

  @override
  String get taskNoDueDate => 'لا يوجد تاريخ استحقاق';

  @override
  String get customerActivityTaskLinked => 'تم ربط مهمة';

  @override
  String get customerActivityPropertyMatched => 'تمت مطابقة عقار';

  @override
  String get customerActivityPropertyShared => 'تمت مشاركة العقار';

  @override
  String get customerActivityEmpty => 'لا يوجد أي نشاط مسجل حتى الآن.';

  @override
  String get customerNoteInputHint => 'أضف ملاحظة متابعة سريعة';

  @override
  String get customerSummaryNoteTitle => 'ملخص العميل';

  @override
  String get customerUnknownName => 'عميل غير معروف';

  @override
  String get customerImportContacts => 'استيراد من جهات الاتصال';

  @override
  String get customerImportPermissionDenied => 'تم رفض إذن جهات الاتصال.';

  @override
  String get customerImportNoContacts =>
      'لم يتم العثور على جهات اتصال على هذا الجهاز.';

  @override
  String get customerImportUnsupported =>
      'استيراد جهات الاتصال متاح فقط على الأجهزة المحمولة المدعومة.';

  @override
  String get customerImportPickerTitle => 'اختر جهة اتصال';

  @override
  String get listingImportFallbackTitle => 'المتابعة يدويًا';

  @override
  String get listingImportFallbackBody =>
      'بيانات المعاينة فارغة أو محجوبة. يمكنك المتابعة وإكمال الإعلان يدويًا.';

  @override
  String get listingImportContinueManual => 'متابعة يدوية';
}
