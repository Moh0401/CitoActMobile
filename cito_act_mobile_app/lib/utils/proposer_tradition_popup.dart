import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProposerTraditionPopup extends StatefulWidget {
  const ProposerTraditionPopup({super.key});

  @override
  _ProposerTraditionPopupState createState() => _ProposerTraditionPopupState();
}

class _ProposerTraditionPopupState extends State<ProposerTraditionPopup> {
  XFile? _selectedImage;
  File? _selectedVideo;
  File? _selectedDocument;
  String? _recordedAudioPath;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _praticiensController = TextEditingController();
  final TextEditingController _menacesController = TextEditingController();
  final TextEditingController _origineController = TextEditingController();

  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  Future<void> _submitData() async {
    try {
      final String titre = _titleController.text;
      final String description = _descriptionController.text;
      final String praticiens = _praticiensController.text;
      final String menaces = _menacesController.text;
      final String origine = _origineController.text;

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String firstName = userDoc['firstName'] ?? '';
      String lastName = userDoc['lastName'] ?? '';
      String? profilePic = userDoc.data() is Map ? (userDoc.data() as Map<String, dynamic>)['imageUrl'] : null;

      Map<String, dynamic> traditionData = {
        'titre': titre,
        'description': description,
        'praticiens': praticiens,
        'menaces': menaces,
        'origine': origine,
        'valider': false,
        'userId': user.uid,
        'firstName': firstName,
        'lastName': lastName,
      };

      if (profilePic != null) {
        traditionData['profilePic'] = profilePic;
      }
      if (_selectedImage != null) {
        String imagePath = 'traditions/images/${DateTime.now().millisecondsSinceEpoch}.png';
        UploadTask task = FirebaseStorage.instance.ref(imagePath).putFile(File(_selectedImage!.path));
        TaskSnapshot snapshot = await task;
        String imageUrl = await snapshot.ref.getDownloadURL();
        traditionData['imageUrl'] = imageUrl;
      }

      if (_selectedVideo != null) {
        String videoPath = 'traditions/videos/${DateTime.now().millisecondsSinceEpoch}.mp4';
        UploadTask task = FirebaseStorage.instance.ref(videoPath).putFile(_selectedVideo!);
        TaskSnapshot snapshot = await task;
        String videoUrl = await snapshot.ref.getDownloadURL();
        traditionData['videoUrl'] = videoUrl;
      }

      if (_selectedDocument != null) {
        String documentPath = 'traditions/documents/${DateTime.now().millisecondsSinceEpoch}.pdf';
        UploadTask task = FirebaseStorage.instance.ref(documentPath).putFile(_selectedDocument!);
        TaskSnapshot snapshot = await task;
        String documentUrl = await snapshot.ref.getDownloadURL();
        traditionData['documentUrl'] = documentUrl;
      }

      if (_recordedAudioPath != null) {
        String audioPath = 'traditions/audio/${DateTime.now().millisecondsSinceEpoch}.m4a';
        UploadTask task = FirebaseStorage.instance.ref(audioPath).putFile(File(_recordedAudioPath!));
        TaskSnapshot snapshot = await task;
        String audioUrl = await snapshot.ref.getDownloadURL();
        traditionData['audioUrl'] = audioUrl;
      }

      // Ajouter le document à Firestore avec les données de l'utilisateur
      await FirebaseFirestore.instance.collection('traditions').add(traditionData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tradition proposée avec succès !')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la soumission : $e')),
      );
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(RecordConfig(), path: tempPath);
        setState(() {
          _recordedAudioPath = tempPath;
          _isRecording = true;
        });
      }
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        if (path != null) {
          _recordedAudioPath = path;
        }
      });
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }

  Future<void> _playRecording() async {
    if (_recordedAudioPath != null) {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          _isPlaying = false;
        });
      } else {
        await _audioPlayer.play(DeviceFileSource(_recordedAudioPath!));
        setState(() {
          _isPlaying = true;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _selectedVideo = File(video.path);
      });
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _selectedDocument = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF6A96CE),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _selectedImage != null
                    ? Image.file(
                  File(_selectedImage!.path),
                  width: 400,
                  height: 200,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/images/default_action_image.png',
                  width: 400,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: const Icon(
                    Icons.cloud_upload,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(_titleController, 'Titre'),
                const SizedBox(height: 10),
                _buildTextField(_descriptionController, 'Description', maxLines: 2),
                const SizedBox(height: 10),
                _buildTextField(_praticiensController, 'Praticiens'),
                const SizedBox(height: 10),
                _buildTextField(_menacesController, 'Menaces'),
                const SizedBox(height: 10),
                _buildTextField(_origineController, 'Origine'),
                const SizedBox(height: 10),
                _buildAudioControls(),
                const SizedBox(height: 10),
                _buildVideoPicker(),
                const SizedBox(height: 10),
                _buildDocumentPicker(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitData,
                  child: const Text('Soumettre', style: TextStyle(color: Color(0xFF2F313F)),),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),

                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
    );
  }

  Widget _buildAudioControls() {
    return Column(
      children: [
        if (_recordedAudioPath != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isPlaying ? 'Playing Audio...' : 'Audio Recorded',
                style: const TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                color: Colors.white,
                onPressed: _playRecording,
              ),
            ],
          ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _isRecording ? _stopRecording : _startRecording,
          child: Icon(
            _isRecording ? Icons.stop : Icons.mic,
            size: 30,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPicker() {
    return GestureDetector(
      onTap: _pickVideo,
      child: Row(
        children: [
          const Icon(Icons.video_call, color: Colors.white, size: 30),
          const SizedBox(width: 10),
          Text(
            _selectedVideo != null ? 'Vidéo sélectionnée' : 'Sélectionner une vidéo',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentPicker() {
    return GestureDetector(
      onTap: _pickDocument,
      child: Row(
        children: [
          const Icon(Icons.attach_file, color: Colors.white, size: 30),
          const SizedBox(width: 10),
          Text(
            _selectedDocument != null ? 'Document sélectionné' : 'Sélectionner un document',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
