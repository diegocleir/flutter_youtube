import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:youtube/model/Video.dart';

const CHAVE_YOUTUBEAPI = "AIzaSyD2-UMIRU_oDkgZhfaQqq8jIR21Y9zNIR0";
const ID_CANAL = "UCVHFbqXqoYvEWM1Ddxl0QDg";
const URL_BASE = "https://www.googleapis.com/youtube/v3/";

class Api{
  Future<List<Video>>? pesquisar(String pesquisa) async {

    var url = URL_BASE + 'search'
        '?part=snippet'
        '&channelId=$ID_CANAL'
        '&type=video'
        '&maxResults=20'
        '&order=date'
        '&key=$CHAVE_YOUTUBEAPI'
        '&q=$pesquisa';

    print(url);

    http.Response response = await http.get(
        Uri.parse(url)
    );

    if( response.statusCode == 200 ){

      Map<String, dynamic> dadosJson = json.decode( response.body );

      List<Video> videos = dadosJson["items"].map<Video>(
              (map){
            return Video.fromJson(map);
            //return Video.converterJson(map);
          }
      ).toList();

      return videos;

      //print("Resultado: " + videos.toString() );

      /*
      for(var video in dadosJson["items"]){
        print("Resultado: " + video.toString() );
      }*/
      //print("resultado: " + dadosJson["items"][0].toString() );

    } else {

      print("resultado: " + response.statusCode.toString());

    }
  }
}