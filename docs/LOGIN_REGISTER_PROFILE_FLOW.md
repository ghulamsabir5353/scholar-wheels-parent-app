# Login, Register, and Profile Completion

This document describes how the parent app decides that a user must **complete their profile**, and how login/register tie into that.

## What “profile complete” means in code

The app treats the **parent role profile** as incomplete when the logged-in `UserDetail` has **`roleData == null`**.

- `UserDetail` is parsed from API JSON; `roleData` is the nested parent record (`RoleData`: address, city, postalCode, etc.).
- If `roleData` is present (non-null), the app considers the **role-specific profile** created and routes the user toward subscription checks and the main tabs.

Sources:

- `lib/models/user_model.dart` — `roleData` from `json["roleData"]`
- `lib/core/helper.middlewares/auth_middleware.dart` — redirects when `roleData == null`
- `lib/screens/auth/splash_screen.dart` — same check on cold start
- `lib/controllers/auth_controller.dart` — after login OTP verification

## Register flow

1. **Sign up** — `AuthController.registerParent()` posts to `AppConstants.registerParent` with firstName, surName, email, password, phone, confirmPassword.
2. On success, the user is sent to **Verify registration OTP** (`VerifyRegistrationOTPScreen`).
3. **Verify OTP** — `verifyRegistrationOTP()` validates:
   - email non-empty
   - OTP non-empty and length ≥ 6
4. On successful verification (HTTP 200/201 and `data` present, and not `status: false` in body):
   - Token and user are stored; `isLogin` is true; user is persisted to local storage.
   - Navigation: **`Get.offAllNamed(ProfilePictureScreen.route)`** — always, regardless of `roleData` at this point.

There is **no** `roleData` check immediately after registration OTP; new users are steered to profile picture → full profile form.

## Login flow

### Path A: Login without OTP (`login()`)

When the API returns **no** `requiresOtp`:

- Token and user are stored; optional persistence if **Remember me**.
- Navigation: **`Get.offAllNamed(TabScreen.route)`** directly.

**Note:** This path does **not** branch on `roleData` in `login()`. If `roleData` is still null, **`AuthMiddleware`** on `TabScreen` redirects to `ProfilePictureScreen` (see below).

### Path B: Login with OTP (`requiresOtp == true`)

- If `isRegistrationOtp == true` → **Verify registration OTP** (same as register flow edge case).
- Else → **Verify login OTP** (`VerifyLoginOTPScreen`) with `challengeToken`.

After **successful** `verifyLoginOTP()`:

1. If **`BaseHelper.currentUser.value.roleData == null`** → **`ProfilePictureScreen`** (profile completion path).
2. Else → fetch subscription via `BillingController.fetchMySubscription()`, then:
   - If **`BaseHelper.mySubscription.value?.hasActiveSubscription == true`** → **`TabScreen`**
   - Else → **`SubscriptionPlansScreen`**

Comment in code: *Priority: roleData (complete profile) → subscription → home.*

## Where `roleData == null` is enforced

| Location | Condition | Redirect / navigation |
|----------|-----------|-------------------------|
| `SplashScreen._checkAndNavigate` | `isLogin` and `roleData == null` | `ProfilePictureScreen` |
| `AuthMiddleware` (for `TabScreen`) | `isLogin` and `roleData == null` | `ProfilePictureScreen` |
| `GuestMiddleware` | `isLogin` and `roleData == null` | `ProfilePictureScreen` |
| `verifyLoginOTP` success | `roleData == null` | `ProfilePictureScreen` |

Subscription gating (after profile) uses `_hasActiveSubscription` in middleware: either cached `mySubscription.hasActiveSubscription` or `user.activeSubscription == true && user.subscription != null`.

## Onboarding UI: picture → form → API

1. **`ProfilePictureScreen`** — user may pick an image (upload sets `authController.profileImagePath`). **Continue** does not require an image; it always **`Get.toNamed(ProfileScreen.route)`**.
2. **`ProfileScreen`** (“Complete Your Profile”) — **Complete Profile** runs only if the form validates:
   - First name, surname, email, phone (South Africa validator), city, zip code, address — all required per field validators.
3. **`AuthController.completeProfile()`** — additional gate: **`BaseHelper.currentUser.value.id` must be non-null** or it shows “User ID not found” and returns.
4. On success (POST `parent` with userId, names, email, phone, address, city, postalCode, profileImage):
   - `currentUser` is updated with `roleData` from `response.data['parent']`.
   - Navigation: **`SubscriptionPlansScreen`** with `fromProfileCompletion: true`.

## Summary

| Question | Answer |
|----------|--------|
| What condition means “complete the user profile” (routing)? | **`UserDetail.roleData == null`** |
| What completes it on the server? | Successful **`POST parent`** (`completeProfile()`), which attaches **`roleData`** to the user model locally |
| When is the profile form shown? | After **registration OTP**, or when **login OTP** succeeds with `roleData == null`, or via **splash/middleware** if a logged-in user opens the app without `roleData` |
| What must pass before calling the API? | **Form validation** on `ProfileScreen` + **non-null user `id`** in `completeProfile()` |
