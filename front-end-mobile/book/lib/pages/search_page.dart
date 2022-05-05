import 'package:bookstore/views/action_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/api.dart';
import '../utils/dimensions.dart';
import '../utils/jsonParse/previewBooks.dart';
import 'package:darq/darq.dart';

import '../views/product_preview.dart';

class search_page extends StatefulWidget {
  const search_page({Key? key, required this.search}) : super(key: key);
  final String search;

  @override
  _search_pageState createState() => _search_pageState();
}


class _search_pageState extends State<search_page> {
  static final _categories = [
    "TextBook   ",
    "Novel Drama",
    "Poerty     ",
    "Drama      ",
    "Classics   "
  ];
  List<String>  _ordering=[
    "Time",
    "Name",
    "Selling Amount",
    "Stars",



  ];
  String selected="Time";

  String my_search="";
  void initState() {
    super.initState();
        () async {
      await allBooks();
      setState(() {
        // Update your UI with the desired changes.
      });
      my_search=widget.search;
      getProduct();
    }();

    // obtain shared preferences
  }

  List<PreviewBooks>? items;

  Future allBooks() async {
    final url = Uri.parse(API.allBooks);
    try {
      final response = await http.get(url);
      if (response.statusCode >= 200 && response.statusCode < 400) {
        final result = previewBooksFromJson(response.body);
        items = await result;
        //print(items[0].id);
        return result;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var list;

  Future<void> getProduct() async {
      List<PreviewBooks>? search_title =await
    items?.where((element) => element.title!.toLowerCase().contains(my_search.toLowerCase())).toList();
      List<PreviewBooks>? search_des =await
      items?.where((element) => element.description!.toLowerCase().contains(my_search.toLowerCase())).toList();
      //var exclusion = search_title?.except(search_des!);       // [1, 2]
      //var intersection = search_title?.intersect(search_des!); // [3, 4]
      var union = search_title?.union(search_des!);
      list = union;
      print(list);
      for (var i in list){
        print(i.title);
      }
    //print(_product?.title);
  }

  num stocks = 1;

/*
  Future<void> getProduct() async {
    print("aaaaaaaaaaaaaaaaaaa");
   // print(items[items.indexWhere((element) => element.title == widget.search)]);
    print("aaaaaaaaaaaaaaaaaaa");
    var searc_title=
    items.where((element) => element['title'].toLowerCase().contains(my_search.toLowerCase())).toList;
    print("my search is $my_search");
    print("items is $items");
    print("search title is #$searc_title");
    x=searc_title;
    var searc_desc=
        items.where((element) => element.description.toLowerCase().contains(my_search.toLowerCase())).toList;

    //_product = wanted;
    //print(_product?.title);
  }*/
  /*
  Future<void> getProduct() async {
    //PreviewBooks wanted = items[items.indexWhere((element) => element.title == widget.search)];
    items.Where((element) => element['title'].toLowerCase().contains(my_search.toLowerCase())).toList;

    //print(wanted.title);
  }*/
  @override

  Widget build(BuildContext context) {
    int len=list?.length ?? 0;
    //print(items[0].title);
    //getProduct();
    return Scaffold(
      appBar: ActionBar(),
      body: SingleChildScrollView(

        child: Column(
          children: [Row(children: [
            Expanded(child: TextFormField(
              onChanged: (value) { setState(() { my_search = value; }); },
            )),
            IconButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => search_page(

                    search: my_search,
                  )));
            }, icon: Icon(Icons.search))
          ]),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(_categories.length, (int index) {
                  return OutlinedButton(
                    onPressed: () {},
                    child: Container(
                      height: 50.0,
                      child: Text(_categories[index]),
                    ),
                  );
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [DropdownButton<String>(
    value: selected,
    icon: const Icon(Icons.arrow_downward),
    elevation: 16,
    style: const TextStyle(color: Colors.deepPurple),
    underline: Container(
    height: 2,
    color: Colors.deepPurpleAccent,
    ),
    onChanged: (String? newValue) {
    setState(() {
    selected = newValue!;
    if(selected=="Name"){
      list =list.sort((a, b) => a["title"].compareTo(b["title"]));
    }
    //if(selected =="Name"){
      //list.sort((a, b) => a.title.compareTo(b.title));;
      //for(var i in list){
        //print(list.title);}}
    });
    },
    items: <String>['Time', 'Most Seller', 'Rating', 'Name']
        .map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
    );
    }).toList(),),

  ],
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Expanded(
                    flex: 1,

                    child: Container(
                      child: Wrap(
                          alignment: WrapAlignment.spaceAround,
                        children:<Widget> [for(var i in list)Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ProductPreview(product: i),

                        ),]
                      ),
                    ),
                  )
                ],),
              ),
            ),
          ],
        ),
      ),
      /*body: SizedBox(
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Expanded(
      flex: 1,
      child: Wrap(
      alignment: WrapAlignment.spaceAround,
      children: List.generate(
      list.length,
      (index) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ProductPreview(
      product: list[index],
      ),
      )),
    ),
    ),
    ],
    )),
      )*/
    );
  }
}
