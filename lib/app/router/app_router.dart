import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai_customer/presentation/ai_customer_import_page.dart';
import '../../features/auth/presentation/forgot_password_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/password_updated_page.dart';
import '../../features/auth/presentation/post_verify_checkout_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/auth/presentation/update_password_page.dart';
import '../../features/customers/domain/customer_form_prefill.dart';
import '../../features/customers/presentation/customer_detail_page.dart';
import '../../features/customers/presentation/customer_form_page.dart';
import '../../features/customers/presentation/customers_list_page.dart';
import '../../features/dashboard_home/presentation/dashboard_home_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/profile/presentation/profile_analytics_page.dart';
import '../../features/profile/presentation/profile_notifications_page.dart';
import '../../features/profile/presentation/account_profile_editor_page.dart';
import '../../features/profile/presentation/account_settings_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/profile/presentation/locale_region_settings_page.dart';
import '../../features/profile/presentation/figma_extra_pages.dart';
import '../../features/profile/presentation/profile_contact_page.dart';
import '../../features/profile/presentation/profile_support_page.dart';
import '../../features/properties/domain/property_form_prefill.dart';
import '../../features/properties/presentation/properties_list_page.dart';
import '../../features/properties/presentation/property_detail_page.dart';
import '../../features/properties/presentation/property_form_page.dart';
import '../../features/properties/presentation/property_share_card_page.dart';
import '../../features/setup/presentation/initial_locale_setup_page.dart';
import '../../features/shell/presentation/app_shell_scaffold.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/tasks/presentation/task_form_page.dart';
import '../../features/tasks/presentation/tasks_list_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: SplashPage(),
        ),
      ),
      GoRoute(
        path: '/setup/locale',
        name: 'initialLocaleSetup',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: InitialLocaleSetupPage(),
        ),
      ),
      GoRoute(
        path: '/post-login/locale',
        name: 'postLoginLocaleSetup',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: InitialLocaleSetupPage(postLoginFlow: true),
        ),
      ),
      GoRoute(
        path: '/post-verify',
        name: 'postVerifyCheckout',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: PostVerifyCheckoutPage(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: OnboardingPage(),
        ),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: LoginPage(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: RegisterPage(),
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: ForgotPasswordPage(),
        ),
      ),
      GoRoute(
        path: '/auth/update-password',
        name: 'authUpdatePassword',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: UpdatePasswordPage(),
        ),
      ),
      GoRoute(
        path: '/auth/password-updated',
        name: 'authPasswordUpdated',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: PasswordUpdatedPage(),
        ),
      ),
      GoRoute(
        path: '/tasks',
        name: 'tasks',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: TasksListPage(),
        ),
      ),
      GoRoute(
        path: '/tasks/new',
        name: 'taskNew',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: TaskFormPage(),
        ),
      ),
      GoRoute(
        path: '/tasks/:taskId',
        name: 'taskDetail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['taskId']!;
          return NoTransitionPage<void>(
            child: TaskFormPage(editingTaskId: id),
          );
        },
      ),
      GoRoute(
        path: '/customers/ai-import',
        name: 'customerAiImport',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: AiCustomerImportPage(),
        ),
      ),
      GoRoute(
        path: '/profile/notifications',
        name: 'profileNotifications',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: ProfileNotificationsPage(),
        ),
      ),
      GoRoute(
        path: '/profile/analytics',
        name: 'profileAnalytics',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: ProfileAnalyticsPage(),
        ),
      ),
      GoRoute(
        path: '/profile/support',
        name: 'profileSupport',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: ProfileSupportPage(),
        ),
      ),
      GoRoute(
        path: '/profile/contact',
        name: 'profileContact',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: ProfileContactPage(),
        ),
      ),
      GoRoute(
        path: '/profile/locale-region',
        name: 'profileLocaleRegion',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: LocaleRegionSettingsPage(),
        ),
      ),
      GoRoute(
        path: '/profile/account',
        name: 'profileAccount',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: AccountSettingsPage(),
        ),
      ),
      GoRoute(
        path: '/profile/account/profile',
        name: 'profileAccountProfile',
        pageBuilder: (context, state) {
          final focusEmail = state.uri.queryParameters['focus'] == 'email';
          return NoTransitionPage<void>(
            child: AccountProfileEditorPage(focusEmailOnOpen: focusEmail),
          );
        },
      ),
      GoRoute(
        path: '/profile/kvkk',
        name: 'profileKvkk',
        pageBuilder: (context, state) => const NoTransitionPage<void>(child: KvkkPrivacyPage()),
      ),
      GoRoute(
        path: '/profile/faq',
        name: 'profileFaq',
        pageBuilder: (context, state) => const NoTransitionPage<void>(child: FaqPage()),
      ),
      GoRoute(
        path: '/profile/delete-account',
        name: 'profileDeleteAccount',
        pageBuilder: (context, state) => const NoTransitionPage<void>(child: DeleteAccountPage()),
      ),
      GoRoute(
        path: '/profile/create',
        name: 'profileCreate',
        pageBuilder: (context, state) => const NoTransitionPage<void>(child: ProfileCreatePage()),
      ),
      GoRoute(
        path: '/billing/packages',
        name: 'billingPackages',
        pageBuilder: (context, state) => const NoTransitionPage<void>(child: PackageSelectionPage()),
      ),
      GoRoute(
        path: '/billing/summary',
        name: 'billingSummary',
        pageBuilder: (context, state) => const NoTransitionPage<void>(child: PaymentSummaryPage()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellScaffold(shell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                name: 'home',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: DashboardHomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/customers',
                name: 'customers',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: CustomersListPage(),
                ),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'new',
                    name: 'customerNew',
                    pageBuilder: (context, state) {
                      CustomerFormPrefill? prefill;
                      final extra = state.extra;
                      if (extra is CustomerFormPrefill) {
                        prefill = extra;
                      }
                      return NoTransitionPage<void>(
                        child: CustomerFormPage(prefill: prefill),
                      );
                    },
                  ),
                  GoRoute(
                    path: ':customerId/edit',
                    name: 'customerEdit',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['customerId']!;
                      return NoTransitionPage<void>(
                        child: CustomerFormPage(editingCustomerId: id),
                      );
                    },
                  ),
                  GoRoute(
                    path: ':customerId',
                    name: 'customerDetail',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['customerId']!;
                      return NoTransitionPage<void>(
                        child: CustomerDetailPage(customerId: id),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/properties',
                name: 'properties',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: PropertiesListPage(),
                ),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'new',
                    name: 'propertyNew',
                    pageBuilder: (context, state) {
                      PropertyFormPrefill? prefill;
                      final extra = state.extra;
                      if (extra is PropertyFormPrefill) {
                        prefill = extra;
                      }
                      final linkFirst = state.uri.queryParameters['entry'] == 'link';
                      return NoTransitionPage<void>(
                        child: PropertyFormPage(
                          prefill: prefill,
                          openLinkFlowFirst: linkFirst,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: ':propertyId/share',
                    name: 'propertyShare',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['propertyId']!;
                      return NoTransitionPage<void>(
                        child: PropertyShareCardPage(propertyId: id),
                      );
                    },
                  ),
                  GoRoute(
                    path: ':propertyId/edit',
                    name: 'propertyEdit',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['propertyId']!;
                      return NoTransitionPage<void>(
                        child: PropertyFormPage(editingPropertyId: id),
                      );
                    },
                  ),
                  GoRoute(
                    path: ':propertyId',
                    name: 'propertyDetail',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['propertyId']!;
                      return NoTransitionPage<void>(
                        child: PropertyDetailPage(propertyId: id),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                name: 'profile',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: ProfilePage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
