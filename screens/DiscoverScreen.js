import { useEffect, useState } from 'react';
import { ActivityIndicator, Alert, FlatList, Image, Linking, SafeAreaView, Text, TouchableOpacity, View } from 'react-native';
import { styles } from '../styles/globalStyles';

// Replace this with your own free API key from newsapi.org
const API_KEY = process.env.EXPO_PUBLIC_NEWSAPI_APIKEY
const API_URL = `https://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=${API_KEY}`;

// A new component to render each article card
const ArticleCard = ({ article }) => {
  const handlePress = () => {
    // Open the article URL in the device's default browser
    Linking.openURL(article.url).catch(err => Alert.alert('Error', 'Could not open the article.'));
  };

  return (
    <TouchableOpacity style={styles.articleCard} onPress={handlePress}>
      {article.urlToImage ? (
        <Image source={{ uri: article.urlToImage }} style={styles.articleImage} />
      ) : (
        <View style={styles.articleImagePlaceholder} />
      )}
      <View style={styles.articleTextContainer}>
        <Text style={styles.articleSource}>{article.source.name}</Text>
        <Text style={styles.articleTitle}>{article.title}</Text>
      </View>
    </TouchableOpacity>
  );
};


const DiscoverScreen = () => {
  const [loading, setLoading] = useState(true);
  const [articles, setArticles] = useState([]);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchNews = async () => {
      // A quick check to ensure a real API key is inserted.
      if (API_KEY === 'YOUR_NEWS_API_KEY_HERE') {
        setError('Please add your NewsAPI.org API key to fetch news.');
        setLoading(false);
        return;
      }

      try {
        const response = await fetch(API_URL);
        const json = await response.json();

        if (json.status === 'ok') {
          setArticles(json.articles);
        } else {
          setError(json.message || 'Failed to fetch news.');
        }
      } catch (e) {
        setError('An unexpected error occurred. Please check your network connection.');
      } finally {
        setLoading(false);
      }
    };

    fetchNews();
  }, []);

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <ActivityIndicator size="large" color="#1e40af" style={{ flex: 1 }}/>
      </SafeAreaView>
    );
  }
  
  if (error) {
     return (
      <SafeAreaView style={styles.container}>
        <View style={{flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20}}>
            <Text style={{textAlign: 'center', color: '#ef4444'}}>{error}</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <FlatList
        data={articles}
        keyExtractor={(item, index) => item.url + index}
        renderItem={({ item }) => <ArticleCard article={item} />}
        ListHeaderComponent={
            <View style={{ paddingHorizontal: 20, paddingTop: 20, paddingBottom: 10 }}>
                <Text style={styles.headerTitle}>Health & Supplement News</Text>
            </View>
        }
        contentContainerStyle={{ paddingBottom: 20 }}
      />
    </SafeAreaView>
  );
};

export default DiscoverScreen;
