import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

final supabase = Supabase.instance.client;

class ImageUploader extends StatefulWidget {
  final Map<String, dynamic> stackItem;
  // --- KEY CHANGE: The session is now nullable (Session?) ---
  final Session? session;
  final VoidCallback onUpdate;

  const ImageUploader({
    Key? key,
    required this.stackItem,
    required this.session,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  bool _isUploadingImage = false;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.stackItem['image_url'];
  }

  Future<void> _pickAndUploadImage() async {
    // --- KEY CHANGE: Add a null check for the session ---
    if (widget.session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot upload image: User is not logged in.'), backgroundColor: Colors.red),
      );
      return;
    }

    final picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
    );

    if (imageFile == null) {
      return;
    }

    setState(() => _isUploadingImage = true);
    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      // Use the non-nullable session object inside the check
      final filePath = '${widget.session!.user.id}/${widget.stackItem['id']}.$fileExt';

      await supabase.storage.from('supplement-images').uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final imageUrlResponse = supabase.storage
          .from('supplement-images')
          .getPublicUrl(filePath);
          
      await supabase
          .from('user_stacks')
          .update({'image_url': imageUrlResponse})
          .eq('id', widget.stackItem['id']);

      setState(() {
        _imageUrl = imageUrlResponse;
      });

      widget.onUpdate(); // Notify parent to refetch

    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: ${error.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingImage = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Your Image', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _imageUrl == null
                ? Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: Text('No Image')),
                  )
                : Image.network(_imageUrl!, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isUploadingImage ? null : _pickAndUploadImage,
              icon: const Icon(Icons.upload_file),
              label: Text(_isUploadingImage ? 'Uploading...' : 'Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
