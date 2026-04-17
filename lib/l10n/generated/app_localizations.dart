import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Hestora CRM'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Real estate CRM base app is ready.'**
  String get homeSubtitle;

  /// No description provided for @buildEnvironmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get buildEnvironmentTitle;

  /// No description provided for @flavorDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get flavorDevelopment;

  /// No description provided for @flavorProduction.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get flavorProduction;

  /// No description provided for @supabaseSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Supabase'**
  String get supabaseSectionTitle;

  /// No description provided for @supabaseStatusConnected.
  ///
  /// In en, this message translates to:
  /// **'Supabase: connected'**
  String get supabaseStatusConnected;

  /// No description provided for @supabaseStatusNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Supabase: not configured (set values in .env)'**
  String get supabaseStatusNotConfigured;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get languageTurkish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSectionTitle;

  /// No description provided for @demoSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get demoSectionTitle;

  /// No description provided for @demoSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reusable input'**
  String get demoSectionSubtitle;

  /// No description provided for @demoSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get demoSearchLabel;

  /// No description provided for @demoSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Try Arabic to see RTL…'**
  String get demoSearchHint;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get navCustomers;

  /// No description provided for @navProperties.
  ///
  /// In en, this message translates to:
  /// **'Listings'**
  String get navProperties;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get splashLoading;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksTitle;

  /// No description provided for @tasksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow-ups and internal work'**
  String get tasksSubtitle;

  /// No description provided for @tasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get tasksEmpty;

  /// No description provided for @taskNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get taskNewTitle;

  /// No description provided for @taskFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get taskFieldTitle;

  /// No description provided for @taskFieldDue.
  ///
  /// In en, this message translates to:
  /// **'Due date (optional)'**
  String get taskFieldDue;

  /// No description provided for @taskLinkedCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer (optional)'**
  String get taskLinkedCustomer;

  /// No description provided for @taskLinkedProperty.
  ///
  /// In en, this message translates to:
  /// **'Listing (optional)'**
  String get taskLinkedProperty;

  /// No description provided for @taskNoneSelected.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get taskNoneSelected;

  /// No description provided for @taskMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get taskMarkDone;

  /// No description provided for @taskMarkedDone.
  ///
  /// In en, this message translates to:
  /// **'Task completed'**
  String get taskMarkedDone;

  /// No description provided for @aiExtractWithOpenAi.
  ///
  /// In en, this message translates to:
  /// **'Extract with OpenAI'**
  String get aiExtractWithOpenAi;

  /// No description provided for @aiExtractNeedInput.
  ///
  /// In en, this message translates to:
  /// **'Select an image or paste text first.'**
  String get aiExtractNeedInput;

  /// No description provided for @aiExtractNoApiKey.
  ///
  /// In en, this message translates to:
  /// **'OPENAI_API_KEY is missing. Add it to .env.'**
  String get aiExtractNoApiKey;

  /// No description provided for @aiExtractFailed.
  ///
  /// In en, this message translates to:
  /// **'AI extraction failed'**
  String get aiExtractFailed;

  /// No description provided for @listingImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import from link'**
  String get listingImportTitle;

  /// No description provided for @listingUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Listing URL'**
  String get listingUrlLabel;

  /// No description provided for @listingImportHint.
  ///
  /// In en, this message translates to:
  /// **'Paste a public listing URL'**
  String get listingImportHint;

  /// No description provided for @listingImportAction.
  ///
  /// In en, this message translates to:
  /// **'Fetch preview'**
  String get listingImportAction;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Manage customers in one place'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Body.
  ///
  /// In en, this message translates to:
  /// **'Track leads, notes, budgets and preferences without losing context.'**
  String get onboardingSlide1Body;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Listings that stay organized'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Body.
  ///
  /// In en, this message translates to:
  /// **'Keep sale and rent portfolios structured with search and filters.'**
  String get onboardingSlide2Body;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Tasks and reminders'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Body.
  ///
  /// In en, this message translates to:
  /// **'Never miss a follow-up. Link work to people and properties.'**
  String get onboardingSlide3Body;

  /// No description provided for @welcomeShort.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeShort;

  /// No description provided for @dashboardHeadline.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started with Hestora'**
  String get dashboardHeadline;

  /// No description provided for @heroCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage everything from one place'**
  String get heroCardTitle;

  /// No description provided for @heroCardBody.
  ///
  /// In en, this message translates to:
  /// **'You can start managing your customers, portfolios and daily tasks in a single app.'**
  String get heroCardBody;

  /// No description provided for @ctaAddFirstCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add your first customer'**
  String get ctaAddFirstCustomer;

  /// No description provided for @ctaAddListing.
  ///
  /// In en, this message translates to:
  /// **'Add listing'**
  String get ctaAddListing;

  /// No description provided for @ctaReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get ctaReminder;

  /// No description provided for @fabTip.
  ///
  /// In en, this message translates to:
  /// **'You can quickly start actions with the + button in the center.'**
  String get fabTip;

  /// No description provided for @customersTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersTitle;

  /// No description provided for @customersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} customers saved'**
  String customersSubtitle(int count);

  /// No description provided for @propertiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Listings'**
  String get propertiesTitle;

  /// No description provided for @propertiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} customers saved'**
  String propertiesSubtitle(int count);

  /// No description provided for @searchCustomersHint.
  ///
  /// In en, this message translates to:
  /// **'Search customers (name, phone, notes)'**
  String get searchCustomersHint;

  /// No description provided for @customersMatchesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} matches'**
  String customersMatchesCount(int count);

  /// No description provided for @chipBuyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get chipBuyer;

  /// No description provided for @chipTenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get chipTenant;

  /// No description provided for @chipSeller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get chipSeller;

  /// No description provided for @chipLandlord.
  ///
  /// In en, this message translates to:
  /// **'Landlord'**
  String get chipLandlord;

  /// No description provided for @customersFilterTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get customersFilterTooltip;

  /// No description provided for @customersSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get customersSortTitle;

  /// No description provided for @customersSortNameAsc.
  ///
  /// In en, this message translates to:
  /// **'Name (A–Z)'**
  String get customersSortNameAsc;

  /// No description provided for @customersSortNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Name (Z–A)'**
  String get customersSortNameDesc;

  /// No description provided for @customersFilteredEmpty.
  ///
  /// In en, this message translates to:
  /// **'No results for this filter or search.'**
  String get customersFilteredEmpty;

  /// No description provided for @customersFilteredEmptyClear.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get customersFilteredEmptyClear;

  /// No description provided for @searchListingsHint.
  ///
  /// In en, this message translates to:
  /// **'Search listings (location, price, type)'**
  String get searchListingsHint;

  /// No description provided for @chipAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get chipAll;

  /// No description provided for @chipSale.
  ///
  /// In en, this message translates to:
  /// **'For sale'**
  String get chipSale;

  /// No description provided for @chipRent.
  ///
  /// In en, this message translates to:
  /// **'For rent'**
  String get chipRent;

  /// No description provided for @chipActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get chipActive;

  /// No description provided for @chipPassive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get chipPassive;

  /// No description provided for @ctaAddFirstListing.
  ///
  /// In en, this message translates to:
  /// **'Add your first listing'**
  String get ctaAddFirstListing;

  /// No description provided for @emptyCustomersTitle.
  ///
  /// In en, this message translates to:
  /// **'No customers yet'**
  String get emptyCustomersTitle;

  /// No description provided for @emptyCustomersBody.
  ///
  /// In en, this message translates to:
  /// **'Add a customer to see them listed here.'**
  String get emptyCustomersBody;

  /// No description provided for @emptyPropertiesTitle.
  ///
  /// In en, this message translates to:
  /// **'No listings yet'**
  String get emptyPropertiesTitle;

  /// No description provided for @emptyPropertiesBody.
  ///
  /// In en, this message translates to:
  /// **'Create a listing to build your portfolio.'**
  String get emptyPropertiesBody;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileRoleConsultant.
  ///
  /// In en, this message translates to:
  /// **'Real estate consultant'**
  String get profileRoleConsultant;

  /// No description provided for @profileStatsLine.
  ///
  /// In en, this message translates to:
  /// **'{listingCount} listings • {customerCount} customers'**
  String profileStatsLine(int listingCount, int customerCount);

  /// No description provided for @profileStatActiveListings.
  ///
  /// In en, this message translates to:
  /// **'Active listings'**
  String get profileStatActiveListings;

  /// No description provided for @profileStatTotalCustomers.
  ///
  /// In en, this message translates to:
  /// **'Total customers'**
  String get profileStatTotalCustomers;

  /// No description provided for @profileStatOpenTasks.
  ///
  /// In en, this message translates to:
  /// **'Open tasks'**
  String get profileStatOpenTasks;

  /// No description provided for @profileMenuAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileMenuAccount;

  /// No description provided for @accountSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account settings'**
  String get accountSettingsTitle;

  /// No description provided for @accountProfileEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile & email'**
  String get accountProfileEditorTitle;

  /// No description provided for @accountHubProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile & email'**
  String get accountHubProfileTitle;

  /// No description provided for @accountHubProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Name, photo and email address'**
  String get accountHubProfileSubtitle;

  /// No description provided for @accountHubChangePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get accountHubChangePasswordTitle;

  /// No description provided for @accountHubChangePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your sign-in password'**
  String get accountHubChangePasswordSubtitle;

  /// No description provided for @accountHubChangeEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get accountHubChangeEmailTitle;

  /// No description provided for @accountHubChangeEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update the address you use to sign in'**
  String get accountHubChangeEmailSubtitle;

  /// No description provided for @accountHubIntro.
  ///
  /// In en, this message translates to:
  /// **'Manage your profile, password and email.'**
  String get accountHubIntro;

  /// No description provided for @profileDisplayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get profileDisplayNameLabel;

  /// No description provided for @profileMenuNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileMenuNotifications;

  /// No description provided for @profileMenuAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics & reports'**
  String get profileMenuAnalytics;

  /// No description provided for @profileMenuSupport.
  ///
  /// In en, this message translates to:
  /// **'Support / help'**
  String get profileMenuSupport;

  /// No description provided for @profileAppVersion.
  ///
  /// In en, this message translates to:
  /// **'Hestora CRM v1.0.0'**
  String get profileAppVersion;

  /// No description provided for @profileAccountSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileAccountSheetTitle;

  /// No description provided for @profileMoreMenu.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get profileMoreMenu;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @forgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSubmit;

  /// No description provided for @registerSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerSubmit;

  /// No description provided for @forgotSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get forgotSubmit;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account? Register'**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get haveAccount;

  /// No description provided for @forgotLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotLink;

  /// No description provided for @authErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Check your details and try again.'**
  String get authErrorGeneric;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get validationEmail;

  /// No description provided for @validationPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters'**
  String get validationPasswordLength;

  /// No description provided for @validationPasswordMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordMatch;

  /// No description provided for @quickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActionsTitle;

  /// No description provided for @quickAddCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get quickAddCustomer;

  /// No description provided for @quickAddProperty.
  ///
  /// In en, this message translates to:
  /// **'Add listing'**
  String get quickAddProperty;

  /// No description provided for @quickAddReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder (soon)'**
  String get quickAddReminder;

  /// No description provided for @quickAiImportCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer from screenshot'**
  String get quickAiImportCustomer;

  /// No description provided for @customerCreateMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you want to add the customer?'**
  String get customerCreateMethodTitle;

  /// No description provided for @customerCreateOptionManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get customerCreateOptionManual;

  /// No description provided for @customerCreateOptionManualBody.
  ///
  /// In en, this message translates to:
  /// **'Open the classic form and enter the customer details yourself.'**
  String get customerCreateOptionManualBody;

  /// No description provided for @customerCreateOptionAi.
  ///
  /// In en, this message translates to:
  /// **'With AI support'**
  String get customerCreateOptionAi;

  /// No description provided for @customerCreateOptionAiBody.
  ///
  /// In en, this message translates to:
  /// **'Pick a screenshot and quickly create the customer from detected name and phone.'**
  String get customerCreateOptionAiBody;

  /// No description provided for @demoModeBanner.
  ///
  /// In en, this message translates to:
  /// **'Demo mode: configure Supabase in .env to enable cloud sync and sign-in.'**
  String get demoModeBanner;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @customerDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerDetailTitle;

  /// No description provided for @propertyDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Listing'**
  String get propertyDetailTitle;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get fieldPhone;

  /// No description provided for @fieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get fieldNotes;

  /// No description provided for @createCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'New customer'**
  String get createCustomerTitle;

  /// No description provided for @createPropertyTitle.
  ///
  /// In en, this message translates to:
  /// **'New listing'**
  String get createPropertyTitle;

  /// No description provided for @listingTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get listingTitleLabel;

  /// No description provided for @listingTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Listing type'**
  String get listingTypeLabel;

  /// No description provided for @listingPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get listingPriceLabel;

  /// No description provided for @listingLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get listingLocationLabel;

  /// No description provided for @listingDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get listingDescriptionLabel;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created. Check your inbox if email confirmation is enabled.'**
  String get registerSuccess;

  /// No description provided for @resetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'If this email exists, a reset link was sent.'**
  String get resetEmailSent;

  /// No description provided for @fieldRoomCountShort.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get fieldRoomCountShort;

  /// No description provided for @fieldBathroomCountShort.
  ///
  /// In en, this message translates to:
  /// **'Baths'**
  String get fieldBathroomCountShort;

  /// No description provided for @fieldAreaSqmShort.
  ///
  /// In en, this message translates to:
  /// **'Area (m²)'**
  String get fieldAreaSqmShort;

  /// No description provided for @ogFetchError.
  ///
  /// In en, this message translates to:
  /// **'Could not load page metadata. Try another URL or fill manually.'**
  String get ogFetchError;

  /// No description provided for @ogPartialData.
  ///
  /// In en, this message translates to:
  /// **'Some fields may be empty — you can edit before saving.'**
  String get ogPartialData;

  /// No description provided for @matchesForCustomer.
  ///
  /// In en, this message translates to:
  /// **'Matching listings'**
  String get matchesForCustomer;

  /// No description provided for @matchesForProperty.
  ///
  /// In en, this message translates to:
  /// **'Matching customers'**
  String get matchesForProperty;

  /// No description provided for @matchScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'{score}% match'**
  String matchScoreLabel(String score);

  /// No description provided for @matchStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong match'**
  String get matchStrong;

  /// No description provided for @syncMatchesToCloud.
  ///
  /// In en, this message translates to:
  /// **'Save matches to cloud'**
  String get syncMatchesToCloud;

  /// No description provided for @shareClicksTotal.
  ///
  /// In en, this message translates to:
  /// **'Share link clicks (total)'**
  String get shareClicksTotal;

  /// No description provided for @redirectLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Tracking link'**
  String get redirectLinkTitle;

  /// No description provided for @createTrackingLink.
  ///
  /// In en, this message translates to:
  /// **'Create tracking link'**
  String get createTrackingLink;

  /// No description provided for @copyTrackingLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyTrackingLink;

  /// No description provided for @trackingLinkHelp.
  ///
  /// In en, this message translates to:
  /// **'Opens the original listing URL and increments the total click counter (no personal data stored). Deploy the Edge Function in Supabase.'**
  String get trackingLinkHelp;

  /// No description provided for @shareCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Share card'**
  String get shareCardTitle;

  /// No description provided for @templateStory.
  ///
  /// In en, this message translates to:
  /// **'Story 9:16'**
  String get templateStory;

  /// No description provided for @templateSquare.
  ///
  /// In en, this message translates to:
  /// **'Square 1:1'**
  String get templateSquare;

  /// No description provided for @exportPng.
  ///
  /// In en, this message translates to:
  /// **'Export PNG'**
  String get exportPng;

  /// No description provided for @shareCardPickTheme.
  ///
  /// In en, this message translates to:
  /// **'Card theme'**
  String get shareCardPickTheme;

  /// No description provided for @shareCardAllThemesSample.
  ///
  /// In en, this message translates to:
  /// **'All themes (sample preview)'**
  String get shareCardAllThemesSample;

  /// No description provided for @shareCardMockOverlay.
  ///
  /// In en, this message translates to:
  /// **'Use sample data in main preview'**
  String get shareCardMockOverlay;

  /// No description provided for @shareCardBathroomsShort.
  ///
  /// In en, this message translates to:
  /// **'{count} bath'**
  String shareCardBathroomsShort(int count);

  /// No description provided for @shareCardAreaSqmShort.
  ///
  /// In en, this message translates to:
  /// **'{sqm} m²'**
  String shareCardAreaSqmShort(String sqm);

  /// No description provided for @shareCardTuneListingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Adjust photo framing'**
  String get shareCardTuneListingPhoto;

  /// No description provided for @shareCardAdjustPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Listing photo framing'**
  String get shareCardAdjustPhotoTitle;

  /// No description provided for @shareCardAdjustPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Sliders change which part of the photo stays visible with cover fit. Quick tiles jump to common crops.'**
  String get shareCardAdjustPhotoHint;

  /// No description provided for @shareCardAdjustPhotoHorizontal.
  ///
  /// In en, this message translates to:
  /// **'Horizontal'**
  String get shareCardAdjustPhotoHorizontal;

  /// No description provided for @shareCardAdjustPhotoVertical.
  ///
  /// In en, this message translates to:
  /// **'Vertical'**
  String get shareCardAdjustPhotoVertical;

  /// No description provided for @shareCardAdjustPhotoPresets.
  ///
  /// In en, this message translates to:
  /// **'Quick positions'**
  String get shareCardAdjustPhotoPresets;

  /// No description provided for @shareCardAdjustPhotoReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get shareCardAdjustPhotoReset;

  /// No description provided for @shareCardAdjustPhotoDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get shareCardAdjustPhotoDone;

  /// No description provided for @shareCard.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareCard;

  /// No description provided for @aiImportTitle.
  ///
  /// In en, this message translates to:
  /// **'From screenshot'**
  String get aiImportTitle;

  /// No description provided for @aiImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a WhatsApp or chat screenshot with the contact info. We detect the phone and name, then create the customer with those fields only.'**
  String get aiImportSubtitle;

  /// No description provided for @aiPickGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose image'**
  String get aiPickGallery;

  /// No description provided for @aiSuggestedPhone.
  ///
  /// In en, this message translates to:
  /// **'Detected phone'**
  String get aiSuggestedPhone;

  /// No description provided for @aiOpenForm.
  ///
  /// In en, this message translates to:
  /// **'Continue to customer form'**
  String get aiOpenForm;

  /// No description provided for @aiDetectedNameHint.
  ///
  /// In en, this message translates to:
  /// **'If no name is detected, the customer will be created as Unknown customer.'**
  String get aiDetectedNameHint;

  /// No description provided for @aiCreateCustomer.
  ///
  /// In en, this message translates to:
  /// **'Create customer'**
  String get aiCreateCustomer;

  /// No description provided for @aiCreateNeedsPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone number could be detected. Try another screenshot or edit the phone field.'**
  String get aiCreateNeedsPhone;

  /// No description provided for @aiCustomerCreated.
  ///
  /// In en, this message translates to:
  /// **'Customer created.'**
  String get aiCustomerCreated;

  /// No description provided for @listingUrlOpen.
  ///
  /// In en, this message translates to:
  /// **'Open original listing'**
  String get listingUrlOpen;

  /// No description provided for @fieldListingIntent.
  ///
  /// In en, this message translates to:
  /// **'Intent'**
  String get fieldListingIntent;

  /// No description provided for @fieldPreferredLocation.
  ///
  /// In en, this message translates to:
  /// **'Preferred location'**
  String get fieldPreferredLocation;

  /// No description provided for @fieldBudgetMin.
  ///
  /// In en, this message translates to:
  /// **'Budget min'**
  String get fieldBudgetMin;

  /// No description provided for @fieldBudgetMax.
  ///
  /// In en, this message translates to:
  /// **'Budget max'**
  String get fieldBudgetMax;

  /// No description provided for @fieldRoomCount.
  ///
  /// In en, this message translates to:
  /// **'Room count'**
  String get fieldRoomCount;

  /// No description provided for @fieldAreaMin.
  ///
  /// In en, this message translates to:
  /// **'Min area (m²)'**
  String get fieldAreaMin;

  /// No description provided for @fieldAreaMax.
  ///
  /// In en, this message translates to:
  /// **'Max area (m²)'**
  String get fieldAreaMax;

  /// No description provided for @intentNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get intentNotSet;

  /// No description provided for @loginFooterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginFooterQuestion;

  /// No description provided for @registerFooterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get registerFooterQuestion;

  /// No description provided for @loginWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcomeTitle;

  /// No description provided for @loginWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to your account'**
  String get loginWelcomeSubtitle;

  /// No description provided for @registerHeadline.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerHeadline;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join the premium CRM'**
  String get registerSubtitle;

  /// No description provided for @fieldFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fieldFullName;

  /// No description provided for @forgotHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Password reset'**
  String get forgotHeaderSubtitle;

  /// No description provided for @forgotHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get forgotHeroTitle;

  /// No description provided for @forgotHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to reset your password.'**
  String get forgotHeroBody;

  /// No description provided for @forgotEmailLabelCaps.
  ///
  /// In en, this message translates to:
  /// **'YOUR EMAIL ADDRESS'**
  String get forgotEmailLabelCaps;

  /// No description provided for @forgotRememberedLogin.
  ///
  /// In en, this message translates to:
  /// **'Remembered your password?'**
  String get forgotRememberedLogin;

  /// No description provided for @passwordUpdatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdatedTitle;

  /// No description provided for @passwordUpdatedBody.
  ///
  /// In en, this message translates to:
  /// **'You can now sign in with your new password.'**
  String get passwordUpdatedBody;

  /// No description provided for @passwordUpdatedB1.
  ///
  /// In en, this message translates to:
  /// **'Your password was changed successfully.'**
  String get passwordUpdatedB1;

  /// No description provided for @passwordUpdatedB2.
  ///
  /// In en, this message translates to:
  /// **'Sessions on other devices were closed.'**
  String get passwordUpdatedB2;

  /// No description provided for @passwordUpdatedB3.
  ///
  /// In en, this message translates to:
  /// **'Your account is more secure.'**
  String get passwordUpdatedB3;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to login'**
  String get goToLogin;

  /// No description provided for @updatePasswordScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Create new password'**
  String get updatePasswordScreenTitle;

  /// No description provided for @updatePasswordScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Password renewal'**
  String get updatePasswordScreenSubtitle;

  /// No description provided for @updatePasswordHero.
  ///
  /// In en, this message translates to:
  /// **'Set a new password for your account.'**
  String get updatePasswordHero;

  /// No description provided for @updatePasswordCta.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get updatePasswordCta;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @repeatNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat new password'**
  String get repeatNewPasswordLabel;

  /// No description provided for @passwordReqTitle.
  ///
  /// In en, this message translates to:
  /// **'Password requirements'**
  String get passwordReqTitle;

  /// No description provided for @reqMin8.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get reqMin8;

  /// No description provided for @reqOneNumber.
  ///
  /// In en, this message translates to:
  /// **'At least 1 number'**
  String get reqOneNumber;

  /// No description provided for @reqOneUpper.
  ///
  /// In en, this message translates to:
  /// **'At least 1 uppercase letter'**
  String get reqOneUpper;

  /// No description provided for @strengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get strengthStrong;

  /// No description provided for @strengthMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get strengthMedium;

  /// No description provided for @strengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get strengthWeak;

  /// No description provided for @authKvkk.
  ///
  /// In en, this message translates to:
  /// **'I have read and accept the disclosure text.'**
  String get authKvkk;

  /// No description provided for @authKvkkLink.
  ///
  /// In en, this message translates to:
  /// **'KVKK disclosure text'**
  String get authKvkkLink;

  /// No description provided for @authKvkkDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Disclosure text'**
  String get authKvkkDialogTitle;

  /// No description provided for @authKvkkDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Your personal data is processed under applicable privacy laws. Replace this text with your legal copy.'**
  String get authKvkkDialogBody;

  /// No description provided for @emailLabelCaps.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get emailLabelCaps;

  /// No description provided for @passwordLabelCaps.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get passwordLabelCaps;

  /// No description provided for @registerPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get registerPasswordHint;

  /// No description provided for @validationPasswordLength8.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters'**
  String get validationPasswordLength8;

  /// No description provided for @profileNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get profileNotificationsTitle;

  /// No description provided for @profileNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose what you want to be notified about.'**
  String get profileNotificationsSubtitle;

  /// No description provided for @profileNotifyMatches.
  ///
  /// In en, this message translates to:
  /// **'Match suggestions'**
  String get profileNotifyMatches;

  /// No description provided for @profileNotifyMatchesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When a new compatible listing or customer appears.'**
  String get profileNotifyMatchesSubtitle;

  /// No description provided for @profileNotifyTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks and reminders'**
  String get profileNotifyTasks;

  /// No description provided for @profileNotifyTasksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Due dates and new tasks.'**
  String get profileNotifyTasksSubtitle;

  /// No description provided for @profileNotifyMarketing.
  ///
  /// In en, this message translates to:
  /// **'Product updates'**
  String get profileNotifyMarketing;

  /// No description provided for @profileNotifyMarketingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New features and tips (rarely).'**
  String get profileNotifyMarketingSubtitle;

  /// No description provided for @profileAnalyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics and reports'**
  String get profileAnalyticsTitle;

  /// No description provided for @profileAnalyticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Summary metrics — detailed reports coming soon.'**
  String get profileAnalyticsSubtitle;

  /// No description provided for @profileAnalyticsCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get profileAnalyticsCustomers;

  /// No description provided for @profileAnalyticsListings.
  ///
  /// In en, this message translates to:
  /// **'Listings'**
  String get profileAnalyticsListings;

  /// No description provided for @profileAnalyticsTasksOpen.
  ///
  /// In en, this message translates to:
  /// **'Open tasks'**
  String get profileAnalyticsTasksOpen;

  /// No description provided for @profileAnalyticsShareClicks.
  ///
  /// In en, this message translates to:
  /// **'Tracking link clicks'**
  String get profileAnalyticsShareClicks;

  /// No description provided for @profileSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support and help'**
  String get profileSupportTitle;

  /// No description provided for @profileSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Contact and frequently asked questions.'**
  String get profileSupportSubtitle;

  /// No description provided for @profileSupportFaqHeading.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get profileSupportFaqHeading;

  /// No description provided for @profileSupportEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'support@hestora.app'**
  String get profileSupportEmailAddress;

  /// No description provided for @profileSupportEmailCta.
  ///
  /// In en, this message translates to:
  /// **'Email us'**
  String get profileSupportEmailCta;

  /// No description provided for @profileSupportEmailSubject.
  ///
  /// In en, this message translates to:
  /// **'Hestora CRM support'**
  String get profileSupportEmailSubject;

  /// No description provided for @profileSupportFaq1Title.
  ///
  /// In en, this message translates to:
  /// **'How does the tracking link work?'**
  String get profileSupportFaq1Title;

  /// No description provided for @profileSupportFaq1Body.
  ///
  /// In en, this message translates to:
  /// **'Create it from a listing detail and share it. When opened, the original listing loads and the total click counter increases.'**
  String get profileSupportFaq1Body;

  /// No description provided for @profileSupportFaq2Title.
  ///
  /// In en, this message translates to:
  /// **'Where is my data stored?'**
  String get profileSupportFaq2Title;

  /// No description provided for @profileSupportFaq2Body.
  ///
  /// In en, this message translates to:
  /// **'In Supabase under your account; only you can access your rows (enforced by RLS).'**
  String get profileSupportFaq2Body;

  /// No description provided for @listingPhotosSection.
  ///
  /// In en, this message translates to:
  /// **'Listing photos'**
  String get listingPhotosSection;

  /// No description provided for @listingPhotosHint.
  ///
  /// In en, this message translates to:
  /// **'Up to 12 images. JPEG, PNG, or WebP.'**
  String get listingPhotosHint;

  /// No description provided for @addListingPhotos.
  ///
  /// In en, this message translates to:
  /// **'Choose photos'**
  String get addListingPhotos;

  /// No description provided for @listingGalleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get listingGalleryTitle;

  /// No description provided for @profileChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change profile photo'**
  String get profileChangePhoto;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated'**
  String get profilePhotoUpdated;

  /// No description provided for @propertyEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit listing'**
  String get propertyEditTitle;

  /// No description provided for @propertyEditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update information and save'**
  String get propertyEditSubtitle;

  /// No description provided for @propertySectionBasics.
  ///
  /// In en, this message translates to:
  /// **'Basic information'**
  String get propertySectionBasics;

  /// No description provided for @propertySectionFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get propertySectionFeatures;

  /// No description provided for @propertySectionMedia.
  ///
  /// In en, this message translates to:
  /// **'Media and link'**
  String get propertySectionMedia;

  /// No description provided for @listingExistingPhotos.
  ///
  /// In en, this message translates to:
  /// **'Current photos'**
  String get listingExistingPhotos;

  /// No description provided for @propertyDetailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Property detail'**
  String get propertyDetailSubtitle;

  /// No description provided for @tabPropertyInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get tabPropertyInfo;

  /// No description provided for @tabPropertyCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get tabPropertyCustomers;

  /// No description provided for @tabPropertyActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get tabPropertyActions;

  /// No description provided for @propertyFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Property features'**
  String get propertyFeaturesTitle;

  /// No description provided for @featureRoom.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get featureRoom;

  /// No description provided for @featureArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get featureArea;

  /// No description provided for @featureFloor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get featureFloor;

  /// No description provided for @featureAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get featureAge;

  /// No description provided for @featureParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get featureParking;

  /// No description provided for @featureHeating.
  ///
  /// In en, this message translates to:
  /// **'Heating'**
  String get featureHeating;

  /// No description provided for @featureUnknown.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get featureUnknown;

  /// No description provided for @markAsSold.
  ///
  /// In en, this message translates to:
  /// **'Mark as sold'**
  String get markAsSold;

  /// No description provided for @customerDetailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customer detail'**
  String get customerDetailSubtitle;

  /// No description provided for @searchCriteriaTitle.
  ///
  /// In en, this message translates to:
  /// **'Search criteria'**
  String get searchCriteriaTitle;

  /// No description provided for @tabCustomerHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tabCustomerHistory;

  /// No description provided for @tabCustomerNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get tabCustomerNotes;

  /// No description provided for @tabCustomerMatching.
  ///
  /// In en, this message translates to:
  /// **'Matching'**
  String get tabCustomerMatching;

  /// No description provided for @activityHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity history'**
  String get activityHistoryTitle;

  /// No description provided for @activityRecordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} records'**
  String activityRecordsCount(int count);

  /// No description provided for @customerBadgeBuyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get customerBadgeBuyer;

  /// No description provided for @customerBadgeSeller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get customerBadgeSeller;

  /// No description provided for @customerCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get customerCall;

  /// No description provided for @customerWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get customerWhatsapp;

  /// No description provided for @customerMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get customerMessage;

  /// No description provided for @localeRegionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language & region'**
  String get localeRegionTitle;

  /// No description provided for @localeRegionSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get localeRegionSavedTitle;

  /// No description provided for @localeRegionSavedBody.
  ///
  /// In en, this message translates to:
  /// **'Your language and region settings were saved. You can change them anytime from your profile.'**
  String get localeRegionSavedBody;

  /// No description provided for @localeRegionIntro.
  ///
  /// In en, this message translates to:
  /// **'Review app language and region. You can change them later if you want.'**
  String get localeRegionIntro;

  /// No description provided for @fieldRegionCountry.
  ///
  /// In en, this message translates to:
  /// **'Region / country'**
  String get fieldRegionCountry;

  /// No description provided for @fieldCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get fieldCurrency;

  /// No description provided for @currencyTry.
  ///
  /// In en, this message translates to:
  /// **'TRY — Turkish Lira'**
  String get currencyTry;

  /// No description provided for @regionTurkey.
  ///
  /// In en, this message translates to:
  /// **'Turkey'**
  String get regionTurkey;

  /// No description provided for @regionSettingHint.
  ///
  /// In en, this message translates to:
  /// **'Region setting'**
  String get regionSettingHint;

  /// No description provided for @currencySettingHint.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencySettingHint;

  /// No description provided for @appLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguageHint;

  /// No description provided for @editCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit customer'**
  String get editCustomerTitle;

  /// No description provided for @customerNoLastCallInfo.
  ///
  /// In en, this message translates to:
  /// **'No call log yet'**
  String get customerNoLastCallInfo;

  /// No description provided for @customerLastActivitySummary.
  ///
  /// In en, this message translates to:
  /// **'Last contact: {when}'**
  String customerLastActivitySummary(String when);

  /// No description provided for @customerLastActivityJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get customerLastActivityJustNow;

  /// No description provided for @customerLastActivityMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String customerLastActivityMinutesAgo(int count);

  /// No description provided for @customerLastActivityHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String customerLastActivityHoursAgo(int count);

  /// No description provided for @customerLastActivityDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String customerLastActivityDaysAgo(int count);

  /// No description provided for @customerUrgentTag.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get customerUrgentTag;

  /// No description provided for @criteriaLabelLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get criteriaLabelLocation;

  /// No description provided for @criteriaLabelBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get criteriaLabelBudget;

  /// No description provided for @criteriaLabelRooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get criteriaLabelRooms;

  /// No description provided for @criteriaLabelArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get criteriaLabelArea;

  /// No description provided for @customerAreaAtLeast.
  ///
  /// In en, this message translates to:
  /// **'{sqm} m² and up'**
  String customerAreaAtLeast(String sqm);

  /// No description provided for @customerQuickAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add quick note'**
  String get customerQuickAddNote;

  /// No description provided for @customerViewListingDetail.
  ///
  /// In en, this message translates to:
  /// **'View detail'**
  String get customerViewListingDetail;

  /// No description provided for @customerSendToClient.
  ///
  /// In en, this message translates to:
  /// **'Send to customer'**
  String get customerSendToClient;

  /// No description provided for @customerStrongMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Matches over {threshold}%'**
  String customerStrongMatchesTitle(int threshold);

  /// No description provided for @customerListingCountBadge.
  ///
  /// In en, this message translates to:
  /// **'{count} listings'**
  String customerListingCountBadge(int count);

  /// No description provided for @customerActivityNoteAdded.
  ///
  /// In en, this message translates to:
  /// **'Note added'**
  String get customerActivityNoteAdded;

  /// No description provided for @customerActivityRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get customerActivityRegistration;

  /// No description provided for @customerActivityRegistrationBody.
  ///
  /// In en, this message translates to:
  /// **'Customer card was created.'**
  String get customerActivityRegistrationBody;

  /// No description provided for @customerActivityTimeUnknown.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get customerActivityTimeUnknown;

  /// No description provided for @customerNotesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notes yet.'**
  String get customerNotesEmpty;

  /// No description provided for @customerBadgeTenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get customerBadgeTenant;

  /// No description provided for @propertySuitableCustomersTitle.
  ///
  /// In en, this message translates to:
  /// **'Suitable customers'**
  String get propertySuitableCustomersTitle;

  /// No description provided for @propertySuitableCustomerCountBadge.
  ///
  /// In en, this message translates to:
  /// **'{count} customers'**
  String propertySuitableCustomerCountBadge(int count);

  /// No description provided for @propertyCustomerSeekingBoth.
  ///
  /// In en, this message translates to:
  /// **'Seeking {rooms} in {location}'**
  String propertyCustomerSeekingBoth(String location, String rooms);

  /// No description provided for @propertyCustomerSeekingRoomsOnly.
  ///
  /// In en, this message translates to:
  /// **'Seeking {rooms}'**
  String propertyCustomerSeekingRoomsOnly(String rooms);

  /// No description provided for @propertyCustomerSeekingLocationOnly.
  ///
  /// In en, this message translates to:
  /// **'Looking in {location}'**
  String propertyCustomerSeekingLocationOnly(String location);

  /// No description provided for @propertyCustomerSeekingUnknown.
  ///
  /// In en, this message translates to:
  /// **'No preference details'**
  String get propertyCustomerSeekingUnknown;

  /// No description provided for @propertyListingSend.
  ///
  /// In en, this message translates to:
  /// **'Send listing'**
  String get propertyListingSend;

  /// No description provided for @propertyQuickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get propertyQuickActionsTitle;

  /// No description provided for @propertyActionSendCustomersTitle.
  ///
  /// In en, this message translates to:
  /// **'Send to customers'**
  String get propertyActionSendCustomersTitle;

  /// No description provided for @propertyActionSendCustomersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Forward this listing to suitable customers'**
  String get propertyActionSendCustomersSubtitle;

  /// No description provided for @propertyActionShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get propertyActionShareTitle;

  /// No description provided for @propertyActionShareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share as link or image'**
  String get propertyActionShareSubtitle;

  /// No description provided for @propertyActionEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get propertyActionEditTitle;

  /// No description provided for @propertyActionEditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update listing details'**
  String get propertyActionEditSubtitle;

  /// No description provided for @propertyActionNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Add note / reminder'**
  String get propertyActionNoteTitle;

  /// No description provided for @propertyActionNoteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a note or task for this listing'**
  String get propertyActionNoteSubtitle;

  /// No description provided for @propertyActionSyncMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Save matches to cloud'**
  String get propertyActionSyncMatchesTitle;

  /// No description provided for @propertyActionSyncMatchesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sync customer matches for this listing'**
  String get propertyActionSyncMatchesSubtitle;

  /// No description provided for @propertyNoteComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature is coming soon.'**
  String get propertyNoteComingSoon;

  /// No description provided for @validationUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid URL'**
  String get validationUrl;

  /// No description provided for @taskEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get taskEditTitle;

  /// No description provided for @taskFieldPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get taskFieldPriority;

  /// No description provided for @taskFieldStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get taskFieldStatus;

  /// No description provided for @taskPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get taskPriorityLow;

  /// No description provided for @taskPriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get taskPriorityNormal;

  /// No description provided for @taskPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get taskPriorityHigh;

  /// No description provided for @taskPriorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get taskPriorityUrgent;

  /// No description provided for @taskStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get taskStatusOpen;

  /// No description provided for @taskStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get taskStatusDone;

  /// No description provided for @taskStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get taskStatusClosed;

  /// No description provided for @taskClearDueDate.
  ///
  /// In en, this message translates to:
  /// **'Clear due date'**
  String get taskClearDueDate;

  /// No description provided for @taskLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load task'**
  String get taskLoadErrorTitle;

  /// No description provided for @taskNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Task not found'**
  String get taskNotFoundTitle;

  /// No description provided for @taskNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'This task does not exist or you no longer have access to it.'**
  String get taskNotFoundBody;

  /// No description provided for @taskRetryLoad.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get taskRetryLoad;

  /// No description provided for @taskNoDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get taskNoDueDate;

  /// No description provided for @customerActivityTaskLinked.
  ///
  /// In en, this message translates to:
  /// **'Task linked'**
  String get customerActivityTaskLinked;

  /// No description provided for @customerActivityPropertyMatched.
  ///
  /// In en, this message translates to:
  /// **'Property matched'**
  String get customerActivityPropertyMatched;

  /// No description provided for @customerActivityPropertyShared.
  ///
  /// In en, this message translates to:
  /// **'Property shared'**
  String get customerActivityPropertyShared;

  /// No description provided for @customerActivityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No activity has been recorded yet.'**
  String get customerActivityEmpty;

  /// No description provided for @customerNoteInputHint.
  ///
  /// In en, this message translates to:
  /// **'Add a quick follow-up note'**
  String get customerNoteInputHint;

  /// No description provided for @customerSummaryNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer summary'**
  String get customerSummaryNoteTitle;

  /// No description provided for @customerUnknownName.
  ///
  /// In en, this message translates to:
  /// **'Unknown customer'**
  String get customerUnknownName;

  /// No description provided for @customerImportContacts.
  ///
  /// In en, this message translates to:
  /// **'Import from contacts'**
  String get customerImportContacts;

  /// No description provided for @customerImportPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Contacts permission was denied.'**
  String get customerImportPermissionDenied;

  /// No description provided for @customerImportNoContacts.
  ///
  /// In en, this message translates to:
  /// **'No contacts were found on this device.'**
  String get customerImportNoContacts;

  /// No description provided for @customerImportUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Contacts import is only available on supported mobile devices.'**
  String get customerImportUnsupported;

  /// No description provided for @customerImportPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a contact'**
  String get customerImportPickerTitle;

  /// No description provided for @listingImportFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue manually'**
  String get listingImportFallbackTitle;

  /// No description provided for @listingImportFallbackBody.
  ///
  /// In en, this message translates to:
  /// **'Preview data is missing or blocked. You can continue and complete the listing manually.'**
  String get listingImportFallbackBody;

  /// No description provided for @listingImportContinueManual.
  ///
  /// In en, this message translates to:
  /// **'Continue with manual form'**
  String get listingImportContinueManual;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
