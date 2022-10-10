import 'package:flutter/material.dart';
import 'package:youtube/model/Video.dart';
import 'package:youtube/telas/CustomYoutubePlayer.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../Api.dart';

class Inicio extends StatefulWidget {
  String pesquisa;

  Inicio(this.pesquisa);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  _listarVideos(String pesquisa){

    Api api = Api();
    return api.pesquisar(pesquisa);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("chamado 1 - initState");
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("chamado 2 - didChangeDependencies");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("chamdo 4 - dispose");
  }

  @override
  Widget build(BuildContext context) {

    print("chamado 3 - build");



    return FutureBuilder<List<Video>>(
      future: _listarVideos(widget.pesquisa),
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if( snapshot.hasData ){

              return ListView.separated(
                  itemBuilder: (context, index){

                    Video video = snapshot.data![index];

                    return GestureDetector(
                      onTap: (){

                        Navigator.push(
                            context,
                            PageRouteBuilder(pageBuilder: (context, animation, animation2){
                              return CustomYoutubePlayer(video.id!);
                            })
                        );

                      },
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(video.imagem!)
                                )
                            ),
                          ),
                          ListTile(
                            title: Text( video.titulo! ),
                            subtitle: Text( video.canal! ),
                          )
                        ],
                      ),
                    );

                  },
                  separatorBuilder: (context, index) => Divider(
                      height: 3,
                      color: Colors.red
                  ),
                  itemCount: snapshot.data!.length
              );

            } else {
              return Center(
                child: Text("Nenhum dado a ser exibido!"),
              );
            }
            break;
        }
        return Text("");
      },
    );
  }
}
