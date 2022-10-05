import 'package:flutter/material.dart';
import 'package:youtube/model/Video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  Widget build(BuildContext context) {



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

                        //incluir player de vídeo
                        YoutubePlayerBuilder(
                          player: YoutubePlayer(
                            controller: YoutubePlayerController.of(context)!,
                          ),
                          builder: (context, widget){
                            return Container();
                          },
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
