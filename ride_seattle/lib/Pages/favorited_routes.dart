import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/localStorageProvider.dart';

class favorites_page extends StatefulWidget {
  const favorites_page({Key? key}) : super(key: key);

  @override
  State<favorites_page> createState() => _favorites_pageState();

}

class _favorites_pageState extends State<favorites_page> {

  var localStorage;
  var favoriteRoutes;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onAfterBuild(context));
  }

  void _onAfterBuild(BuildContext context) {
    localStorage = Provider.of<localStorageProvider>(context, listen: false);

    try{
      localStorage.loadData();
    }
    catch (e){
      print(e.toString());
    }

    favoriteRoutes = localStorage.getFavoriteRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Routes'),
      ),

      body:Column(
        children: [

          Consumer<localStorageProvider>(builder: (context, provider, listTile) {
            if (favoriteRoutes == null){
              return const SizedBox(
                width: 200.0,
                height: 300.0,
              );
            }
            else {
              return Expanded(
                child: ListView.builder(
                  key: const Key('favorite_routes'),
                  itemCount: favoriteRoutes.length,
                  itemBuilder: buildList,
                ),
              );
            }
          }),
        ],
      )
    );
  }


  Widget buildList(BuildContext context, int index) {
    return Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10)),
        child:
        Visibility(
            visible: true,
            child: Dismissible(
              key: Key(index.toString()),
              background: trashBackground(),
              onDismissed: (direction){

                //taskOrder.removeWhere((item) => item.id == taskOrder[index].id.toString());
                localStorage.removeRoute(index);
              },
              child:InkWell(
                  onTap: () {
                    //highlight the route
                    String clickedTaskTileId = favoriteRoutes[index];
                    //navigate to the home page
                    context.push('/');
                  },
                  child:ListTile(
                    //replace with name of stop/route
                    title: Text('Fav Route #$index'),
                    subtitle: Text('$index'),
                  ),
                ),
            )
        )
    );
  }

  Widget trashBackground(){
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      color: Colors.red,
      child: Icon(Icons.delete, color: Colors.white,),
    );
  }

}
