// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'هيستورا';

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
    return '$count إعلان مسجل';
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
  String get accountProfileEditorTitle => 'الملف والهاتف والبريد';

  @override
  String get accountHubProfileTitle => 'الملف والبريد';

  @override
  String get accountHubProfileSubtitle => 'الاسم والصورة والهاتف والبريد';

  @override
  String get accountProfilePhoneHint =>
      'اختياري. يظهر في بطاقة العلامة وبطاقات المشاركة.';

  @override
  String get brandCardAddPhoneAction => 'أضف الهاتف من الملف';

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
  String get profileAppVersion => 'Hestora v1.0.0';

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
  String get loginTitle => 'تسجيل الدخول بالبريد';

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
  String get authEmailNotVerified =>
      'يرجى تأكيد بريدك الإلكتروني قبل تسجيل الدخول. افتح الرابط في صندوق الوارد.';

  @override
  String get authLinkInvalid =>
      'رابط تسجيل الدخول غير صالح أو منتهٍ. جرّب تسجيل الدخول من التطبيق.';

  @override
  String get postVerifySessionMissing =>
      'تعذر استعادة الجلسة من هذا الرابط. افتح التطبيق وسجّل الدخول يدويًا.';

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
  String get loginWelcomeSubtitle => 'سجّل الدخول باستخدام بريدك وكلمة المرور';

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
  String get profileNotificationsSubtitle => 'خصص الإشعارات';

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
  String get profileNotifyMasterTitle => 'تشغيل / إيقاف الإشعارات';

  @override
  String get profileNotifyMasterOn => 'كل الإشعارات مفعّلة';

  @override
  String get profileNotifyMasterOff => 'الإشعارات متوقفة';

  @override
  String get profileNotifyTypesSection => 'أنواع الإشعارات';

  @override
  String get profileNotifyTaskTitle => 'إشعارات المهام';

  @override
  String get profileNotifyTaskSubtitle => 'مهام جديدة وتعيينات';

  @override
  String get profileNotifyReminderTitle => 'التذكيرات';

  @override
  String get profileNotifyReminderSubtitle => 'التذكيرات عند حلول وقتها';

  @override
  String get profileNotifyCustomerTitle => 'نشاط العملاء';

  @override
  String get profileNotifyCustomerSubtitle => 'عملاء جدد وتحديثات';

  @override
  String get profileNotifySystemTitle => 'إشعارات النظام';

  @override
  String get profileNotifySystemSubtitle => 'تحديثات التطبيق';

  @override
  String get profileNotifyCampaignTitle => 'الحملات والإعلانات';

  @override
  String get profileNotifyCampaignSubtitle => 'عروض خاصة وأخبار';

  @override
  String get profileNotifyDeviceNote =>
      'تعتمد إعدادات الإشعارات على أذونات الجهاز. يمكنك إدارتها أيضًا من إعدادات النظام.';

  @override
  String get profileAnalyticsTitle => 'التحليلات والتقارير';

  @override
  String get profileAnalyticsSubtitle => 'ملخص الأداء';

  @override
  String get profileAnalyticsCustomers => 'العملاء';

  @override
  String get profileAnalyticsListings => 'الإعلانات';

  @override
  String get profileAnalyticsTasksOpen => 'مهام مفتوحة';

  @override
  String get profileAnalyticsShareClicks => 'نقرات رابط التتبع';

  @override
  String get profileAnalyticsPeriodWeek => 'أسبوعي';

  @override
  String get profileAnalyticsPeriodMonth => 'شهري';

  @override
  String get profileAnalyticsPeriodYear => 'سنوي';

  @override
  String get profileAnalyticsActiveListings => 'إعلانات نشطة';

  @override
  String get profileAnalyticsCompleted => 'مكتمل';

  @override
  String get profileAnalyticsRevenue => 'الإيرادات';

  @override
  String get profileAnalyticsActivityChart => 'مخطط النشاط';

  @override
  String get profileAnalyticsPerfSummary => 'ملخص الأداء';

  @override
  String get profileAnalyticsConversion => 'معدل التحويل';

  @override
  String get profileAnalyticsAvgClose => 'متوسط وقت الإغلاق';

  @override
  String get profileAnalyticsMostActive => 'أكثر إجراء نشاطًا';

  @override
  String get profileAnalyticsMostActiveListingShare => 'مشاركة إعلان';

  @override
  String get profileAnalyticsMostActiveSalesClose => 'إغلاق بيع';

  @override
  String get profileAnalyticsExportReport => 'تصدير التقرير';

  @override
  String get profileAnalyticsExportSoon => 'التصدير قريبًا.';

  @override
  String profileAnalyticsDays(int count) {
    return '$count يومًا';
  }

  @override
  String get profileSupportTitle => 'الدعم / المساعدة';

  @override
  String get profileSupportSubtitle => 'كيف يمكننا المساعدة؟';

  @override
  String get supportTileKvkkTitle => 'KVKK والخصوصية';

  @override
  String get supportTileKvkkSubtitle => 'سياسة حماية البيانات';

  @override
  String get supportTileFaqTitle => 'الأسئلة الشائعة';

  @override
  String get supportTileFaqSubtitle => 'أسئلة يتكرر طرحها';

  @override
  String get supportTileContactTitle => 'تواصل معنا';

  @override
  String get supportTileContactSubtitle => 'خط دعم على مدار الساعة';

  @override
  String get supportRightsFooter => 'Hestora v1.0.0 • جميع الحقوق محفوظة';

  @override
  String get contactUsTitle => 'تواصل معنا';

  @override
  String get contactUsSubtitle => 'خط دعم على مدار الساعة';

  @override
  String get contactChannelsTitle => 'قنوات التواصل';

  @override
  String get contactEmailSupport => 'دعم البريد';

  @override
  String get contactWhatsapp => 'واتساب';

  @override
  String get contactPhone => 'الهاتف';

  @override
  String get contactSupportEmailValue => 'destek@hestora.com';

  @override
  String get contactSupportPhoneValue => '+90 850 123 45 67';

  @override
  String get contactHoursTitle => 'ساعات العمل';

  @override
  String get contactHoursSubtitle => 'فريق الدعم متاح خلال الأوقات التالية';

  @override
  String get contactHoursWeekday => 'الاثنين – الجمعة';

  @override
  String get contactHoursWeekdayValue => '09:00 – 18:00';

  @override
  String get contactHoursSaturday => 'السبت';

  @override
  String get contactHoursSaturdayValue => '10:00 – 15:00';

  @override
  String get contactHoursSunday => 'الأحد';

  @override
  String get contactHoursClosed => 'مغلق';

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
  String get localeRegionTitle => 'إعدادات اللغة والمنطقة';

  @override
  String get localeRegionScreenSubtitle => 'حدد تفضيلاتك';

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
  String get currencyOptionUsd => 'USD — الدولار الأمريكي';

  @override
  String get currencyOptionAed => 'AED — درهم إماراتي';

  @override
  String get currencyOptionEur => 'EUR — يورو';

  @override
  String get currencyOptionGbp => 'GBP — جنيه إسترليني';

  @override
  String get regionTurkey => 'تركيا';

  @override
  String get regionCountryAE => 'الإمارات العربية المتحدة';

  @override
  String get regionCountryUS => 'الولايات المتحدة';

  @override
  String get regionCountryGB => 'المملكة المتحدة';

  @override
  String get regionCountryDE => 'ألمانيا';

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

  @override
  String get initialSetupTitle => 'اختر اللغة والمنطقة';

  @override
  String get initialSetupSubtitle =>
      'يمكنك تغيير ذلك لاحقًا من إعدادات الملف الشخصي.';

  @override
  String get initialSetupContinue => 'متابعة';

  @override
  String get postVerifyTitle => 'تم التحقق من البريد';

  @override
  String get postVerifyHeadline => 'حسابك جاهز';

  @override
  String get postVerifyBody =>
      'بعد تفعيل الفوترة ستكمل اختيار الخطة. يمكنك الآن متابعة التطبيق.';

  @override
  String get postVerifyContinue => 'متابعة إلى التطبيق';

  @override
  String get propertyCreateMethodTitle => 'إضافة إعلان';

  @override
  String get propertyCreateOptionManual => 'يدوي';

  @override
  String get propertyCreateOptionManualBody =>
      'أدخل تفاصيل الإعلان في النموذج.';

  @override
  String get propertyCreateOptionLink => 'برابط';

  @override
  String get propertyCreateOptionLinkBody =>
      'الصق رابط إعلان عام لملء الحقول مسبقًا.';

  @override
  String get dashboardTasksToday => 'للتنفيذ (مهام مفتوحة)';

  @override
  String get dashboardTasksCompleted => 'مكتملة مؤخرًا';

  @override
  String get dashboardTasksEmptyOpen =>
      'لا توجد مهام مفتوحة بعد. أضف مهمة من المهام أو قائمة +.';

  @override
  String get dashboardTasksEmptyDone => 'ستظهر المهام المكتملة هنا.';

  @override
  String get dashboardViewAllTasks => 'عرض كل المهام';

  @override
  String get authKvkkRequired => 'يرجى قبول الإفصاح للمتابعة.';

  @override
  String get shareCardExportNotReady =>
      'المعاينة ما زالت تُحمّل. حاول مرة أخرى بعد لحظة.';

  @override
  String get shareCardExportFailed => 'تعذر تصدير الصورة. حاول مرة أخرى.';

  @override
  String get customerRoleBuyer => 'مشتري';

  @override
  String get customerRoleTenant => 'مستأجر';

  @override
  String get customerRoleSeller => 'بائع';

  @override
  String get customerRoleLandlord => 'مالك';

  @override
  String get taskSheetPickCustomerTitle => 'اختر عميلاً';

  @override
  String get taskSheetPickCustomerSubtitle => 'اربط التذكير بعميل';

  @override
  String get taskSheetPickPropertyTitle => 'اختر عقارًا';

  @override
  String get taskSheetPickPropertySubtitle => 'اربط التذكير بعقار';

  @override
  String get taskRemindTitle => 'إضافة تذكير';

  @override
  String get taskRemindSubtitle => 'إنشاء مهمة جديدة';

  @override
  String taskTodayCount(int count) {
    return 'اليوم: $count مهام';
  }

  @override
  String get taskBadgeRequired => 'مطلوب';

  @override
  String get taskBadgeOptional => 'اختياري';

  @override
  String get taskNotifySectionTitle => 'إشعار';

  @override
  String get taskNotifyOnTitle => 'الإشعارات مفعّلة';

  @override
  String get taskNotifyOnSubtitle => 'ذكّر عند الموعد';

  @override
  String get taskLinkSectionTitle => 'ربط';

  @override
  String get taskLinkCustomerRow => 'ربط بعميل';

  @override
  String get taskLinkPropertyRow => 'ربط بعقار';

  @override
  String get taskPickCustomerHint => 'اختر عميلاً';

  @override
  String get taskPickPropertyHint => 'اختر عقارًا';

  @override
  String get taskDateShort => 'التاريخ';

  @override
  String get taskTimeShort => 'الوقت';

  @override
  String get provincePickTitle => 'اختر المحافظة';

  @override
  String get listingLayoutPickTitle => 'اختر نوع الإعلان';

  @override
  String get propertyFormQuickPickSection => 'المحافظة ونوع الإعلان';

  @override
  String get propertyFormPickEmpty => 'اختر';

  @override
  String get propertyFormLinkSection => 'رابط الإعلان';

  @override
  String get propertyFormApplyPreview => 'تطبيق على النموذج';

  @override
  String get propertyFormApplyDone => 'تم تحديث العنوان والوصف.';

  @override
  String get accountInfoTitle => 'معلومات الحساب';

  @override
  String get accountInfoSubtitle => 'إدارة الملف وبطاقة العلامة';

  @override
  String get accountTabPersonal => 'البيانات الشخصية';

  @override
  String get accountTabBrand => 'بطاقة العلامة';

  @override
  String get brandCardPreview => 'معاينة البطاقة';

  @override
  String get brandPickTemplate => 'اختر القالب';

  @override
  String get brandSloganLabel => 'الشعار / الجملة';

  @override
  String get brandWebsiteLabel => 'الموقع';

  @override
  String get signOutSheetTitle => 'تسجيل الخروج؟';

  @override
  String get signOutSheetBody => 'يمكنك تسجيل الدخول لاحقًا.';

  @override
  String get deleteAccountTitle => 'حذف الحساب';

  @override
  String get deleteAccountDanger => 'منطقة خطرة';

  @override
  String get deleteAccountQuestion => 'هل أنت متأكد أنك تريد حذف حسابك؟';

  @override
  String get deleteAccountWarning =>
      'لا يمكن التراجع. ستُحذف بيانات العملاء والعقارات والتذكيرات.';

  @override
  String get deleteAccountCta => 'أريد حذف حسابي';

  @override
  String get kvkkTitle => 'الخصوصية وKVKK';

  @override
  String get kvkkSubtitle => 'كيف يمكننا المساعدة؟';

  @override
  String get kvkkSafeTitle => 'بياناتك آمنة';

  @override
  String get kvkkSafeBody => 'تلتزم Hestora بحماية بياناتك الشخصية.';

  @override
  String get faqTitle => 'الأسئلة الشائعة';

  @override
  String get faqSubtitle => 'أسئلة متكررة';

  @override
  String get packagePickTitle => 'اختيار الباقة';

  @override
  String get packagePickSubtitle => 'اختر الخطة المناسبة';

  @override
  String get packageHeadline => 'الترقية إلى Premium';

  @override
  String get packageSubline => 'يمكنك الإلغاء في أي وقت';

  @override
  String get paymentSummaryTitle => 'ملخص الدفع';

  @override
  String get paymentSummarySubtitle => 'دفع آمن';

  @override
  String get profileCreateTitle => 'إنشاء ملف';

  @override
  String get profileCreateSubtitle => 'الخطوة الأخيرة';

  @override
  String get profileCreateHeadline => 'أكمل ملفك';

  @override
  String get profileCreateSubline => 'ابدأ بإدخال بياناتك';

  @override
  String get profileCreateCompleteCta => 'إكمال والبدء';

  @override
  String get profileCreateComingSoon =>
      'سيتم جمع بيانات المكتب والصور لاحقًا. يمكنك المتابعة الآن.';

  @override
  String get kvkkSection1Title => '1. المتحكم بالبيانات';

  @override
  String get kvkkSection1Body => 'Hestora تعالج بياناتك لتقديم الخدمة.';

  @override
  String get kvkkSection2Title => '2. البيانات المعالجة';

  @override
  String get kvkkSection2Body => 'هوية، تواصل، استخدام ومحتوى تضيفه.';

  @override
  String get kvkkSection3Title => '3. الأغراض';

  @override
  String get kvkkSection3Body => 'إدارة الحساب، الأمان، التحليلات والدعم.';

  @override
  String get kvkkSection4Title => '4. الأمان';

  @override
  String get kvkkSection4Body => 'تدابير تقنية وتنظيمية لحماية بياناتك.';

  @override
  String get kvkkSection5Title => '5. حقوقك';

  @override
  String get kvkkSection5Body => 'الوصول، التصحيح، المحو والنقل حيثما ينطبق.';

  @override
  String get kvkkSection6Title => '6. ملفات تعريف الارتباط';

  @override
  String get kvkkSection6Body => 'أساسية للمصادقة؛ تحليلات اختيارية.';

  @override
  String get kvkkFooterContact => 'للأسئلة: support@hestora.com';

  @override
  String get faqQ1 => 'كيف أصدّر بياناتي؟';

  @override
  String get faqA1 => 'الملف > الحساب > تصدير (قريبًا).';

  @override
  String get faqQ2 => 'كيف أغيّر الباقة؟';

  @override
  String get faqA2 => 'من الفوترة عند التفعيل.';

  @override
  String get faqQ3 => 'نسيت كلمة المرور';

  @override
  String get faqA3 => 'استخدم نسيت كلمة المرور من تسجيل الدخول.';

  @override
  String get faqQ4 => 'كيف يعمل التطابق؟';

  @override
  String get faqA4 => 'حسب تفضيلات العميل وبيانات الإعلان.';

  @override
  String get faqQ5 => 'كيف أحذف حسابي؟';

  @override
  String get faqA5 => 'الملف > حذف الحساب.';

  @override
  String get faqQ6 => 'لماذا لا تصل الإشعارات؟';

  @override
  String get faqA6 => 'تحقق من إعدادات الجهاز والتطبيق.';

  @override
  String get deleteAccountListTitle => 'سيتم حذف:';

  @override
  String get deleteAccountList1 => 'جميع العملاء';

  @override
  String get deleteAccountList2 => 'جميع الإعلانات';

  @override
  String get deleteAccountList3 => 'التذكيرات والمهام';

  @override
  String get deleteAccountList4 => 'الملف وبطاقة العلامة';

  @override
  String get deleteAccountList5 => 'سجل الاشتراك';

  @override
  String get deleteAccountComingSoon => 'حذف الحساب غير متصل بعد.';

  @override
  String get packageTrialBadge => 'مجانًا';

  @override
  String get packageTrialTitle => 'تجربة أسبوع';

  @override
  String get packageTrialPrice => '₺0 / شهريًا';

  @override
  String get packageTrialDesc => 'جرّب كل الميزات';

  @override
  String get packageMonthlyTitle => 'شهري';

  @override
  String get packageMonthlyPrice => '₺299 / شهريًا';

  @override
  String get packageMonthlyDesc => 'فوترة شهرية مرنة';

  @override
  String get packageYearlyBadge => 'الأفضل';

  @override
  String get packageYearlyTitle => 'سنوي';

  @override
  String get packageYearlyPrice => '₺199 / شهريًا';

  @override
  String get packageYearlyDesc => 'وفر 33٪ سنويًا';

  @override
  String get packageCta => 'متابعة';

  @override
  String get paymentPlanName => 'خطة سنوية';

  @override
  String get paymentPlanSub => 'Hestora Premium';

  @override
  String get paymentBestValue => 'الأفضل';

  @override
  String get paymentLineYear => 'اشتراك سنوي';

  @override
  String get paymentLineYearValue => '₺2,388';

  @override
  String get paymentLineDiscount => 'خصم (33٪)';

  @override
  String get paymentLineDiscountValue => '-₺788';

  @override
  String get paymentTotal => 'الإجمالي';

  @override
  String get paymentTotalValue => '₺1,600';

  @override
  String get paymentVatNote => 'شامل الضريبة • فوترة سنوية';

  @override
  String get paymentIncludedTitle => 'يشمل';

  @override
  String get paymentFeat1 => 'عملاء غير محدودين';

  @override
  String get paymentFeat2 => 'إعلانات غير محدودة';

  @override
  String get paymentFeat3 => 'استخراج بالذكاء الاصطناعي';

  @override
  String get paymentFeat4 => 'تذكيرات ذكية';

  @override
  String get paymentFeat5 => 'تحليلات متقدمة';

  @override
  String get paymentFeat6 => 'دعم أولوية';

  @override
  String get paymentGuarantee => 'ضمان استرداد 30 يومًا عند تفعيل الفوترة.';

  @override
  String get paymentProcessingCta => 'متابعة إلى التطبيق';

  @override
  String get brandTemplateDarkBlue => 'أزرق داكن';

  @override
  String get brandTemplateNight => 'ليلي';

  @override
  String get brandTemplateEmerald => 'زمردي';

  @override
  String get brandTemplateGold => 'ذهبي';

  @override
  String get brandPreviewName => 'أحمد يلماز';

  @override
  String get brandPreviewRole => 'مستشار عقاري';

  @override
  String get brandPreviewSloganPlaceholder => 'مستشارك الموثوق';

  @override
  String get brandShare => 'مشاركة';

  @override
  String get brandShareSoon => 'مشاركة بطاقة العلامة قريبًا.';

  @override
  String get brandCardWatermark => 'HESTORA CRM';

  @override
  String get brandCardQr => 'رمز QR';
}
