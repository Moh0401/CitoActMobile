import 'package:cito_act_mobile_app/views/comment_tradition_page.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../models/tradition_model.dart';
import '../utils/bottom_nav_bar.dart';
import '../services/tradition_service.dart';


class TraditionDetailPage extends StatefulWidget {
  final TraditionModel tradition;
  final int selectedIndex;
  final Function(int) onItemTapped;

  TraditionDetailPage({
    required this.tradition,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  _TraditionDetailPageState createState() => _TraditionDetailPageState();
}

class _TraditionDetailPageState extends State<TraditionDetailPage> {
  bool _isLiked = false; // État pour gérer si le projet est liké
  int _likesCount = 0;   // État pour le nombre de likes
  VideoPlayerController? _videoController;
  AudioPlayer? _audioPlayer;
  String? localPdfPath;

  TraditionService traditionServices = TraditionService();


  Future<String> downloadAndSavePdf(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/document.pdf');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  Future<void> downloadPdf() async {
    if (widget.tradition.documentUrl == null) return;

    final status = await Permission.storage.request();
    if (status.isGranted) {
      final externalDir = await getExternalStorageDirectory();
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final fileName = 'document_$id.pdf';
      final filePath = '${externalDir!.path}/$fileName';

      final response = await http.get(Uri.parse(widget.tradition.documentUrl!));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Document téléchargé dans $filePath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission de stockage refusée')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.tradition.videoUrl != null && widget.tradition.videoUrl!.isNotEmpty) {
      _videoController = VideoPlayerController.network(widget.tradition.videoUrl!)
        ..initialize().then((_) {
          setState(() {});
        });
    }
    if (widget.tradition.audioUrl != null && widget.tradition.audioUrl!.isNotEmpty) {
      _audioPlayer = AudioPlayer();
      _audioPlayer?.setUrl(widget.tradition.audioUrl!);
    }
    if (widget.tradition.documentUrl != null) {
      downloadAndSavePdf(widget.tradition.documentUrl!).then((path) {
        setState(() {
          localPdfPath = path;
        });
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  void _replayVideo() {
    if (_videoController != null) {
      _videoController!.seekTo(Duration.zero);
      _videoController!.play();
    }
  }

  void _seekForward() {
    if (_videoController != null) {
      final newPosition = _videoController!.value.position + Duration(seconds: 10);
      _videoController!.seekTo(newPosition);
    }
  }

  void _seekBackward() {
    if (_videoController != null) {
      final newPosition = _videoController!.value.position - Duration(seconds: 10);
      _videoController!.seekTo(newPosition);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.tradition.imageUrl != null
                  ? Image.network(
                widget.tradition.imageUrl!,
                fit: BoxFit.cover,
              )
                  : Container(color: Colors.grey[300]),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (widget.tradition.profilePic != null)
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.tradition.profilePic!),
                          radius: 20,
                        ),
                      SizedBox(width: 8),
                      Text(
                        '${widget.tradition.firstName} ${widget.tradition.lastName}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.tradition.titre.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6887B0),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.tradition.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Praticiens: ${widget.tradition.praticiens}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Menaces: ${widget.tradition.menaces}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Origine: ${widget.tradition.origine}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),

                  SizedBox(height: 16),

                  if (_videoController != null && _videoController!.value.isInitialized)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vidéo:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        ),
                        SizedBox(height: 8),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _videoController!.value.isPlaying
                                        ? _videoController!.pause()
                                        : _videoController!.play();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF6887B0),
                                ),
                                child: Icon(
                                  _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _replayVideo,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF6887B0),
                                ),
                                child: Icon(
                                  Icons.replay,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _seekBackward,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF6887B0),
                                ),
                                child: Icon(
                                  Icons.fast_rewind,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _seekForward,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF6887B0),
                                ),
                                child: Icon(
                                  Icons.fast_forward,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),

                  if (widget.tradition.audioUrl != null && widget.tradition.audioUrl!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Audio:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _audioPlayer!.play();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6887B0),
                              ),
                              child: Icon(Icons.play_arrow,
                                color: Colors.white,),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _audioPlayer!.pause();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6887B0),
                              ),
                              child: Icon(Icons.pause,
                                color: Colors.white,),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    ),

                  if (localPdfPath != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Document:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 300,
                          child: PDFView(
                            filePath: localPdfPath!,
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: downloadPdf,
                          icon: Icon(Icons.download),
                          label: Text('Télécharger le document'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6887B0),
                            foregroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),

                  Row(
                    children: [
                      IconButton(
                        icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
                        onPressed: () {
                          setState(() {
                            _isLiked = !_isLiked;
                          });
                          // Incrémenter les likes si l'utilisateur aime le projet
                          if (_isLiked) {
                            traditionServices.incrementLikes(widget.tradition.traditionId, widget.tradition.likes ?? 0);
                          }
                        },
                      ),
                      Text('${widget.tradition.likes} likes'), // Affiche le nombre de likes
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentTraditionPage(TraditionId: widget.tradition.traditionId), // Passer l'ID du projet ici
                            ),
                          );
                        },
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: widget.selectedIndex,
        onItemTapped: widget.onItemTapped,
      ),
    );
  }
}