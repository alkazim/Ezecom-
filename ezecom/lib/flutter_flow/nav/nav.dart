import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '/backend/schema/structs/index.dart';

import '/backend/supabase/supabase.dart';

import '/auth/base_auth_user_provider.dart';

import '/main.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:ff_commons/flutter_flow/lat_lng.dart';
import 'package:ff_commons/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

import '/index.dart';
import 'package:paypal_integration_marketplace_library_9mtra1/index.dart'
    as $paypal_integration_marketplace_library_9mtra1;

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) {
  $paypal_integration_marketplace_library_9mtra1.initializeRoutes(
    homePageWidgetName:
        'paypal_integration_marketplace_library_9mtra1.HomePage',
  );

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: appStateNotifier,
    navigatorKey: appNavigatorKey,
    errorBuilder: (context, state) =>
        appStateNotifier.loggedIn ? NavBarPage() : OnboardingPageWidget(),
    routes: [
      FFRoute(
        name: '_initialize',
        path: '/',
        builder: (context, _) =>
            appStateNotifier.loggedIn ? NavBarPage() : OnboardingPageWidget(),
      ),
      FFRoute(
        name: OnboardingPageWidget.routeName,
        path: OnboardingPageWidget.routePath,
        builder: (context, params) => OnboardingPageWidget(),
      ),
      FFRoute(
        name: LoginPageWidget.routeName,
        path: LoginPageWidget.routePath,
        builder: (context, params) => LoginPageWidget(),
      ),
      FFRoute(
        name: PasswordWidget.routeName,
        path: PasswordWidget.routePath,
        builder: (context, params) => PasswordWidget(),
      ),
      FFRoute(
        name: PasswordRecoveryWidget.routeName,
        path: PasswordRecoveryWidget.routePath,
        builder: (context, params) => PasswordRecoveryWidget(),
      ),
      FFRoute(
        name: NewPasswordWidget.routeName,
        path: NewPasswordWidget.routePath,
        builder: (context, params) => NewPasswordWidget(),
      ),
      FFRoute(
        name: PasswordRecovery2Widget.routeName,
        path: PasswordRecovery2Widget.routePath,
        builder: (context, params) => PasswordRecovery2Widget(),
      ),
      FFRoute(
          name: HomePageWidget.routeName,
          path: HomePageWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'HomePage')
              : NavBarPage(
                  initialPage: 'HomePage',
                  page: HomePageWidget(),
                )),
      FFRoute(
        name: SettingWidget.routeName,
        path: SettingWidget.routePath,
        builder: (context, params) => SettingWidget(
          emailID: params.getParam(
            'emailID',
            ParamType.String,
          ),
          companyName: params.getParam(
            'companyName',
            ParamType.String,
          ),
          role: params.getParam(
            'role',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: ProfileBuyerWidget.routeName,
        path: ProfileBuyerWidget.routePath,
        builder: (context, params) => params.isEmpty
            ? NavBarPage(initialPage: 'ProfileBuyer')
            : ProfileBuyerWidget(),
      ),
      FFRoute(
        name: ContactWidget.routeName,
        path: ContactWidget.routePath,
        builder: (context, params) => ContactWidget(),
      ),
      FFRoute(
        name: ShoppingAddressWidget.routeName,
        path: ShoppingAddressWidget.routePath,
        builder: (context, params) => ShoppingAddressWidget(),
      ),
      FFRoute(
        name: MyProfileWidget.routeName,
        path: MyProfileWidget.routePath,
        builder: (context, params) => MyProfileWidget(
          companyName: params.getParam(
            'companyName',
            ParamType.String,
          ),
          emailID: params.getParam(
            'emailID',
            ParamType.String,
          ),
          contactNumber: params.getParam(
            'contactNumber',
            ParamType.int,
          ),
        ),
      ),
      FFRoute(
        name: CardPaymentWidget.routeName,
        path: CardPaymentWidget.routePath,
        builder: (context, params) => CardPaymentWidget(),
      ),
      FFRoute(
        name: ChangePasswordWidget.routeName,
        path: ChangePasswordWidget.routePath,
        builder: (context, params) => ChangePasswordWidget(
          emailID: params.getParam(
            'emailID',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: DeleteWidget.routeName,
        path: DeleteWidget.routePath,
        builder: (context, params) => DeleteWidget(),
      ),
      FFRoute(
        name: DeleterequestWidget.routeName,
        path: DeleterequestWidget.routePath,
        builder: (context, params) => DeleterequestWidget(),
      ),
      FFRoute(
        name: AccountRemovedWidget.routeName,
        path: AccountRemovedWidget.routePath,
        builder: (context, params) => AccountRemovedWidget(),
      ),
      FFRoute(
        name: CategoriesWidget.routeName,
        path: CategoriesWidget.routePath,
        builder: (context, params) => CategoriesWidget(),
      ),
      FFRoute(
        name: CartPage2Widget.routeName,
        path: CartPage2Widget.routePath,
        builder: (context, params) => params.isEmpty
            ? NavBarPage(initialPage: 'cartPage2')
            : CartPage2Widget(),
      ),
      FFRoute(
        name: NotificationEmptyWidget.routeName,
        path: NotificationEmptyWidget.routePath,
        builder: (context, params) => NotificationEmptyWidget(),
      ),
      FFRoute(
        name: NotificationWidget.routeName,
        path: NotificationWidget.routePath,
        builder: (context, params) => params.isEmpty
            ? NavBarPage(initialPage: 'Notification')
            : NotificationWidget(),
      ),
      FFRoute(
        name: ProductDetailWidget.routeName,
        path: ProductDetailWidget.routePath,
        builder: (context, params) => ProductDetailWidget(
          productID: params.getParam(
            'productID',
            ParamType.int,
          ),
        ),
      ),
      FFRoute(
        name: PaymentSuccessfulWidget.routeName,
        path: PaymentSuccessfulWidget.routePath,
        builder: (context, params) => PaymentSuccessfulWidget(),
      ),
      FFRoute(
        name: PaymentFactoryThroughWidget.routeName,
        path: PaymentFactoryThroughWidget.routePath,
        builder: (context, params) => PaymentFactoryThroughWidget(
          productID: params.getParam(
            'productID',
            ParamType.int,
          ),
          quantity: params.getParam(
            'quantity',
            ParamType.String,
          ),
          enquiryID: params.getParam(
            'enquiryID',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: TrackOrder1Widget.routeName,
        path: TrackOrder1Widget.routePath,
        builder: (context, params) => TrackOrder1Widget(),
      ),
      FFRoute(
        name: TrackOrder2Widget.routeName,
        path: TrackOrder2Widget.routePath,
        builder: (context, params) => TrackOrder2Widget(),
      ),
      FFRoute(
        name: SearchWidget.routeName,
        path: SearchWidget.routePath,
        builder: (context, params) => SearchWidget(),
      ),
      FFRoute(
        name: CreateAccountSellerWidget.routeName,
        path: CreateAccountSellerWidget.routePath,
        builder: (context, params) => CreateAccountSellerWidget(),
      ),
      FFRoute(
        name: BuyerOrSellerWidget.routeName,
        path: BuyerOrSellerWidget.routePath,
        builder: (context, params) => BuyerOrSellerWidget(),
      ),
      FFRoute(
        name: PaymentFailedWidget.routeName,
        path: PaymentFailedWidget.routePath,
        builder: (context, params) => PaymentFailedWidget(),
      ),
      FFRoute(
        name: LoadingPageFactoryThroughWidget.routeName,
        path: LoadingPageFactoryThroughWidget.routePath,
        builder: (context, params) => LoadingPageFactoryThroughWidget(),
      ),
      FFRoute(
        name: ApprovalPageSellerWidget.routeName,
        path: ApprovalPageSellerWidget.routePath,
        builder: (context, params) => ApprovalPageSellerWidget(),
      ),
      FFRoute(
        name: PDFViewserWidget.routeName,
        path: PDFViewserWidget.routePath,
        builder: (context, params) => PDFViewserWidget(),
      ),
      FFRoute(
        name: CreateAccountBuyerWidget.routeName,
        path: CreateAccountBuyerWidget.routePath,
        builder: (context, params) => CreateAccountBuyerWidget(),
      ),
      FFRoute(
        name: TempProductAddingWidget.routeName,
        path: TempProductAddingWidget.routePath,
        builder: (context, params) => TempProductAddingWidget(),
      ),
      FFRoute(
        name: TempBannerAddingPageWidget.routeName,
        path: TempBannerAddingPageWidget.routePath,
        builder: (context, params) => TempBannerAddingPageWidget(),
      ),
      FFRoute(
        name: ChangePassword2Widget.routeName,
        path: ChangePassword2Widget.routePath,
        builder: (context, params) => ChangePassword2Widget(),
      ),
      FFRoute(
        name: LoginPage1Widget.routeName,
        path: LoginPage1Widget.routePath,
        builder: (context, params) => LoginPage1Widget(),
      ),
      FFRoute(
        name: Categories2Widget.routeName,
        path: Categories2Widget.routePath,
        builder: (context, params) => Categories2Widget(),
      ),
      FFRoute(
        name: ForgotPasswordWidget.routeName,
        path: ForgotPasswordWidget.routePath,
        requireAuth: true,
        builder: (context, params) => ForgotPasswordWidget(),
      ),
      FFRoute(
        name: CartpageWidget.routeName,
        path: CartpageWidget.routePath,
        builder: (context, params) => CartpageWidget(),
      ),
      FFRoute(
        name: Seller0DashboardWidget.routeName,
        path: Seller0DashboardWidget.routePath,
        builder: (context, params) => Seller0DashboardWidget(),
      ),
      FFRoute(
        name: SetupPasswordWidget.routeName,
        path: SetupPasswordWidget.routePath,
        builder: (context, params) => SetupPasswordWidget(),
      ),
      FFRoute(
        name: Seller2ApprovalsWidget.routeName,
        path: Seller2ApprovalsWidget.routePath,
        builder: (context, params) => Seller2ApprovalsWidget(),
      ),
      FFRoute(
        name: Seller3ActiveProductWidget.routeName,
        path: Seller3ActiveProductWidget.routePath,
        builder: (context, params) => Seller3ActiveProductWidget(),
      ),
      FFRoute(
        name: ProfilePageBuyerWidget.routeName,
        path: ProfilePageBuyerWidget.routePath,
        builder: (context, params) => ProfilePageBuyerWidget(),
      ),
      FFRoute(
        name: ChangePassword1Widget.routeName,
        path: ChangePassword1Widget.routePath,
        builder: (context, params) => ChangePassword1Widget(),
      ),
      FFRoute(
        name: Cardpayment1Widget.routeName,
        path: Cardpayment1Widget.routePath,
        builder: (context, params) => Cardpayment1Widget(),
      ),
      FFRoute(
        name: DeleteAccountWidget.routeName,
        path: DeleteAccountWidget.routePath,
        builder: (context, params) => DeleteAccountWidget(),
      ),
      FFRoute(
        name: PlansWidget.routeName,
        path: PlansWidget.routePath,
        builder: (context, params) => PlansWidget(
          currentUserMailID: params.getParam(
            'currentUserMailID',
            ParamType.String,
          ),
          companyName: params.getParam(
            'companyName',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: PlanConfirmWidget.routeName,
        path: PlanConfirmWidget.routePath,
        builder: (context, params) => PlanConfirmWidget(
          sellerExpiry: params.getParam(
            'sellerExpiry',
            ParamType.bool,
          ),
        ),
      ),
      FFRoute(
        name: Seller1AddProductWidget.routeName,
        path: Seller1AddProductWidget.routePath,
        builder: (context, params) => Seller1AddProductWidget(),
      ),
      FFRoute(
        name: Home3Widget.routeName,
        path: Home3Widget.routePath,
        builder: (context, params) => Home3Widget(),
      ),
      FFRoute(
        name: TestProductAddingPageWidget.routeName,
        path: TestProductAddingPageWidget.routePath,
        builder: (context, params) => TestProductAddingPageWidget(),
      ),
      FFRoute(
        name: DynamicTextFieldWidget.routeName,
        path: DynamicTextFieldWidget.routePath,
        builder: (context, params) => DynamicTextFieldWidget(),
      ),
      FFRoute(
        name: Seller4ProfilePageWidget.routeName,
        path: Seller4ProfilePageWidget.routePath,
        builder: (context, params) => Seller4ProfilePageWidget(),
      ),
      FFRoute(
        name: LoadingScreenWidget.routeName,
        path: LoadingScreenWidget.routePath,
        builder: (context, params) => LoadingScreenWidget(),
      ),
      FFRoute(
        name: BuyerPaymentWidget.routeName,
        path: BuyerPaymentWidget.routePath,
        builder: (context, params) => BuyerPaymentWidget(),
      ),
      FFRoute(
        name: BuyNowConfirmPageWidget.routeName,
        path: BuyNowConfirmPageWidget.routePath,
        builder: (context, params) => BuyNowConfirmPageWidget(),
      ),
      FFRoute(
        name: PaymentAgentThroughWidget.routeName,
        path: PaymentAgentThroughWidget.routePath,
        builder: (context, params) => PaymentAgentThroughWidget(
          productID: params.getParam(
            'productID',
            ParamType.int,
          ),
          quantity: params.getParam(
            'quantity',
            ParamType.String,
          ),
          enquiryID: params.getParam(
            'enquiryID',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: AboutUsWidget.routeName,
        path: AboutUsWidget.routePath,
        builder: (context, params) => AboutUsWidget(),
      ),
      FFRoute(
        name: CurrentVerisonWidget.routeName,
        path: CurrentVerisonWidget.routePath,
        builder: (context, params) => CurrentVerisonWidget(),
      ),
      FFRoute(
        name: PrivacyPolicyWidget.routeName,
        path: PrivacyPolicyWidget.routePath,
        builder: (context, params) => PrivacyPolicyWidget(),
      ),
      FFRoute(
        name: Forgorpassword1Widget.routeName,
        path: Forgorpassword1Widget.routePath,
        builder: (context, params) => Forgorpassword1Widget(),
      ),
      FFRoute(
        name: PaymentInAppCartWidget.routeName,
        path: PaymentInAppCartWidget.routePath,
        builder: (context, params) => PaymentInAppCartWidget(
          productID: params.getParam(
            'productID',
            ParamType.int,
          ),
          quantity: params.getParam<double>(
            'quantity',
            ParamType.double,
            isList: true,
          ),
        ),
      ),
      FFRoute(
        name: FilterPageCategoriesWidget.routeName,
        path: FilterPageCategoriesWidget.routePath,
        builder: (context, params) => FilterPageCategoriesWidget(
          categoryName: params.getParam(
            'categoryName',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: FilterPageSearchWidget.routeName,
        path: FilterPageSearchWidget.routePath,
        builder: (context, params) => FilterPageSearchWidget(
          productID: params.getParam<int>(
            'productID',
            ParamType.int,
            isList: true,
          ),
        ),
      ),
      FFRoute(
        name: BuyeraddressWidget.routeName,
        path: BuyeraddressWidget.routePath,
        builder: (context, params) => BuyeraddressWidget(),
      ),
      FFRoute(
        name: PaymentAgentThroughCartWidget.routeName,
        path: PaymentAgentThroughCartWidget.routePath,
        builder: (context, params) => PaymentAgentThroughCartWidget(
          enquiryID: params.getParam(
            'enquiryID',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: PaymentFactoryThroughCartWidget.routeName,
        path: PaymentFactoryThroughCartWidget.routePath,
        builder: (context, params) => PaymentFactoryThroughCartWidget(
          enquiryID: params.getParam(
            'enquiryID',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: ProfileEditsWidget.routeName,
        path: ProfileEditsWidget.routePath,
        builder: (context, params) => ProfileEditsWidget(
          companyName: params.getParam(
            'companyName',
            ParamType.String,
          ),
          emailID: params.getParam(
            'emailID',
            ParamType.String,
          ),
          contactNumber: params.getParam(
            'contactNumber',
            ParamType.int,
          ),
        ),
      ),
      FFRoute(
        name: Invoice4sellerWidget.routeName,
        path: Invoice4sellerWidget.routePath,
        builder: (context, params) => Invoice4sellerWidget(),
      ),
      FFRoute(
        name: Invoice4BuyerWidget.routeName,
        path: Invoice4BuyerWidget.routePath,
        builder: (context, params) => Invoice4BuyerWidget(
          quantity: params.getParam(
            'quantity',
            ParamType.int,
          ),
        ),
      ),
      FFRoute(
        name: FilterTopDealsWidget.routeName,
        path: FilterTopDealsWidget.routePath,
        builder: (context, params) => FilterTopDealsWidget(),
      ),
      FFRoute(
        name: FilterNewArriavalsWidget.routeName,
        path: FilterNewArriavalsWidget.routePath,
        builder: (context, params) => FilterNewArriavalsWidget(),
      ),
      FFRoute(
        name: FilterFeaturedOfferWidget.routeName,
        path: FilterFeaturedOfferWidget.routePath,
        builder: (context, params) => FilterFeaturedOfferWidget(),
      ),
      FFRoute(
        name: LoadingPageAgentThroughWidget.routeName,
        path: LoadingPageAgentThroughWidget.routePath,
        builder: (context, params) => LoadingPageAgentThroughWidget(),
      ),
      FFRoute(
        name: MyProfile4SellerWidget.routeName,
        path: MyProfile4SellerWidget.routePath,
        builder: (context, params) => MyProfile4SellerWidget(
          companyName: params.getParam(
            'companyName',
            ParamType.String,
          ),
          emailID: params.getParam(
            'emailID',
            ParamType.String,
          ),
          contactNumber: params.getParam(
            'contactNumber',
            ParamType.int,
          ),
        ),
      ),
      FFRoute(
        name: Seller4changePasswordWidget.routeName,
        path: Seller4changePasswordWidget.routePath,
        builder: (context, params) => Seller4changePasswordWidget(
          emailID: params.getParam(
            'emailID',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: Seller4ConfirmPasswordWidget.routeName,
        path: Seller4ConfirmPasswordWidget.routePath,
        builder: (context, params) => Seller4ConfirmPasswordWidget(),
      ),
      FFRoute(
        name: Seller4paymentWidget.routeName,
        path: Seller4paymentWidget.routePath,
        builder: (context, params) => Seller4paymentWidget(),
      ),
      FFRoute(
        name: SellerDeleteAccountWidget.routeName,
        path: SellerDeleteAccountWidget.routePath,
        builder: (context, params) => SellerDeleteAccountWidget(
          emailID: params.getParam(
            'emailID',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: PlanPageWidget.routeName,
        path: PlanPageWidget.routePath,
        builder: (context, params) => PlanPageWidget(
          companyName: params.getParam(
            'companyName',
            ParamType.String,
          ),
          emailID: params.getParam(
            'emailID',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: WebviewpaypalWidget.routeName,
        path: WebviewpaypalWidget.routePath,
        builder: (context, params) => WebviewpaypalWidget(),
      ),
      FFRoute(
        name: Test3Widget.routeName,
        path: Test3Widget.routePath,
        builder: (context, params) => Test3Widget(),
      ),
      FFRoute(
        name: CartpagecopyWidget.routeName,
        path: CartpagecopyWidget.routePath,
        builder: (context, params) => CartpagecopyWidget(),
      ),
      FFRoute(
        name: FeaturedtestWidget.routeName,
        path: FeaturedtestWidget.routePath,
        builder: (context, params) => FeaturedtestWidget(),
      ),
      FFRoute(
        name: MyOrdersWidget.routeName,
        path: MyOrdersWidget.routePath,
        builder: (context, params) => MyOrdersWidget(
          index: params.getParam(
            'index',
            ParamType.int,
          ),
        ),
      ),
      FFRoute(
        name: PaypalwebpageWidget.routeName,
        path: PaypalwebpageWidget.routePath,
        builder: (context, params) => PaypalwebpageWidget(
          enquiryID: params.getParam(
            'enquiryID',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: PaypalmobilepageWidget.routeName,
        path: PaypalmobilepageWidget.routePath,
        builder: (context, params) => PaypalmobilepageWidget(
          enquiryID: params.getParam(
            'enquiryID',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: ViewManufacturePDFWidget.routeName,
        path: ViewManufacturePDFWidget.routePath,
        builder: (context, params) => ViewManufacturePDFWidget(),
      ),
      FFRoute(
        name: RedirectHandlerWebWidget.routeName,
        path: RedirectHandlerWebWidget.routePath,
        builder: (context, params) => RedirectHandlerWebWidget(
          enquiryId: params.getParam(
            'enquiryId',
            ParamType.String,
          ),
          status: params.getParam(
            'status',
            ParamType.String,
          ),
          token: params.getParam(
            'token',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: PayPalPlanPurchasePageWebWidget.routeName,
        path: PayPalPlanPurchasePageWebWidget.routePath,
        builder: (context, params) => PayPalPlanPurchasePageWebWidget(
          transactionToken: params.getParam(
            'transactionToken',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: PayPalPlanPurchasePageMobileWidget.routeName,
        path: PayPalPlanPurchasePageMobileWidget.routePath,
        builder: (context, params) => PayPalPlanPurchasePageMobileWidget(
          transactionToken: params.getParam(
            'transactionToken',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: Seller5OrdersWidget.routeName,
        path: Seller5OrdersWidget.routePath,
        builder: (context, params) => Seller5OrdersWidget(),
      ),
      FFRoute(
        name: Seller6BannersWidget.routeName,
        path: Seller6BannersWidget.routePath,
        builder: (context, params) => Seller6BannersWidget(),
      ),
      FFRoute(
        name: Paymentchoose2Widget.routeName,
        path: Paymentchoose2Widget.routePath,
        builder: (context, params) => Paymentchoose2Widget(
          enquirylD: params.getParam(
            'enquirylD',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: PhonePeForWebPageWidget.routeName,
        path: PhonePeForWebPageWidget.routePath,
        builder: (context, params) => PhonePeForWebPageWidget(
          enquiryld: params.getParam(
            'enquiryld',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: PhonepeforMobilePageWidget.routeName,
        path: PhonepeforMobilePageWidget.routePath,
        builder: (context, params) => PhonepeforMobilePageWidget(
          enquiryld: params.getParam(
            'enquiryld',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: SellerAddressWidget.routeName,
        path: SellerAddressWidget.routePath,
        builder: (context, params) => SellerAddressWidget(),
      ),
      FFRoute(
        name: PaymentStatusPagePhonepeWidget.routeName,
        path: PaymentStatusPagePhonepeWidget.routePath,
        builder: (context, params) => PaymentStatusPagePhonepeWidget(
          merchantTransactionld: params.getParam(
            'merchantTransactionld',
            ParamType.String,
          ),
          enquiryld: params.getParam(
            'enquiryld',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: PaymentPendingWidget.routeName,
        path: PaymentPendingWidget.routePath,
        builder: (context, params) => PaymentPendingWidget(),
      ),
      FFRoute(
        name: Test123Widget.routeName,
        path: Test123Widget.routePath,
        builder: (context, params) => Test123Widget(),
      ),
      FFRoute(
        name: PaymentProcessingWidget.routeName,
        path: PaymentProcessingWidget.routePath,
        builder: (context, params) => PaymentProcessingWidget(),
      ),
      FFRoute(
        name: PaymentVerificationWidget.routeName,
        path: PaymentVerificationWidget.routePath,
        builder: (context, params) => PaymentVerificationWidget(),
      ),
      FFRoute(
        name: VerificationPhonepeWidget.routeName,
        path: VerificationPhonepeWidget.routePath,
        builder: (context, params) => VerificationPhonepeWidget(
          merchantTransactionId: params.getParam(
            'merchantTransactionId',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: SomethingwentwrongWidget.routeName,
        path: SomethingwentwrongWidget.routePath,
        builder: (context, params) => SomethingwentwrongWidget(),
      ),
      FFRoute(
        name: PaymentProcessing2Widget.routeName,
        path: PaymentProcessing2Widget.routePath,
        builder: (context, params) => PaymentProcessing2Widget(),
      ),
      FFRoute(
        name: RedirecthandlerPlanWidget.routeName,
        path: RedirecthandlerPlanWidget.routePath,
        builder: (context, params) => RedirecthandlerPlanWidget(
          transactionToken: params.getParam(
            'transactionToken',
            ParamType.String,
          ),
          status: params.getParam(
            'status',
            ParamType.String,
          ),
          token: params.getParam(
            'token',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: TermsAndConditionWidget.routeName,
        path: TermsAndConditionWidget.routePath,
        builder: (context, params) => TermsAndConditionWidget(),
      ),
      FFRoute(
        name: TermsAndConditionCopyWidget.routeName,
        path: TermsAndConditionCopyWidget.routePath,
        builder: (context, params) => TermsAndConditionCopyWidget(),
      ),
      FFRoute(
        name: PrivacyPolicyCopyWidget.routeName,
        path: PrivacyPolicyCopyWidget.routePath,
        builder: (context, params) => PrivacyPolicyCopyWidget(),
      ),
      FFRoute(
        name: Paymentchoose1planWidget.routeName,
        path: Paymentchoose1planWidget.routePath,
        builder: (context, params) => Paymentchoose1planWidget(
          planID: params.getParam(
            'planID',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: TestpageWidget.routeName,
        path: TestpageWidget.routePath,
        builder: (context, params) => TestpageWidget(),
      ),
      FFRoute(
        name: PurchaseCompletedWidget.routeName,
        path: PurchaseCompletedWidget.routePath,
        builder: (context, params) => PurchaseCompletedWidget(),
      ),
      FFRoute(
        name: PurchasefailedWidget.routeName,
        path: PurchasefailedWidget.routePath,
        builder: (context, params) => PurchasefailedWidget(),
      ),
      FFRoute(
        name: VerificationPhonepePlanWidget.routeName,
        path: VerificationPhonepePlanWidget.routePath,
        builder: (context, params) => VerificationPhonepePlanWidget(
          transactionId: params.getParam(
            'transactionId',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: HomePageSeller2Widget.routeName,
        path: HomePageSeller2Widget.routePath,
        builder: (context, params) => HomePageSeller2Widget(),
      ),
      FFRoute(
        name: Seller6BannersCopyWidget.routeName,
        path: Seller6BannersCopyWidget.routePath,
        builder: (context, params) => Seller6BannersCopyWidget(),
      ),
      FFRoute(
        name: EditbannerWidget.routeName,
        path: EditbannerWidget.routePath,
        builder: (context, params) => EditbannerWidget(),
      ),
      FFRoute(
        name: Editbanner2Widget.routeName,
        path: Editbanner2Widget.routePath,
        builder: (context, params) => Editbanner2Widget(),
      ),
      FFRoute(
        name: TestmyordersWidget.routeName,
        path: TestmyordersWidget.routePath,
        builder: (context, params) => TestmyordersWidget(
          index: params.getParam(
            'index',
            ParamType.int,
          ),
        ),
      ),
      FFRoute(
        name: SellerPageWidget.routeName,
        path: SellerPageWidget.routePath,
        builder: (context, params) => SellerPageWidget(),
      ),
      FFRoute(
        name: SellerforSettingWidget.routeName,
        path: SellerforSettingWidget.routePath,
        builder: (context, params) => SellerforSettingWidget(
          emailID: params.getParam(
            'emailID',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: SellerforContactUSWidget.routeName,
        path: SellerforContactUSWidget.routePath,
        builder: (context, params) => SellerforContactUSWidget(),
      ),
      FFRoute(
        name: SellerforAboutUSWidget.routeName,
        path: SellerforAboutUSWidget.routePath,
        builder: (context, params) => SellerforAboutUSWidget(
          emailID: params.getParam(
            'emailID',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: SellerforPrivacyPolicyWidget.routeName,
        path: SellerforPrivacyPolicyWidget.routePath,
        builder: (context, params) => SellerforPrivacyPolicyWidget(
          emailID: params.getParam(
            'emailID',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: UploadDocumentsWidget.routeName,
        path: UploadDocumentsWidget.routePath,
        builder: (context, params) => UploadDocumentsWidget(),
      ),
      FFRoute(
        name: $paypal_integration_marketplace_library_9mtra1
            .HomePageWidget.routeName,
        path: $paypal_integration_marketplace_library_9mtra1
            .HomePageWidget.routePath,
        builder: (context, params) =>
            $paypal_integration_marketplace_library_9mtra1.HomePageWidget(),
      )
    ].map((r) => r.toRoute(appStateNotifier)).toList(),
  );
}

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/onboardingPage';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
