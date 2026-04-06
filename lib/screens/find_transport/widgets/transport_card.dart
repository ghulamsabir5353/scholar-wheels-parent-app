import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_network_image.dart';
import 'package:scholarwheels/models/route_model.dart';
import 'package:scholarwheels/core/helper.constants/color.dart' show AppColor;
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/find_transport/request_booking_screen.dart';
import 'package:scholarwheels/screens/common/full_screen_image_screen.dart';

class TransportCard extends StatelessWidget {
  final RouteModel? route;

  const TransportCard({super.key, this.route});

  /// Get transport owner name
  String _getTransportOwnerName() {
    if (route?.transportOwner?.businessName != null &&
        route!.transportOwner!.businessName!.isNotEmpty) {
      return route!.transportOwner!.businessName!;
    }
    if (route?.transportOwner?.firstName != null ||
        route?.transportOwner?.surName != null) {
      final firstName = route?.transportOwner?.firstName ?? '';
      final surName = route?.transportOwner?.surName ?? '';
      return '$firstName $surName'.trim();
    }
    return 'Transport Company';
  }

  /// Get initial for avatar
  String _getInitial() {
    final name = _getTransportOwnerName();
    if (name.isNotEmpty) {
      return name[0].toUpperCase();
    }
    return 'T';
  }

  /// Build list of full vehicle image URLs (for full-screen viewer).
  List<String> _buildVehicleImageUrls() {
    if (route?.vehicle?.pictures == null || route!.vehicle!.pictures!.isEmpty) {
      return [];
    }
    return route!.vehicle!.pictures!
        .map((p) {
          final u = p.presignedUrl ?? p.url;
          if (u == null || u.isEmpty) return null;
          if (u.startsWith('http://') || u.startsWith('https://')) {
            return u;
          }
          final clean = u.startsWith('/') ? u.substring(1) : u;
          return '${AppConstants.imageBaseUrl}$clean';
        })
        .whereType<String>()
        .toList();
  }

  /// Index in the filtered URL list for the given picture index.
  int _urlIndexForPictureIndex(int pictureIndex) {
    if (route?.vehicle?.pictures == null) return 0;
    int urlIndex = 0;
    for (
      int i = 0;
      i < pictureIndex && i < route!.vehicle!.pictures!.length;
      i++
    ) {
      final u =
          route!.vehicle!.pictures![i].presignedUrl ??
          route!.vehicle!.pictures![i].url;
      if (u != null && u.isNotEmpty) urlIndex++;
    }
    return urlIndex;
  }

  /// Get route display text
  String _getRouteDisplay() {
    final suburb = route?.suburbName ?? '';
    final dropOff = route?.dropOffPointName ?? '';
    return '$suburb → $dropOff';
  }

  /// Get vehicle display text
  String _getVehicleDisplay() {
    if (route?.vehicle?.make != null && route?.vehicle?.model != null) {
      return '${route!.vehicle!.make} ${route!.vehicle!.model}';
    }
    if (route?.vehicle?.vehicleType != null) {
      return route!.vehicle!.vehicleType!;
    }
    return 'Vehicle';
  }

  /// Build feature tags list
  List<Widget> _buildFeatureTags() {
    final List<Widget> tags = [];

    // Insured tag
    if (route?.vehicle?.isInsured == true) {
      tags.add(_buildFeatureTag('Insured', icon: Icons.check_circle));
    }

    // Vehicle Type
    if (route?.vehicle?.vehicleType != null) {
      tags.add(_buildFeatureTag(route!.vehicle!.vehicleType!));
    }

    // Capacity
    if (route?.vehicle?.capacity != null) {
      tags.add(_buildFeatureTag('${route!.vehicle!.capacity} Seater'));
    }

    // Model Year
    if (route?.vehicle?.manufacturingYear != null) {
      tags.add(_buildFeatureTag('Model ${route!.vehicle!.manufacturingYear}'));
    }

    // AC (assuming it's available - you may need to add this field to the model)
    tags.add(_buildFeatureTag('AC'));

    // Child Safety Locks
    tags.add(_buildFeatureTag('Child Safety Locks'));

    return tags;
  }

  Widget _buildFeatureTag(String text, {IconData? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      margin: EdgeInsets.only(right: 6.w, bottom: 6.h),
      decoration: BoxDecoration(
        color: AppColor.lightSecondary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14.sp, color: AppColor.primary),
            SpaceHelper(w: 4.w),
          ],
          Text(
            text,
            style: poppinFonts(
              color: AppColor.primary,
              fontSize: xs,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: AppColor.cardShadowColor,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Info Section
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColor.darkPrimary,
                  radius: 24.r,
                  child: Text(
                    _getInitial(),
                    style: poppinFonts(
                      color: AppColor.appColorWhite,
                      fontSize: base,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SpaceHelper(w: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _getTransportOwnerName(),
                              style: poppinFonts(
                                color: AppColor.black,
                                fontSize: base,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (route?.transportOwner?.transportLicense != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.lightSecondary,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/svg/verified.svg',
                                    width: 16.w,
                                    height: 16.w,
                                    colorFilter: ColorFilter.mode(
                                      route?.transportOwner?.isVerified ?? false
                                          ? AppColor.primary
                                          : AppColor.black,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SpaceHelper(w: 4.w),
                                  Text(
                                    'Verified',
                                    style: poppinFonts(
                                      color: AppColor.black,
                                      fontSize: xs,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SpaceHelper(h: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColor.darkSecondary,
                            size: 16.sp,
                          ),
                          SpaceHelper(w: 4.w),
                          Text(
                            route?.transportOwner?.averageRating != null
                                ? '${route!.transportOwner!.averageRating} (${route!.transportOwner!.totalRatings ?? 0} reviews)'
                                : '0.0 (0 reviews)',
                            style: poppinFonts(
                              fontSize: sm,
                              color: AppColor.textLightBlackColor4A4A4A,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SpaceHelper(h: 16.h),

            // Route Details Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/images/svg/pickup.svg',
                  width: 20.w,
                  height: 20.w,
                  colorFilter: ColorFilter.mode(
                    AppColor.textLightBlackColor4A4A4A,
                    BlendMode.srcIn,
                  ),
                ),
                SpaceHelper(w: 8.w),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Route: ',
                        style: poppinFonts(
                          fontSize: sm,
                          color: AppColor.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _getRouteDisplay(),
                          style: poppinFonts(
                            fontSize: sm,
                            color: AppColor.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SpaceHelper(h: 8.h),

            // Vehicle Details Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/images/svg/vahicle.svg',
                  width: 20.w,
                  height: 20.w,
                  colorFilter: ColorFilter.mode(
                    AppColor.textLightBlackColor4A4A4A,
                    BlendMode.srcIn,
                  ),
                ),
                SpaceHelper(w: 8.w),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vehicle: ',
                        style: poppinFonts(
                          fontSize: sm,
                          color: AppColor.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _getVehicleDisplay(),
                          style: poppinFonts(
                            fontSize: sm,
                            color: AppColor.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SpaceHelper(h: 12.h),

            // Vehicle Features/Tags Section
            Wrap(children: [..._buildFeatureTags()]),

            SpaceHelper(h: 12.h),

            // Vehicle Images Section
            if (route?.vehicle?.pictures != null &&
                route!.vehicle!.pictures!.isNotEmpty) ...[
              SizedBox(
                height: 100.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: route!.vehicle!.pictures!.length,
                  itemBuilder: (context, index) {
                    final picture = route!.vehicle!.pictures![index];
                    final imageUrl = picture.presignedUrl ?? picture.url;

                    if (imageUrl == null || imageUrl.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    // Construct full image URL
                    String fullImageUrl;
                    if (imageUrl.startsWith('http://') ||
                        imageUrl.startsWith('https://')) {
                      fullImageUrl = imageUrl;
                    } else {
                      final cleanUrl = imageUrl.startsWith('/')
                          ? imageUrl.substring(1)
                          : imageUrl;
                      fullImageUrl = '${AppConstants.imageBaseUrl}$cleanUrl';
                    }

                    final urls = _buildVehicleImageUrls();
                    final urlIndex = _urlIndexForPictureIndex(index);
                    return GestureDetector(
                      onTap: () {
                        if (urls.isNotEmpty && urlIndex >= 0) {
                          Get.to(
                            () => FullScreenImageScreen(
                              imageUrls: urls,
                              initialIndex: urlIndex.clamp(0, urls.length - 1),
                            ),
                            fullscreenDialog: true,
                          );
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: CustomNetworkImageWidget(
                            imageUrl: fullImageUrl,
                            width: 100.w,
                            height: 100.h,
                            borderRadius: 8.r,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SpaceHelper(h: 16.h),
            ],

            // Request Booking Button
            CustomButton(
              onPressed: () {
                Get.toNamed(RequestBookingScreen.route, arguments: route);
              },
              title: 'Request Booking',
            ),
          ],
        ),
      ),
    );
  }
}
