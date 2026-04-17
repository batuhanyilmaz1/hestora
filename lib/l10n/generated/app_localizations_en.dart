// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hestora CRM';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeSubtitle => 'Real estate CRM base app is ready.';

  @override
  String get buildEnvironmentTitle => 'Environment';

  @override
  String get flavorDevelopment => 'Development';

  @override
  String get flavorProduction => 'Production';

  @override
  String get supabaseSectionTitle => 'Supabase';

  @override
  String get supabaseStatusConnected => 'Supabase: connected';

  @override
  String get supabaseStatusNotConfigured =>
      'Supabase: not configured (set values in .env)';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Turkish';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get demoSectionTitle => 'Demo';

  @override
  String get demoSectionSubtitle => 'Reusable input';

  @override
  String get demoSearchLabel => 'Search';

  @override
  String get demoSearchHint => 'Try Arabic to see RTL…';

  @override
  String get navHome => 'Home';

  @override
  String get navCustomers => 'Customers';

  @override
  String get navProperties => 'Listings';

  @override
  String get navProfile => 'Profile';

  @override
  String get splashLoading => 'Loading…';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get navTasks => 'Tasks';

  @override
  String get tasksTitle => 'Tasks';

  @override
  String get tasksSubtitle => 'Follow-ups and internal work';

  @override
  String get tasksEmpty => 'No tasks yet';

  @override
  String get taskNewTitle => 'New task';

  @override
  String get taskFieldTitle => 'Title';

  @override
  String get taskFieldDue => 'Due date (optional)';

  @override
  String get taskLinkedCustomer => 'Customer (optional)';

  @override
  String get taskLinkedProperty => 'Listing (optional)';

  @override
  String get taskNoneSelected => 'None';

  @override
  String get taskMarkDone => 'Complete';

  @override
  String get taskMarkedDone => 'Task completed';

  @override
  String get aiExtractWithOpenAi => 'Extract with OpenAI';

  @override
  String get aiExtractNeedInput => 'Select an image or paste text first.';

  @override
  String get aiExtractNoApiKey => 'OPENAI_API_KEY is missing. Add it to .env.';

  @override
  String get aiExtractFailed => 'AI extraction failed';

  @override
  String get listingImportTitle => 'Import from link';

  @override
  String get listingUrlLabel => 'Listing URL';

  @override
  String get listingImportHint => 'Paste a public listing URL';

  @override
  String get listingImportAction => 'Fetch preview';

  @override
  String get onboardingSlide1Title => 'Manage customers in one place';

  @override
  String get onboardingSlide1Body =>
      'Track leads, notes, budgets and preferences without losing context.';

  @override
  String get onboardingSlide2Title => 'Listings that stay organized';

  @override
  String get onboardingSlide2Body =>
      'Keep sale and rent portfolios structured with search and filters.';

  @override
  String get onboardingSlide3Title => 'Tasks and reminders';

  @override
  String get onboardingSlide3Body =>
      'Never miss a follow-up. Link work to people and properties.';

  @override
  String get welcomeShort => 'Welcome';

  @override
  String get dashboardHeadline => 'Let\'s get started with Hestora';

  @override
  String get heroCardTitle => 'Manage everything from one place';

  @override
  String get heroCardBody =>
      'You can start managing your customers, portfolios and daily tasks in a single app.';

  @override
  String get ctaAddFirstCustomer => 'Add your first customer';

  @override
  String get ctaAddListing => 'Add listing';

  @override
  String get ctaReminder => 'Reminder';

  @override
  String get fabTip =>
      'You can quickly start actions with the + button in the center.';

  @override
  String get customersTitle => 'Customers';

  @override
  String customersSubtitle(int count) {
    return '$count customers saved';
  }

  @override
  String get propertiesTitle => 'Listings';

  @override
  String propertiesSubtitle(int count) {
    return '$count customers saved';
  }

  @override
  String get searchCustomersHint => 'Search customers (name, phone, notes)';

  @override
  String customersMatchesCount(int count) {
    return '$count matches';
  }

  @override
  String get chipBuyer => 'Buyer';

  @override
  String get chipTenant => 'Tenant';

  @override
  String get chipSeller => 'Seller';

  @override
  String get chipLandlord => 'Landlord';

  @override
  String get customersFilterTooltip => 'Sort';

  @override
  String get customersSortTitle => 'Sort';

  @override
  String get customersSortNameAsc => 'Name (A–Z)';

  @override
  String get customersSortNameDesc => 'Name (Z–A)';

  @override
  String get customersFilteredEmpty => 'No results for this filter or search.';

  @override
  String get customersFilteredEmptyClear => 'Reset';

  @override
  String get searchListingsHint => 'Search listings (location, price, type)';

  @override
  String get chipAll => 'All';

  @override
  String get chipSale => 'For sale';

  @override
  String get chipRent => 'For rent';

  @override
  String get chipActive => 'Active';

  @override
  String get chipPassive => 'Inactive';

  @override
  String get ctaAddFirstListing => 'Add your first listing';

  @override
  String get emptyCustomersTitle => 'No customers yet';

  @override
  String get emptyCustomersBody => 'Add a customer to see them listed here.';

  @override
  String get emptyPropertiesTitle => 'No listings yet';

  @override
  String get emptyPropertiesBody => 'Create a listing to build your portfolio.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileRoleConsultant => 'Real estate consultant';

  @override
  String profileStatsLine(int listingCount, int customerCount) {
    return '$listingCount listings • $customerCount customers';
  }

  @override
  String get profileStatActiveListings => 'Active listings';

  @override
  String get profileStatTotalCustomers => 'Total customers';

  @override
  String get profileStatOpenTasks => 'Open tasks';

  @override
  String get profileMenuAccount => 'Account';

  @override
  String get accountSettingsTitle => 'Account settings';

  @override
  String get accountProfileEditorTitle => 'Profile & email';

  @override
  String get accountHubProfileTitle => 'Profile & email';

  @override
  String get accountHubProfileSubtitle => 'Name, photo and email address';

  @override
  String get accountHubChangePasswordTitle => 'Change password';

  @override
  String get accountHubChangePasswordSubtitle => 'Update your sign-in password';

  @override
  String get accountHubChangeEmailTitle => 'Change email';

  @override
  String get accountHubChangeEmailSubtitle =>
      'Update the address you use to sign in';

  @override
  String get accountHubIntro => 'Manage your profile, password and email.';

  @override
  String get profileDisplayNameLabel => 'Display name';

  @override
  String get profileMenuNotifications => 'Notifications';

  @override
  String get profileMenuAnalytics => 'Analytics & reports';

  @override
  String get profileMenuSupport => 'Support / help';

  @override
  String get profileAppVersion => 'Hestora CRM v1.0.0';

  @override
  String get profileAccountSheetTitle => 'Account';

  @override
  String get profileMoreMenu => 'More';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirm => 'Are you sure you want to sign out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get registerTitle => 'Create account';

  @override
  String get forgotTitle => 'Forgot password';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get registerSubmit => 'Create account';

  @override
  String get forgotSubmit => 'Send reset link';

  @override
  String get noAccount => 'No account? Register';

  @override
  String get haveAccount => 'Already have an account? Sign in';

  @override
  String get forgotLink => 'Forgot password?';

  @override
  String get authErrorGeneric =>
      'Something went wrong. Check your details and try again.';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationEmail => 'Enter a valid email';

  @override
  String get validationPasswordLength => 'Use at least 6 characters';

  @override
  String get validationPasswordMatch => 'Passwords do not match';

  @override
  String get quickActionsTitle => 'Quick actions';

  @override
  String get quickAddCustomer => 'Add customer';

  @override
  String get quickAddProperty => 'Add listing';

  @override
  String get quickAddReminder => 'Reminder (soon)';

  @override
  String get quickAiImportCustomer => 'Customer from screenshot';

  @override
  String get customerCreateMethodTitle =>
      'How do you want to add the customer?';

  @override
  String get customerCreateOptionManual => 'Manual';

  @override
  String get customerCreateOptionManualBody =>
      'Open the classic form and enter the customer details yourself.';

  @override
  String get customerCreateOptionAi => 'With AI support';

  @override
  String get customerCreateOptionAiBody =>
      'Pick a screenshot and quickly create the customer from detected name and phone.';

  @override
  String get demoModeBanner =>
      'Demo mode: configure Supabase in .env to enable cloud sync and sign-in.';

  @override
  String get back => 'Back';

  @override
  String get save => 'Save';

  @override
  String get customerDetailTitle => 'Customer';

  @override
  String get propertyDetailTitle => 'Listing';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldPhone => 'Phone';

  @override
  String get fieldNotes => 'Notes';

  @override
  String get createCustomerTitle => 'New customer';

  @override
  String get createPropertyTitle => 'New listing';

  @override
  String get listingTitleLabel => 'Title';

  @override
  String get listingTypeLabel => 'Listing type';

  @override
  String get listingPriceLabel => 'Price';

  @override
  String get listingLocationLabel => 'Location';

  @override
  String get listingDescriptionLabel => 'Description';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get registerSuccess =>
      'Account created. Check your inbox if email confirmation is enabled.';

  @override
  String get resetEmailSent => 'If this email exists, a reset link was sent.';

  @override
  String get fieldRoomCountShort => 'Rooms';

  @override
  String get fieldBathroomCountShort => 'Baths';

  @override
  String get fieldAreaSqmShort => 'Area (m²)';

  @override
  String get ogFetchError =>
      'Could not load page metadata. Try another URL or fill manually.';

  @override
  String get ogPartialData =>
      'Some fields may be empty — you can edit before saving.';

  @override
  String get matchesForCustomer => 'Matching listings';

  @override
  String get matchesForProperty => 'Matching customers';

  @override
  String matchScoreLabel(String score) {
    return '$score% match';
  }

  @override
  String get matchStrong => 'Strong match';

  @override
  String get syncMatchesToCloud => 'Save matches to cloud';

  @override
  String get shareClicksTotal => 'Share link clicks (total)';

  @override
  String get redirectLinkTitle => 'Tracking link';

  @override
  String get createTrackingLink => 'Create tracking link';

  @override
  String get copyTrackingLink => 'Copy link';

  @override
  String get trackingLinkHelp =>
      'Opens the original listing URL and increments the total click counter (no personal data stored). Deploy the Edge Function in Supabase.';

  @override
  String get shareCardTitle => 'Share card';

  @override
  String get templateStory => 'Story 9:16';

  @override
  String get templateSquare => 'Square 1:1';

  @override
  String get exportPng => 'Export PNG';

  @override
  String get shareCardPickTheme => 'Card theme';

  @override
  String get shareCardAllThemesSample => 'All themes (sample preview)';

  @override
  String get shareCardMockOverlay => 'Use sample data in main preview';

  @override
  String shareCardBathroomsShort(int count) {
    return '$count bath';
  }

  @override
  String shareCardAreaSqmShort(String sqm) {
    return '$sqm m²';
  }

  @override
  String get shareCardTuneListingPhoto => 'Adjust photo framing';

  @override
  String get shareCardAdjustPhotoTitle => 'Listing photo framing';

  @override
  String get shareCardAdjustPhotoHint =>
      'Sliders change which part of the photo stays visible with cover fit. Quick tiles jump to common crops.';

  @override
  String get shareCardAdjustPhotoHorizontal => 'Horizontal';

  @override
  String get shareCardAdjustPhotoVertical => 'Vertical';

  @override
  String get shareCardAdjustPhotoPresets => 'Quick positions';

  @override
  String get shareCardAdjustPhotoReset => 'Reset';

  @override
  String get shareCardAdjustPhotoDone => 'Done';

  @override
  String get shareCard => 'Share';

  @override
  String get aiImportTitle => 'From screenshot';

  @override
  String get aiImportSubtitle =>
      'Pick a WhatsApp or chat screenshot with the contact info. We detect the phone and name, then create the customer with those fields only.';

  @override
  String get aiPickGallery => 'Choose image';

  @override
  String get aiSuggestedPhone => 'Detected phone';

  @override
  String get aiOpenForm => 'Continue to customer form';

  @override
  String get aiDetectedNameHint =>
      'If no name is detected, the customer will be created as Unknown customer.';

  @override
  String get aiCreateCustomer => 'Create customer';

  @override
  String get aiCreateNeedsPhone =>
      'No phone number could be detected. Try another screenshot or edit the phone field.';

  @override
  String get aiCustomerCreated => 'Customer created.';

  @override
  String get listingUrlOpen => 'Open original listing';

  @override
  String get fieldListingIntent => 'Intent';

  @override
  String get fieldPreferredLocation => 'Preferred location';

  @override
  String get fieldBudgetMin => 'Budget min';

  @override
  String get fieldBudgetMax => 'Budget max';

  @override
  String get fieldRoomCount => 'Room count';

  @override
  String get fieldAreaMin => 'Min area (m²)';

  @override
  String get fieldAreaMax => 'Max area (m²)';

  @override
  String get intentNotSet => 'Not set';

  @override
  String get loginFooterQuestion => 'Don\'t have an account?';

  @override
  String get registerFooterQuestion => 'Already have an account?';

  @override
  String get loginWelcomeTitle => 'Welcome back';

  @override
  String get loginWelcomeSubtitle => 'Log in to your account';

  @override
  String get registerHeadline => 'Create account';

  @override
  String get registerSubtitle => 'Join the premium CRM';

  @override
  String get fieldFullName => 'Full name';

  @override
  String get forgotHeaderSubtitle => 'Password reset';

  @override
  String get forgotHeroTitle => 'Reset your password';

  @override
  String get forgotHeroBody =>
      'Enter your email address to reset your password.';

  @override
  String get forgotEmailLabelCaps => 'YOUR EMAIL ADDRESS';

  @override
  String get forgotRememberedLogin => 'Remembered your password?';

  @override
  String get passwordUpdatedTitle => 'Password updated';

  @override
  String get passwordUpdatedBody =>
      'You can now sign in with your new password.';

  @override
  String get passwordUpdatedB1 => 'Your password was changed successfully.';

  @override
  String get passwordUpdatedB2 => 'Sessions on other devices were closed.';

  @override
  String get passwordUpdatedB3 => 'Your account is more secure.';

  @override
  String get goToLogin => 'Go to login';

  @override
  String get updatePasswordScreenTitle => 'Create new password';

  @override
  String get updatePasswordScreenSubtitle => 'Password renewal';

  @override
  String get updatePasswordHero => 'Set a new password for your account.';

  @override
  String get updatePasswordCta => 'Update password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get repeatNewPasswordLabel => 'Repeat new password';

  @override
  String get passwordReqTitle => 'Password requirements';

  @override
  String get reqMin8 => 'At least 8 characters';

  @override
  String get reqOneNumber => 'At least 1 number';

  @override
  String get reqOneUpper => 'At least 1 uppercase letter';

  @override
  String get strengthStrong => 'Strong';

  @override
  String get strengthMedium => 'Medium';

  @override
  String get strengthWeak => 'Weak';

  @override
  String get authKvkk => 'I have read and accept the disclosure text.';

  @override
  String get authKvkkLink => 'KVKK disclosure text';

  @override
  String get authKvkkDialogTitle => 'Disclosure text';

  @override
  String get authKvkkDialogBody =>
      'Your personal data is processed under applicable privacy laws. Replace this text with your legal copy.';

  @override
  String get emailLabelCaps => 'EMAIL';

  @override
  String get passwordLabelCaps => 'PASSWORD';

  @override
  String get registerPasswordHint => 'At least 8 characters';

  @override
  String get validationPasswordLength8 => 'Use at least 8 characters';

  @override
  String get profileNotificationsTitle => 'Notification settings';

  @override
  String get profileNotificationsSubtitle =>
      'Choose what you want to be notified about.';

  @override
  String get profileNotifyMatches => 'Match suggestions';

  @override
  String get profileNotifyMatchesSubtitle =>
      'When a new compatible listing or customer appears.';

  @override
  String get profileNotifyTasks => 'Tasks and reminders';

  @override
  String get profileNotifyTasksSubtitle => 'Due dates and new tasks.';

  @override
  String get profileNotifyMarketing => 'Product updates';

  @override
  String get profileNotifyMarketingSubtitle =>
      'New features and tips (rarely).';

  @override
  String get profileAnalyticsTitle => 'Analytics and reports';

  @override
  String get profileAnalyticsSubtitle =>
      'Summary metrics — detailed reports coming soon.';

  @override
  String get profileAnalyticsCustomers => 'Customers';

  @override
  String get profileAnalyticsListings => 'Listings';

  @override
  String get profileAnalyticsTasksOpen => 'Open tasks';

  @override
  String get profileAnalyticsShareClicks => 'Tracking link clicks';

  @override
  String get profileSupportTitle => 'Support and help';

  @override
  String get profileSupportSubtitle =>
      'Contact and frequently asked questions.';

  @override
  String get profileSupportFaqHeading => 'FAQ';

  @override
  String get profileSupportEmailAddress => 'support@hestora.app';

  @override
  String get profileSupportEmailCta => 'Email us';

  @override
  String get profileSupportEmailSubject => 'Hestora CRM support';

  @override
  String get profileSupportFaq1Title => 'How does the tracking link work?';

  @override
  String get profileSupportFaq1Body =>
      'Create it from a listing detail and share it. When opened, the original listing loads and the total click counter increases.';

  @override
  String get profileSupportFaq2Title => 'Where is my data stored?';

  @override
  String get profileSupportFaq2Body =>
      'In Supabase under your account; only you can access your rows (enforced by RLS).';

  @override
  String get listingPhotosSection => 'Listing photos';

  @override
  String get listingPhotosHint => 'Up to 12 images. JPEG, PNG, or WebP.';

  @override
  String get addListingPhotos => 'Choose photos';

  @override
  String get listingGalleryTitle => 'Photos';

  @override
  String get profileChangePhoto => 'Change profile photo';

  @override
  String get profilePhotoUpdated => 'Profile photo updated';

  @override
  String get propertyEditTitle => 'Edit listing';

  @override
  String get propertyEditSubtitle => 'Update information and save';

  @override
  String get propertySectionBasics => 'Basic information';

  @override
  String get propertySectionFeatures => 'Features';

  @override
  String get propertySectionMedia => 'Media and link';

  @override
  String get listingExistingPhotos => 'Current photos';

  @override
  String get propertyDetailSubtitle => 'Property detail';

  @override
  String get tabPropertyInfo => 'Info';

  @override
  String get tabPropertyCustomers => 'Customers';

  @override
  String get tabPropertyActions => 'Actions';

  @override
  String get propertyFeaturesTitle => 'Property features';

  @override
  String get featureRoom => 'Room';

  @override
  String get featureArea => 'Area';

  @override
  String get featureFloor => 'Floor';

  @override
  String get featureAge => 'Age';

  @override
  String get featureParking => 'Parking';

  @override
  String get featureHeating => 'Heating';

  @override
  String get featureUnknown => '—';

  @override
  String get markAsSold => 'Mark as sold';

  @override
  String get customerDetailSubtitle => 'Customer detail';

  @override
  String get searchCriteriaTitle => 'Search criteria';

  @override
  String get tabCustomerHistory => 'History';

  @override
  String get tabCustomerNotes => 'Notes';

  @override
  String get tabCustomerMatching => 'Matching';

  @override
  String get activityHistoryTitle => 'Activity history';

  @override
  String activityRecordsCount(int count) {
    return '$count records';
  }

  @override
  String get customerBadgeBuyer => 'Buyer';

  @override
  String get customerBadgeSeller => 'Seller';

  @override
  String get customerCall => 'Call';

  @override
  String get customerWhatsapp => 'WhatsApp';

  @override
  String get customerMessage => 'Message';

  @override
  String get localeRegionTitle => 'Language & region';

  @override
  String get localeRegionSavedTitle => 'Saved';

  @override
  String get localeRegionSavedBody =>
      'Your language and region settings were saved. You can change them anytime from your profile.';

  @override
  String get localeRegionIntro =>
      'Review app language and region. You can change them later if you want.';

  @override
  String get fieldRegionCountry => 'Region / country';

  @override
  String get fieldCurrency => 'Currency';

  @override
  String get currencyTry => 'TRY — Turkish Lira';

  @override
  String get regionTurkey => 'Turkey';

  @override
  String get regionSettingHint => 'Region setting';

  @override
  String get currencySettingHint => 'Currency';

  @override
  String get appLanguageHint => 'App language';

  @override
  String get editCustomerTitle => 'Edit customer';

  @override
  String get customerNoLastCallInfo => 'No call log yet';

  @override
  String customerLastActivitySummary(String when) {
    return 'Last contact: $when';
  }

  @override
  String get customerLastActivityJustNow => 'Just now';

  @override
  String customerLastActivityMinutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String customerLastActivityHoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String customerLastActivityDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get customerUrgentTag => 'Urgent';

  @override
  String get criteriaLabelLocation => 'Location';

  @override
  String get criteriaLabelBudget => 'Budget';

  @override
  String get criteriaLabelRooms => 'Rooms';

  @override
  String get criteriaLabelArea => 'Area';

  @override
  String customerAreaAtLeast(String sqm) {
    return '$sqm m² and up';
  }

  @override
  String get customerQuickAddNote => 'Add quick note';

  @override
  String get customerViewListingDetail => 'View detail';

  @override
  String get customerSendToClient => 'Send to customer';

  @override
  String customerStrongMatchesTitle(int threshold) {
    return 'Matches over $threshold%';
  }

  @override
  String customerListingCountBadge(int count) {
    return '$count listings';
  }

  @override
  String get customerActivityNoteAdded => 'Note added';

  @override
  String get customerActivityRegistration => 'Registration';

  @override
  String get customerActivityRegistrationBody => 'Customer card was created.';

  @override
  String get customerActivityTimeUnknown => '—';

  @override
  String get customerNotesEmpty => 'No notes yet.';

  @override
  String get customerBadgeTenant => 'Tenant';

  @override
  String get propertySuitableCustomersTitle => 'Suitable customers';

  @override
  String propertySuitableCustomerCountBadge(int count) {
    return '$count customers';
  }

  @override
  String propertyCustomerSeekingBoth(String location, String rooms) {
    return 'Seeking $rooms in $location';
  }

  @override
  String propertyCustomerSeekingRoomsOnly(String rooms) {
    return 'Seeking $rooms';
  }

  @override
  String propertyCustomerSeekingLocationOnly(String location) {
    return 'Looking in $location';
  }

  @override
  String get propertyCustomerSeekingUnknown => 'No preference details';

  @override
  String get propertyListingSend => 'Send listing';

  @override
  String get propertyQuickActionsTitle => 'Quick actions';

  @override
  String get propertyActionSendCustomersTitle => 'Send to customers';

  @override
  String get propertyActionSendCustomersSubtitle =>
      'Forward this listing to suitable customers';

  @override
  String get propertyActionShareTitle => 'Share';

  @override
  String get propertyActionShareSubtitle => 'Share as link or image';

  @override
  String get propertyActionEditTitle => 'Edit';

  @override
  String get propertyActionEditSubtitle => 'Update listing details';

  @override
  String get propertyActionNoteTitle => 'Add note / reminder';

  @override
  String get propertyActionNoteSubtitle =>
      'Create a note or task for this listing';

  @override
  String get propertyActionSyncMatchesTitle => 'Save matches to cloud';

  @override
  String get propertyActionSyncMatchesSubtitle =>
      'Sync customer matches for this listing';

  @override
  String get propertyNoteComingSoon => 'This feature is coming soon.';

  @override
  String get validationUrl => 'Enter a valid URL';

  @override
  String get taskEditTitle => 'Edit task';

  @override
  String get taskFieldPriority => 'Priority';

  @override
  String get taskFieldStatus => 'Status';

  @override
  String get taskPriorityLow => 'Low';

  @override
  String get taskPriorityNormal => 'Normal';

  @override
  String get taskPriorityHigh => 'High';

  @override
  String get taskPriorityUrgent => 'Urgent';

  @override
  String get taskStatusOpen => 'Open';

  @override
  String get taskStatusDone => 'Done';

  @override
  String get taskStatusClosed => 'Closed';

  @override
  String get taskClearDueDate => 'Clear due date';

  @override
  String get taskLoadErrorTitle => 'Could not load task';

  @override
  String get taskNotFoundTitle => 'Task not found';

  @override
  String get taskNotFoundBody =>
      'This task does not exist or you no longer have access to it.';

  @override
  String get taskRetryLoad => 'Retry';

  @override
  String get taskNoDueDate => 'No due date';

  @override
  String get customerActivityTaskLinked => 'Task linked';

  @override
  String get customerActivityPropertyMatched => 'Property matched';

  @override
  String get customerActivityPropertyShared => 'Property shared';

  @override
  String get customerActivityEmpty => 'No activity has been recorded yet.';

  @override
  String get customerNoteInputHint => 'Add a quick follow-up note';

  @override
  String get customerSummaryNoteTitle => 'Customer summary';

  @override
  String get customerUnknownName => 'Unknown customer';

  @override
  String get customerImportContacts => 'Import from contacts';

  @override
  String get customerImportPermissionDenied =>
      'Contacts permission was denied.';

  @override
  String get customerImportNoContacts =>
      'No contacts were found on this device.';

  @override
  String get customerImportUnsupported =>
      'Contacts import is only available on supported mobile devices.';

  @override
  String get customerImportPickerTitle => 'Choose a contact';

  @override
  String get listingImportFallbackTitle => 'Continue manually';

  @override
  String get listingImportFallbackBody =>
      'Preview data is missing or blocked. You can continue and complete the listing manually.';

  @override
  String get listingImportContinueManual => 'Continue with manual form';
}
