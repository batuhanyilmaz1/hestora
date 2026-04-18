// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hestora';

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
    return '$count listings saved';
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
  String get accountProfileEditorTitle => 'Profile, phone & email';

  @override
  String get accountHubProfileTitle => 'Profile & email';

  @override
  String get accountHubProfileSubtitle =>
      'Name, photo, phone and email address';

  @override
  String get accountProfilePhoneHint =>
      'Optional. Shown on your brand card and share cards.';

  @override
  String get brandCardAddPhoneAction => 'Add phone from profile';

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
  String get profileAppVersion => 'Hestora v1.0.0';

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
  String get loginTitle => 'Email sign-in';

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
  String get authEmailNotVerified =>
      'Please confirm your email before signing in. Check your inbox for the verification link.';

  @override
  String get authLinkInvalid =>
      'This sign-in link is invalid or expired. Try signing in from the app.';

  @override
  String get postVerifySessionMissing =>
      'We could not restore your session from this link. Please open the app and sign in, then verify your email again if needed.';

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
  String get loginWelcomeSubtitle => 'Sign in with your email and password';

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
  String get profileNotificationsSubtitle => 'Customize notifications';

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
  String get profileNotifyMasterTitle => 'Turn notifications on / off';

  @override
  String get profileNotifyMasterOn => 'All notifications on';

  @override
  String get profileNotifyMasterOff => 'Notifications off';

  @override
  String get profileNotifyTypesSection => 'NOTIFICATION TYPES';

  @override
  String get profileNotifyTaskTitle => 'Task notifications';

  @override
  String get profileNotifyTaskSubtitle => 'New tasks and assignments';

  @override
  String get profileNotifyReminderTitle => 'Reminders';

  @override
  String get profileNotifyReminderSubtitle => 'Due reminders';

  @override
  String get profileNotifyCustomerTitle => 'Customer activity';

  @override
  String get profileNotifyCustomerSubtitle => 'New customers and updates';

  @override
  String get profileNotifySystemTitle => 'System notifications';

  @override
  String get profileNotifySystemSubtitle => 'App updates';

  @override
  String get profileNotifyCampaignTitle => 'Campaigns & announcements';

  @override
  String get profileNotifyCampaignSubtitle => 'Special offers and news';

  @override
  String get profileNotifyDeviceNote =>
      'Notification settings depend on device permissions. You can also manage them in system settings.';

  @override
  String get profileAnalyticsTitle => 'Analytics & Reports';

  @override
  String get profileAnalyticsSubtitle => 'Performance summary';

  @override
  String get profileAnalyticsCustomers => 'Customers';

  @override
  String get profileAnalyticsListings => 'Listings';

  @override
  String get profileAnalyticsTasksOpen => 'Open tasks';

  @override
  String get profileAnalyticsShareClicks => 'Tracking link clicks';

  @override
  String get profileAnalyticsPeriodWeek => 'Weekly';

  @override
  String get profileAnalyticsPeriodMonth => 'Monthly';

  @override
  String get profileAnalyticsPeriodYear => 'Yearly';

  @override
  String get profileAnalyticsActiveListings => 'Active listings';

  @override
  String get profileAnalyticsCompleted => 'Completed';

  @override
  String get profileAnalyticsRevenue => 'Revenue';

  @override
  String get profileAnalyticsActivityChart => 'Activity chart';

  @override
  String get profileAnalyticsPerfSummary => 'Performance summary';

  @override
  String get profileAnalyticsConversion => 'Conversion rate';

  @override
  String get profileAnalyticsAvgClose => 'Avg. closing time';

  @override
  String get profileAnalyticsMostActive => 'Most active action';

  @override
  String get profileAnalyticsMostActiveListingShare => 'Listing share';

  @override
  String get profileAnalyticsMostActiveSalesClose => 'Sales closing';

  @override
  String get profileAnalyticsExportReport => 'Export report';

  @override
  String get profileAnalyticsExportSoon => 'Export is coming soon.';

  @override
  String profileAnalyticsDays(int count) {
    return '$count days';
  }

  @override
  String get profileSupportTitle => 'Support / Help';

  @override
  String get profileSupportSubtitle => 'How can we help?';

  @override
  String get supportTileKvkkTitle => 'KVKK & Privacy';

  @override
  String get supportTileKvkkSubtitle => 'Data protection policy';

  @override
  String get supportTileFaqTitle => 'FAQ';

  @override
  String get supportTileFaqSubtitle => 'Frequently asked questions';

  @override
  String get supportTileContactTitle => 'Contact us';

  @override
  String get supportTileContactSubtitle => '24/7 support line';

  @override
  String get supportRightsFooter => 'Hestora v1.0.0 • All rights reserved';

  @override
  String get contactUsTitle => 'Contact us';

  @override
  String get contactUsSubtitle => '24/7 support line';

  @override
  String get contactChannelsTitle => 'Contact channels';

  @override
  String get contactEmailSupport => 'Email support';

  @override
  String get contactWhatsapp => 'WhatsApp';

  @override
  String get contactPhone => 'Phone';

  @override
  String get contactSupportEmailValue => 'destek@hestora.com';

  @override
  String get contactSupportPhoneValue => '+90 850 123 45 67';

  @override
  String get contactHoursTitle => 'Working hours';

  @override
  String get contactHoursSubtitle =>
      'Our support team is available during the following hours';

  @override
  String get contactHoursWeekday => 'Monday – Friday';

  @override
  String get contactHoursWeekdayValue => '09:00 – 18:00';

  @override
  String get contactHoursSaturday => 'Saturday';

  @override
  String get contactHoursSaturdayValue => '10:00 – 15:00';

  @override
  String get contactHoursSunday => 'Sunday';

  @override
  String get contactHoursClosed => 'Closed';

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
  String get localeRegionTitle => 'Language & region settings';

  @override
  String get localeRegionScreenSubtitle => 'Set your preferences';

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
  String get currencyOptionUsd => 'USD — US Dollar';

  @override
  String get currencyOptionAed => 'AED — UAE Dirham';

  @override
  String get currencyOptionEur => 'EUR — Euro';

  @override
  String get currencyOptionGbp => 'GBP — British Pound';

  @override
  String get regionTurkey => 'Turkey';

  @override
  String get regionCountryAE => 'United Arab Emirates';

  @override
  String get regionCountryUS => 'United States';

  @override
  String get regionCountryGB => 'United Kingdom';

  @override
  String get regionCountryDE => 'Germany';

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

  @override
  String get initialSetupTitle => 'Choose language and region';

  @override
  String get initialSetupSubtitle =>
      'You can change these later in profile settings.';

  @override
  String get initialSetupContinue => 'Continue';

  @override
  String get postVerifyTitle => 'Email verified';

  @override
  String get postVerifyHeadline => 'Your account is ready';

  @override
  String get postVerifyBody =>
      'Next, complete your plan selection when billing is enabled. For now you can continue to the app.';

  @override
  String get postVerifyContinue => 'Continue to app';

  @override
  String get propertyCreateMethodTitle => 'Add listing';

  @override
  String get propertyCreateOptionManual => 'Manual';

  @override
  String get propertyCreateOptionManualBody =>
      'Fill in listing details in the form.';

  @override
  String get propertyCreateOptionLink => 'Via link';

  @override
  String get propertyCreateOptionLinkBody =>
      'Paste a public listing URL to pre-fill fields.';

  @override
  String get dashboardTasksToday => 'To do (open tasks)';

  @override
  String get dashboardTasksCompleted => 'Recently completed';

  @override
  String get dashboardTasksEmptyOpen =>
      'No open tasks yet. Add one from Tasks or the + menu.';

  @override
  String get dashboardTasksEmptyDone => 'Completed tasks will appear here.';

  @override
  String get dashboardViewAllTasks => 'View all tasks';

  @override
  String get authKvkkRequired => 'Please accept the disclosure to continue.';

  @override
  String get shareCardExportNotReady =>
      'Preview is still loading. Try again in a moment.';

  @override
  String get shareCardExportFailed =>
      'Could not export the image. Please try again.';

  @override
  String get customerRoleBuyer => 'Buyer';

  @override
  String get customerRoleTenant => 'Tenant';

  @override
  String get customerRoleSeller => 'Seller';

  @override
  String get customerRoleLandlord => 'Landlord';

  @override
  String get taskSheetPickCustomerTitle => 'Select customer';

  @override
  String get taskSheetPickCustomerSubtitle => 'Link the reminder to a customer';

  @override
  String get taskSheetPickPropertyTitle => 'Select property';

  @override
  String get taskSheetPickPropertySubtitle => 'Link the reminder to a property';

  @override
  String get taskRemindTitle => 'Add reminder';

  @override
  String get taskRemindSubtitle => 'Create a new task';

  @override
  String taskTodayCount(int count) {
    return 'Today: $count tasks';
  }

  @override
  String get taskBadgeRequired => 'Required';

  @override
  String get taskBadgeOptional => 'Optional';

  @override
  String get taskNotifySectionTitle => 'Notification';

  @override
  String get taskNotifyOnTitle => 'Notifications on';

  @override
  String get taskNotifyOnSubtitle => 'Remind when it\'s time';

  @override
  String get taskLinkSectionTitle => 'Link';

  @override
  String get taskLinkCustomerRow => 'Link to customer';

  @override
  String get taskLinkPropertyRow => 'Link to property';

  @override
  String get taskPickCustomerHint => 'Select customer';

  @override
  String get taskPickPropertyHint => 'Select property';

  @override
  String get taskDateShort => 'Date';

  @override
  String get taskTimeShort => 'Time';

  @override
  String get provincePickTitle => 'Select province';

  @override
  String get listingLayoutPickTitle => 'Select listing type';

  @override
  String get propertyFormQuickPickSection => 'Province & listing type';

  @override
  String get propertyFormPickEmpty => 'Select';

  @override
  String get propertyFormLinkSection => 'Listing link';

  @override
  String get propertyFormApplyPreview => 'Apply to form';

  @override
  String get propertyFormApplyDone => 'Title and description updated.';

  @override
  String get accountInfoTitle => 'Account information';

  @override
  String get accountInfoSubtitle => 'Manage profile and brand card';

  @override
  String get accountTabPersonal => 'Personal';

  @override
  String get accountTabBrand => 'Brand card';

  @override
  String get brandCardPreview => 'Card preview';

  @override
  String get brandPickTemplate => 'Choose template';

  @override
  String get brandSloganLabel => 'Slogan / tagline';

  @override
  String get brandWebsiteLabel => 'Website';

  @override
  String get signOutSheetTitle => 'Sign out?';

  @override
  String get signOutSheetBody => 'You can sign back in anytime.';

  @override
  String get deleteAccountTitle => 'Delete account';

  @override
  String get deleteAccountDanger => 'Danger zone';

  @override
  String get deleteAccountQuestion =>
      'Are you sure you want to delete your account?';

  @override
  String get deleteAccountWarning =>
      'This cannot be undone. Customers, listings and reminders will be removed.';

  @override
  String get deleteAccountCta => 'I want to delete my account';

  @override
  String get kvkkTitle => 'Privacy & KVKK';

  @override
  String get kvkkSubtitle => 'How can we help?';

  @override
  String get kvkkSafeTitle => 'Your data is safe';

  @override
  String get kvkkSafeBody =>
      'Hestora is committed to protecting your personal data.';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get faqSubtitle => 'Frequently asked questions';

  @override
  String get packagePickTitle => 'Choose plan';

  @override
  String get packagePickSubtitle => 'Pick the plan that fits you';

  @override
  String get packageHeadline => 'Go Premium';

  @override
  String get packageSubline => 'Cancel anytime';

  @override
  String get paymentSummaryTitle => 'Payment summary';

  @override
  String get paymentSummarySubtitle => 'Secure payment';

  @override
  String get profileCreateTitle => 'Create profile';

  @override
  String get profileCreateSubtitle => 'Final step';

  @override
  String get profileCreateHeadline => 'Complete your profile';

  @override
  String get profileCreateSubline => 'Enter your details to get started';

  @override
  String get profileCreateCompleteCta => 'Complete and start';

  @override
  String get profileCreateComingSoon =>
      'This guided profile screen will collect firm details and photos in a future update. You can continue to the app now.';

  @override
  String get kvkkSection1Title => '1. Data controller';

  @override
  String get kvkkSection1Body =>
      'Hestora acts as data controller under applicable privacy laws. Your data is processed to provide the service.';

  @override
  String get kvkkSection2Title => '2. Personal data processed';

  @override
  String get kvkkSection2Body =>
      'Identity, contact, usage and content data you add in the app.';

  @override
  String get kvkkSection3Title => '3. Purposes';

  @override
  String get kvkkSection3Body =>
      'Account management, security, analytics and customer support.';

  @override
  String get kvkkSection4Title => '4. Security';

  @override
  String get kvkkSection4Body =>
      'Technical and organisational measures are applied to protect your data.';

  @override
  String get kvkkSection5Title => '5. Your rights';

  @override
  String get kvkkSection5Body =>
      'Access, rectification, erasure and portability where applicable.';

  @override
  String get kvkkSection6Title => '6. Cookies & tracking';

  @override
  String get kvkkSection6Body =>
      'Essential cookies for authentication; optional analytics if enabled.';

  @override
  String get kvkkFooterContact => 'Questions: support@hestora.com';

  @override
  String get faqQ1 => 'How do I export my data?';

  @override
  String get faqA1 => 'Profile → Account → Export (coming soon).';

  @override
  String get faqQ2 => 'How do I change my plan?';

  @override
  String get faqA2 => 'Open Package selection from billing when available.';

  @override
  String get faqQ3 => 'I forgot my password';

  @override
  String get faqA3 => 'Use Forgot password on the login screen.';

  @override
  String get faqQ4 => 'How does matching work?';

  @override
  String get faqA4 => 'Matches use customer preferences and listing fields.';

  @override
  String get faqQ5 => 'How do I delete my account?';

  @override
  String get faqA5 => 'Profile → Delete account (destructive).';

  @override
  String get faqQ6 => 'Why am I not receiving notifications?';

  @override
  String get faqA6 => 'Check device settings and in-app notification toggles.';

  @override
  String get deleteAccountListTitle => 'Will be removed:';

  @override
  String get deleteAccountList1 => 'All customer records';

  @override
  String get deleteAccountList2 => 'All listing data';

  @override
  String get deleteAccountList3 => 'All reminders and tasks';

  @override
  String get deleteAccountList4 => 'Profile and brand card info';

  @override
  String get deleteAccountList5 => 'Subscription history';

  @override
  String get deleteAccountComingSoon =>
      'Account deletion API is not wired yet.';

  @override
  String get packageTrialBadge => 'Free';

  @override
  String get packageTrialTitle => '1 week trial';

  @override
  String get packageTrialPrice => '₺0 / mo';

  @override
  String get packageTrialDesc => 'Try all features free';

  @override
  String get packageMonthlyTitle => 'Monthly plan';

  @override
  String get packageMonthlyPrice => '₺299 / mo';

  @override
  String get packageMonthlyDesc => 'Flexible monthly billing';

  @override
  String get packageYearlyBadge => 'Best value';

  @override
  String get packageYearlyTitle => 'Yearly plan';

  @override
  String get packageYearlyPrice => '₺199 / mo';

  @override
  String get packageYearlyDesc => 'Save 33% with annual billing';

  @override
  String get packageCta => 'Continue';

  @override
  String get paymentPlanName => 'Yearly plan';

  @override
  String get paymentPlanSub => 'Hestora Premium';

  @override
  String get paymentBestValue => 'Best value';

  @override
  String get paymentLineYear => 'Yearly subscription';

  @override
  String get paymentLineYearValue => '₺2,388';

  @override
  String get paymentLineDiscount => 'Discount (33%)';

  @override
  String get paymentLineDiscountValue => '-₺788';

  @override
  String get paymentTotal => 'Total';

  @override
  String get paymentTotalValue => '₺1,600';

  @override
  String get paymentVatNote => 'VAT included • Billed yearly';

  @override
  String get paymentIncludedTitle => 'Included';

  @override
  String get paymentFeat1 => 'Unlimited customers';

  @override
  String get paymentFeat2 => 'Unlimited listings';

  @override
  String get paymentFeat3 => 'AI-assisted extraction';

  @override
  String get paymentFeat4 => 'Smart reminders';

  @override
  String get paymentFeat5 => 'Advanced analytics';

  @override
  String get paymentFeat6 => 'Priority support';

  @override
  String get paymentGuarantee => '30-day money-back when billing is enabled.';

  @override
  String get paymentProcessingCta => 'Continue to app';

  @override
  String get brandTemplateDarkBlue => 'Dark blue';

  @override
  String get brandTemplateNight => 'Night';

  @override
  String get brandTemplateEmerald => 'Emerald';

  @override
  String get brandTemplateGold => 'Gold';

  @override
  String get brandPreviewName => 'Ahmet Yılmaz';

  @override
  String get brandPreviewRole => 'Real estate consultant';

  @override
  String get brandPreviewSloganPlaceholder => 'Your trusted consultant';

  @override
  String get brandShare => 'Share';

  @override
  String get brandShareSoon => 'Brand card sharing is coming soon.';

  @override
  String get brandCardWatermark => 'HESTORA CRM';

  @override
  String get brandCardQr => 'QR code';
}
