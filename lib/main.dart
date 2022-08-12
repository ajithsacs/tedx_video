import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

var baseapi = "https://backend.tedit.org/api/video";

void main() {
  runApp(const MaterialApp(
    title: "TEDx Video",
    home: TedxApp(),
  ));
}

class TedxApp extends StatefulWidget {
  const TedxApp({Key? key}) : super(key: key);

  @override
  State<TedxApp> createState() => _TedxAppState();
}

class _TedxAppState extends State<TedxApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tedx Video"),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
            future: fetchAlbum(baseapi),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!["data"];
                return RefreshIndicator(onRefresh: () {
                  return Future.delayed(const Duration(seconds: 15), () {
                    setState(() {
                      baseapi = snapshot.data!["next_page_url"];
                    });
                  });
                }, child: OrientationBuilder(builder: (context, orientation) {
                  int count = (orientation == Orientation.portrait ? 2 : 4);
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: count,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        var images = data[index]["video_thumbnail"];
                        String topic = data[index]["title"];
                        int time = data[index]["talk_duration"];
                        double newtime = time / 60;
                        return Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            child: Column(
                              children: [
                                Stack(children: [
                                  AspectRatio(
                                    aspectRatio: 3 / 2,
                                    child: Ink.image(
                                      image: NetworkImage(images),
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  Positioned(
                                    child: Text(
                                      "${(newtime * 100).round() / 100}",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    bottom: 16,
                                    left: 16,
                                    right: 16,
                                  ),
                                  // Positioned(child: Text(topic))
                                ]),
                                Padding(
                                  padding: const EdgeInsets.all(5)
                                      .copyWith(bottom: 0),
                                  child: Text(
                                    topic,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ));

                        // SafeArea(
                        //     child: Hero(
                        //         tag: index,
                        //         child: Card(
                        //           child: Container(
                        //             decoration: BoxDecoration(
                        //               image: DecorationImage(
                        //                 image: NetworkImage(images),
                        //                 fit: BoxFit.cover,
                        //               ),
                        //             ),
                        //           ),
                        //         )));
                      }
                      //   Card(
                      //     child: Column(
                      //       children: [
                      //         Image.network(images),
                      //         ListTile(
                      //             leading:
                      //                 Text("${(newtime * 100).round() / 100}")),
                      //         Text(topic),
                      //       ],
                      //     ),
                      //   );
                      // },
                      );
                }));
              } else if (snapshot.hasError) {
                const Center(
                  child: Center(
                    child: Text("Has some Error"),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));

    //    GridView.builder(
    //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //         crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
    //     itemCount: 20,
    //     itemBuilder: (context, index) {
    //       return Card(
    //         child: Column(
    //           children: [

    //             Image.network(
    //                 "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png"),
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // );
  }

  Future<Map<String, dynamic>> fetchAlbum1(api) async {
    final responce = await http.get(Uri.parse(api));
    if (responce.statusCode == 200) {
      final decodeapistring = jsonDecode(responce.body);
      setState(() {
        decodeapistring;
      });
      return decodeapistring;
    } else {
      throw Exception();
    }
  }

  Future<Map<String, dynamic>> fetchAlbum(baseapi) async {
    final responce = await http.get(Uri.parse(baseapi));
    
    if (responce.statusCode == 200) {
      final decodeapistring = jsonDecode(responce.body);
      setState(() {
        decodeapistring;
      });
      return decodeapistring;
    } else {
      throw Exception();
    }
  }
}
