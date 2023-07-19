import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/news_list.dart';
import 'news_description.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isLoading = false;
  String? errorMessage;
  NewsList? newsList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      loadNews();
    });
  }

  void loadNews() async{
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    var dio = Dio();
    try {
      var response = await dio.get('https://newsapi.org/v2/everything?q=latest&sortBy=publishedAt&apiKey=1c0e28c0028f4185ab57aa2286568608');
      setState(() {
        newsList = NewsList.fromJson(response.data);
        isLoading = false;
      });
    } catch (e) {
      DioException exp = e as DioException;
      Response<dynamic> res = exp.response as Response<dynamic>;
      setState(() {
        isLoading = false;
        errorMessage = res.data['message'] as String;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Latest News",style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            IconButton(onPressed: (){
              loadNews();
            }, icon: const Icon(Icons.refresh,color: Colors.white,))
          ],
          backgroundColor: Colors.blue.withOpacity(0.9),
        ),
        body: (isLoading) ? const Center(child: CircularProgressIndicator(color: Colors.red,)) :
        (errorMessage != null) ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(errorMessage ?? 'Something Went Wrong!',textAlign: TextAlign.center,
                  style:
                  const TextStyle(fontSize: 18,color: Colors.red, fontWeight: FontWeight.w900),),
              ),
              const SizedBox(height: 30,),
              GestureDetector(
                onTap: () {
                  loadNews();
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: const Text(
                    'TRY AGAIN',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              )
            ],
          ),
        ) :
        Column(
          children: [
            const SizedBox(height: 30,),
            Expanded(
              child: ListView.builder(
                itemCount: (newsList!=null) ? newsList!.articles!.length : 0,
                itemBuilder: (ctx, idx) {
                  return Container(
                    margin: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(17)),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(72, 163, 237, 0.3), //New
                            spreadRadius: 2.5,
                            blurRadius: 2,
                            offset: Offset(2, 3))
                      ],
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(17)),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(newsList!.articles![idx].title!,
                                      style: const TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.w600)),
                                ),
                                const SizedBox(height: 16,),
                                Flexible(
                                  child: Text(newsList!.articles![idx].publishedAt!,
                                      style: const TextStyle(
                                          fontSize: 12,color: Colors.grey, fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>  NewsDescription(articles: newsList!.articles![idx],)
                                    )
                                );
                              },
                              child: const Icon(Icons.arrow_forward)
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }


}
