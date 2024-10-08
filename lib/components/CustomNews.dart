import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/color_manager.dart';
import 'ShareSheetTap.dart';

class CustomNews extends ShareSheetTap {
  final String urlImage;
  final String title;
  final VoidCallback onTap;
  final IconData iconSec;
  final VoidCallback onPressedSec;

  CustomNews({
    required this.urlImage,
    required this.title,
    required this.onTap,
    required super.linkN,
    required this.iconSec,
    required this.onPressedSec,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: ColorManager.colorGray,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  CachedNetworkImage(
                    imageUrl: urlImage,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        color: ColorManager.primaryColor,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  ),

                  // Share and Favorite icons
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShareSheetTap(linkN: linkN),
                        IconButton(
                          onPressed: onPressedSec,
                          icon: Icon(
                            iconSec,
                            color: Theme.of(context).colorScheme.primary,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: GoogleFonts.abyssinicaSil(
                  fontSize: 20,
                  color: ColorManager.colorGrayblack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
