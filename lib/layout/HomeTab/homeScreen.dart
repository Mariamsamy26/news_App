import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/layout/HomeTab/searchTap.dart';

import '../../bloc/dstate/d_logic.dart';
import '../../bloc/dstate/d_state.dart';
import '../../bloc/newstate/NewsLogic.dart';
import '../../bloc/newstate/NewsState.dart';
import '../../color_manager.dart';
import '../../components/CustomNews.dart';
import '../../components/CustomDivider.dart';
import '../../model/categoryModel.dart';
import 'CategoryNews.dart';
import 'NewsDetails.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'Home Screen';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsLogic()..getNewsRandom(),
        ),
        BlocProvider(
          create: (context) => DLogic()..createDatabaseAndTable(),
        ),
      ],
      child: BlocConsumer<NewsLogic, NewsState>(
        listener: (context, state) {},
        builder: (context, state) {
          NewsLogic newsLogic = BlocProvider.of<NewsLogic>(context);
          DLogic dLogic = BlocProvider.of<DLogic>(context);

          return Scaffold(
            appBar: AppBar(
              title: Text(
                "what's now",
                style: GoogleFonts.sevillana(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: ColorManager.primaryColor,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (C) => SearchScreen()),
                    );
                  },
                  icon: Icon(Icons.search, size: 35, color: ColorManager.primaryColor),
                )
              ],
            ),
            body: Container(
              color: Theme.of(context).colorScheme.primary,
              child: ListView(
                children: [
                  CustomDivider(labelText: 'CATEGORIES'),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < Categorylist.length; i++)
                          Card(
                            child: MaterialButton(
                              padding: EdgeInsets.zero,
                              child: SizedBox(
                                width: 170,
                                height: 100,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.asset(
                                        Categorylist[i].imgPath,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        Categorylist[i].label,
                                        style: const TextStyle(
                                          color: ColorManager.colorOffwhite,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (C) => CategoryNews(
                                    category: Categorylist[i].label,
                                  ),
                                ));
                              },
                            ),
                          )
                      ],
                    ),
                  ),
                  CustomDivider(labelText: 'Top news'),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: BlocBuilder<NewsLogic, NewsState>(
                      builder: (context, state) {
                        if (state is InitNews) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is Random_news) {
                          var newsModel = state.newsResponse;
                          var articlesList = newsModel?.articles;

                          if (articlesList != null && articlesList.isNotEmpty) {
                            return Column(
                              children: [
                                for (var article in articlesList)
                                  if (article.urlToImage != null)
                                    BlocBuilder<DLogic, DState>(
                                      builder: (context, dState) {
                                        return CustomNews(
                                          iconSec: dLogic.isFavorite(article.title.toString())
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          urlImage: article.urlToImage ?? '',
                                          title: article.title ?? 'No title',
                                          linkN: article.url != null ? Uri.parse(article.url!) : Uri(),
                                          onTap: () {
                                            dLogic.insertHistoryElement(
                                              title: article.title.toString(),
                                              url: article.url.toString(),
                                              imageUrl: article.urlToImage.toString(),
                                            );
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => NewsDetails(
                                                  url: article.url ?? '',
                                                ),
                                              ),
                                            );
                                          },
                                          onPressedSec: () async {
                                            await dLogic.favNews(
                                              article.title.toString(),
                                              article.url.toString(),
                                              article.urlToImage.toString(),
                                            );
                                          },
                                        );
                                      },
                                    ),
                              ],
                            );
                          } else {
                            return const Center(child: Text('No news available'));
                          }
                        } else if (state is Get_newsD) {
                          return const Center(child: Text('Error loading news'));
                        } else {
                          return const Center(child: Text('No news available'));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<CategoryModel> Categorylist = [
    CategoryModel(imgPath: 'assets/images/Business.webp', label: 'Business'),
    CategoryModel(imgPath: 'assets/images/politics.webp', label: 'politics'),
    CategoryModel(imgPath: 'assets/images/Technology.jpeg', label: 'Technology'),
    CategoryModel(imgPath: 'assets/images/Science.jpeg', label: 'Science'),
    CategoryModel(imgPath: 'assets/images/sports.jpeg', label: 'sports'),
    CategoryModel(imgPath: 'assets/images/Health.jpeg', label: 'Health'),
  ];
}
