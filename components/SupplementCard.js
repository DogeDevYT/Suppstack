import { Text, TouchableOpacity, View } from 'react-native';
import { styles } from '../styles/globalStyles';

const SupplementCard = ({ name, dosage, onPress }) => (
  <TouchableOpacity style={styles.card} onPress={onPress}>
    <View>
      <Text style={styles.cardTitle}>{name}</Text>
      {dosage && <Text style={styles.cardDosage}>{dosage}</Text>}
    </View>
    <Text style={styles.cardArrow}>›</Text>
  </TouchableOpacity>
);

export default SupplementCard;
