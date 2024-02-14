import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'data.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
main() {
  runApp(myApp());
}

class myApp extends StatefulWidget {
  const myApp({super.key});
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  int soura = 0;
  int max = -1, min = -1;
  final player = AudioPlayer();

  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    player.currentIndexStream.listen((index) {
      setState(() {
        player.currentIndex;
      });
      });
    return MaterialApp(
      theme: ThemeData(fontFamily: 'myFont'),
      home: Scaffold(
        drawer: Drawer(
          child: Container(
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        data[i]['name'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      trailing: Text(
                        (i + 1).toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          for (int k = min != -1 ? min : 0; k <= max; k++) {
                            data[soura]['states'][k] = false;
                          }
                          max = min = -1;

                          soura = i;
                        });
                      },
                    ),
                  );
                }),
          ),
        ),
        appBar: AppBar(
          title: Text(
            'سورة ' + data[soura]['name'],
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(children: [
          Expanded(
            flex: 9,
            child: ListView.builder(
              itemCount: data[soura]['verses'].length,
              itemBuilder: (context, i) {
                return Card(
                  elevation: 4,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: ListTile(
                    tileColor: data[soura]['states'][i]
                        ? Colors.yellow[300]
                        : Color.fromRGBO(241, 243, 244, 1),
                    title: Text(
                      (data[soura]['verses'][i]),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: (i ==
                                      min +
                                          (player.currentIndex == null
                                              ? 0
                                              : player.currentIndex as int) &&
                                  player.playing && data[soura]['states'][i])
                              ? Colors.blue[600]
                              : Colors.black),
                    ),
                    trailing: Text(
                      (i + 1).toString(),
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      setState(() {
                        if (min == -1) {
                          data[soura]['states'][i] = true;
                          max = min = i;
                        } else if (max == min && min == i) {
                          data[soura]['states'][i] = false;
                          max = min = -1;
                        } else if (min == i) {
                          data[soura]['states'][i] = false;
                          min = i + 1;
                        } else if (max == i) {
                          data[soura]['states'][i] = false;
                          max = i - 1;
                        } else if (i + 1 == min) {
                          data[soura]['states'][i] = true;
                          min = i;
                        } else if (max + 1 == i) {
                          data[soura]['states'][i] = true;
                          max = i;
                        }
                        if (player.playing) {
                          player.pause();
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                color: Color.fromRGBO(248, 249, 250, 1),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Card(
                          elevation: 6,
                          margin: EdgeInsets.only(bottom:screenHeight * 0.01 ),
                          child: IconButton(
                            alignment: Alignment.center,
                              
                              icon: Icon(
                                  !player.playing ? Icons.play_arrow : Icons.pause),
                              iconSize: screenHeight * 0.07,
                              onPressed: min == -1
                                  ? null
                                  : () {
                                      setState(() {
                                        if (player.playing) {
                                          player.pause();
                          
                                          return;
                                        }
                          
                                        final playlist = ConcatenatingAudioSource(
                                            useLazyPreparation: true,
                                            shuffleOrder: DefaultShuffleOrder(),
                                            children: () {
                                              List<AudioSource> list = [];
                                              int k = 1;
                                              for (int i = 0; i < soura; i++) {
                                                k += (data[i]['states'].length
                                                    as int);
                                              }
                                              for (int i = min + k;
                                                  i <= max + k;
                                                  i++) {
                                                String mp3Url =
                                                    'https:\/\/cdn.islamic.network\/quran\/audio\/128\/ar.alafasy\/${i}.mp3';
                                                list.add(AudioSource.uri(
                                                    Uri.parse(mp3Url)));
                                              }
                                              return list;
                                            }());
                          
                                        player.setAudioSource(playlist,
                                            initialIndex: 0,
                                            initialPosition: Duration.zero);
                                        player.setLoopMode(LoopMode.all);
                                        player.play();
                                      });
                                    }),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ]),
      ),
    );
  }
}