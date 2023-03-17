import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vinted_miage/clothes/clothes_details.dart';
import 'package:vinted_miage/users/user.dart';
import '../services/firestore.dart';
import 'clothe.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ClothesListPage extends StatelessWidget {
  const ClothesListPage({Key? key, required this.connectedUser})
      : super(key: key);

  final User connectedUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyClotheListPage(connectedUser: connectedUser),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyClotheListPage extends StatefulWidget {
  const MyClotheListPage({Key? key, required this.connectedUser})
      : super(key: key);

  final User connectedUser;

  @override
  _MyClotheListPageState createState() => _MyClotheListPageState();
}

class _MyClotheListPageState extends State<MyClotheListPage>
    with TickerProviderStateMixin {
  late User connectedUser;
  late String _selectedCategory;
  late List<Clothe> filteredClothesList;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'Tous';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: Theme.of(context).textTheme.displayMedium!,
        textAlign: TextAlign.center,
        child: FutureBuilder<List<Clothe>>(
            future: Firestore.getAllClothes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text(
                    "Something went wrong when calling the getAllClothes function");
              }
              if (!(snapshot.hasData && snapshot.data != null)) {
                return Scaffold(
                    body: Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                  color: const Color.fromARGB(181, 17, 229, 236),
                  size: 200,
                )));
              }
              if (snapshot.connectionState == ConnectionState.done) {
                List<Clothe> clothesList = snapshot.data!;
                List<String?> clothesCategories =
                    getClothesCategories(clothesList);

                _tabController = TabController(
                    vsync: this, length: clothesCategories.length + 1);

                if (_selectedCategory == 'Tous') {
                  filteredClothesList = clothesList;
                } else {
                  filteredClothesList = clothesList
                      .where((clothe) => clothe.type == _selectedCategory)
                      .toList();
                }

                return DefaultTabController(
                    length: (clothesCategories.length + 1),
                    child: Scaffold(
                        appBar: AppBar(
                          centerTitle: true,
                          backgroundColor:
                              const Color.fromARGB(181, 17, 229, 236),
                          bottom: TabBar(
                            labelColor: Colors.white,
                            dividerColor: Colors.white,
                            automaticIndicatorColorAdjustment: true,
                            controller: _tabController,
                            tabs: [
                              const Tab(text: "Tous"),
                              for (var category in clothesCategories)
                                Tab(text: Text(category!).data.toString())
                            ],
                            onTap: (tempIndex) {
                              _selectedCategory = tempIndex == 0
                                  ? 'Tous'
                                  : clothesCategories[tempIndex - 1]!;
                            },
                          ),
                          title: const Text('Liste des vêtements'),
                        ),
                        body: TabBarView(
                          physics: const BouncingScrollPhysics(),
                          dragStartBehavior: DragStartBehavior.down,
                          controller: _tabController,
                          children: <Widget>[
                            buildListofClothesByCategory("Tous", clothesList),
                            for (var clothesByCategory in clothesCategories)
                              buildListofClothesByCategory(
                                  clothesByCategory, clothesList)
                          ],
                        )));
              }
              return Scaffold(
                  body: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                color: const Color.fromARGB(181, 17, 229, 236),
                size: 200,
              )));
            }));
  }

  List<String?> getClothesCategories(List<Clothe> clothesList) {
    List<String?> clothesCategories = [];
    for (var clothe in clothesList) {
      if (!clothesCategories.contains(clothe.type)) {
        clothesCategories.add(clothe.type);
      }
    }
    return clothesCategories;
  }

  Widget buildListofClothesByCategory(
      String? choosedCategory, List<Clothe> clothesList) {
    List<Clothe> newClothesList;
    if (clothesList.isEmpty) {
      return const Center(child: Text('No clothes found'));
    }

    if (choosedCategory == "Tous") {
      newClothesList = clothesList;
    } else {
      newClothesList = clothesList
          .where((clothe) => clothe.type == choosedCategory)
          .toList();
    }

    return ListView.builder(
      itemCount: newClothesList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClothesDetails(
                    selectedClothe: newClothesList[index],
                    connectedUser: widget.connectedUser),
              ),
            );
          },
          child: ListTile(
            leading: Image.network(
              newClothesList[index].image.toString(),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(
                '${newClothesList[index].titre} - ${newClothesList[index].taille}'),
            subtitle: Text(newClothesList[index].marque.toString()),
            trailing: Text('${newClothesList[index].prix.toString()} €'),
          ),
        );
      },
    );
  }
}
