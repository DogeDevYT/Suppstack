import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// A custom widget for displaying a single news article
class ArticleCard extends StatelessWidget {
  final Map<String, dynamic> article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = article['urlToImage'];
    final sourceName = article['source']?['name'] ?? 'Unknown Source';
    final title = article['title'] ?? 'No Title';
    final articleUrl = article['url'];

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      clipBehavior: Clip.antiAlias, // Rounds the corners of the image
      child: InkWell(
        onTap: () {
          if (articleUrl != null) {
            _launchURL(articleUrl);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                // Show a loading indicator while the image loads
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                // Show a placeholder if the image fails to load
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 200,
                    child: Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sourceName.toUpperCase(),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({Key? key}) : super(key: key);

  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  List<dynamic> _articles = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    final apiKey = dotenv.env['NEWS_API_KEY'];
    if (apiKey == null || apiKey == 'YOUR_NEWS_API_KEY_HERE') {
      setState(() {
        _error = 'Please add your NewsAPI.org API key to your .env file.';
        _isLoading = false;
      });
      return;
    }

    // Query for health, fitness, nutrition, and pharmacology news
    final url = 'https://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _articles = data['articles'];
          _isLoading = false;
        });
      } else {
        final data = json.decode(response.body);
        setState(() {
          _error = 'Failed to load news: ${data['message']}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover News'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 16), textAlign: TextAlign.center),
                ))
              : ListView.builder(
                  itemCount: _articles.length,
                  itemBuilder: (context, index) {
                    return ArticleCard(article: _articles[index]);
                  },
                ),
    );
  }
}
