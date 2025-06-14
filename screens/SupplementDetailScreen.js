import HypeMeter from '../components/HypeMeter';

// The import for SafeAreaView is crucial and must be included here.
import { FlatList, SafeAreaView, Text, View } from 'react-native';
import { MOCK_DATA } from '../data/mockData';
import { styles } from '../styles/globalStyles';

const SupplementDetailScreen = ({ route }) => {
  const { supplementId } = route.params;
  const supplement = MOCK_DATA.supplements.find(s => s.id === supplementId);

  if (!supplement) {
    return <SafeAreaView style={styles.container}><Text>Supplement not found!</Text></SafeAreaView>;
  }

  return (
    <SafeAreaView style={styles.container}>
      <FlatList
        ListHeaderComponent={
          <View style={styles.detailContainer}>
            <Text style={styles.detailTitle}>{supplement.name}</Text>
            <Text style={styles.detailDescription}>{supplement.description}</Text>
            <View style={styles.section}>
              <Text style={styles.sectionTitle}>Hype Meter™</Text>
              <HypeMeter {...supplement} />
            </View>
            <View style={styles.section}>
              <Text style={styles.sectionTitle}>Analysis & Recommendation</Text>
              <Text style={styles.detailDescription}>{supplement.recommendation}</Text>
            </View>
          </View>
        }
        data={[]}
        renderItem={null}
        contentContainerStyle={{paddingBottom: 40}}
      />
    </SafeAreaView>
  );
};

export default SupplementDetailScreen;