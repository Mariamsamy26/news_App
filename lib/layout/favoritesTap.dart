import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/dstate/d_logic.dart';
import '../bloc/dstate/d_state.dart';
import '../color_manager.dart';
import '../components/CustomNews.dart';
import 'HomeTab/NewsDetails.dart';

class FavororitesTab extends StatelessWidget {
  static const String routeName = 'Favororites Screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DLogic()..createDatabaseAndTable(),
        child: BlocConsumer<DLogic, DState>(
          listener: (context, state) {},
          builder: (context, state) {
            DLogic DObject = BlocProvider.of(context);
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Favororites",
                  style: GoogleFonts.sevillana(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: ColorManager.primaryColor,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                centerTitle: true,
              ),
              body: Container(
                color: Theme.of(context).colorScheme.primary,
                width: double.infinity,
                height: double.infinity,
                child: DObject.favouriteList.isEmpty
                    ? Center(
                        child: Text(
                          "NO Favourite now",
                          style: GoogleFonts.abhayaLibre(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (var favouriteElement
                                  in DObject.favouriteList)
                                if (favouriteElement["imageUrl"] != null)
                                  CustomNews(
                                    iconSec:Icons.favorite,
                                    urlImage:
                                        favouriteElement["imageUrl"] ?? '',
                                    title:
                                        favouriteElement["title"] ?? 'No title',
                                    linkN: favouriteElement["url"] != null
                                        ? Uri.parse(favouriteElement["url"])
                                        : Uri(),

                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => NewsDetails(
                                            url: favouriteElement["url"] ?? '',
                                          ),
                                        ),
                                      );
                                    }, onPressedSec: () {
                                      DObject.deleteFavouriteElement(title: favouriteElement["title"]); },
                                  ),
                            ],
                          ),
                        ),
                      ),
              ),
            );
          },
        ));
  }
}
