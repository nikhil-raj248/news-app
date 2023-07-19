import 'package:flutter/material.dart';

import '../models/news_list.dart';

class NewsDescription extends StatefulWidget {
  const NewsDescription({Key? key,required this.articles}) : super(key: key);

  final Articles articles;

  @override
  State<NewsDescription> createState() => _NewsDescriptionState();
}

class _NewsDescriptionState extends State<NewsDescription> {

  Articles? articles;

  @override
  void initState() {
    super.initState();
    articles = widget.articles;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          title: const Text("News Article",style: TextStyle(color: Colors.white),),
          // actions: <Widget>[
          //   IconButton(onPressed: (){
          //     loadNews();
          //   }, icon: const Icon(Icons.refresh,color: Colors.white,))
          // ],
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text((articles!.title!=null) ? articles!.title! : '-',
                    // textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 22,color: Colors.white, fontWeight: FontWeight.w900)),
                SizedBox(height: 10,),
                Text('Author : '+((articles!.author !=null) ? articles!.author! : '-'),
                    style: const TextStyle(
                        fontSize: 15,color: Colors.white, fontWeight: FontWeight.w600)),
                Text(('Published At : '+ ((articles!.publishedAt!=null) ? articles!.publishedAt! : '-')),
                    style: const TextStyle(
                        fontSize: 15,color: Colors.white, fontWeight: FontWeight.w600)),
                SizedBox(height: 15,),
                if(articles!.urlToImage != null && articles!.urlToImage!.isNotEmpty)
                  Container(
                    // margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey,width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    child: Image.network(
                    articles!.urlToImage!,
                    fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.amber,
                        alignment: Alignment.center,
                        child: const Text(
                          'Whoops!',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    },
                ),
                  ),
                const SizedBox(height: 30,),
                Text((articles!.description!=null) ? articles!.description!+'...' : '-',
                    style: const TextStyle(
                        fontSize: 18,color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 40,),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey,width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Full Article At : ',style: TextStyle(
                          fontSize: 14,color: Colors.white, fontWeight: FontWeight.w600)),
                      Flexible(
                        child: Text((((articles!.url!=null) ? articles!.url! : '-')),
                            style: const TextStyle(
                                fontSize: 14,color: Colors.blue, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
