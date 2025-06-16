import { StyleSheet } from 'react-native';

export const styles = StyleSheet.create({

  //Remove Supplement Styles
  removeButton: {
    position: 'absolute',
    top: 10,
    right: 50,
    padding: 10,
  },
  removeButtonText: {
    color: '#ef4444', // Red color for remove action
    fontWeight: '600',
  },

  //Previous styles
  container: { flex: 1, backgroundColor: '#f9fafb' },
  loginContainer: { flex: 1, justifyContent: 'center', padding: 20 },
  loginTitle: { fontSize: 24, color: '#4b5563', textAlign: 'center'},
  loginAppName: { fontSize: 36, fontWeight: 'bold', color: '#1e40af', marginBottom: 10, textAlign: 'center' },
  loginSubtitle: { fontSize: 16, color: '#6b7280', marginBottom: 40, textAlign: 'center' },
  input: { width: '100%', height: 50, backgroundColor: '#fff', borderRadius: 12, paddingHorizontal: 15, marginBottom: 15, borderWidth: 1, borderColor: '#d1d5db', fontSize: 16 },
  linkText: { marginTop: 20, color: '#1e40af', fontSize: 14, textAlign: 'center' },
  headerTitle: { fontSize: 28, fontWeight: 'bold', color: '#111827' },
  headerSubtitle: { fontSize: 16, color: '#4b5563', marginTop: 4 },
  button: { backgroundColor: '#1e40af', paddingVertical: 15, borderRadius: 12, alignItems: 'center', justifyContent: 'center', width: '100%', elevation: 2, shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 4 },
  buttonText: { color: '#fff', fontSize: 18, fontWeight: 'bold' },
  addButton: { backgroundColor: '#16a34a' },
  card: { backgroundColor: '#fff', borderRadius: 12, padding: 20, marginBottom: 15, flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', borderWidth: 1, borderColor: '#e5e7eb' },
  cardTitle: { fontSize: 18, fontWeight: '600', color: '#1f2937' },
  cardDosage: { fontSize: 14, color: '#6b7280', marginTop: 4 },
  cardArrow: { fontSize: 24, color: '#9ca3af' },
  searchInput: { backgroundColor: '#fff', borderRadius: 12, padding: 15, fontSize: 16, marginTop: 10, borderWidth: 1, borderColor: '#d1d5db' },
  detailContainer: { paddingHorizontal: 20, paddingTop: 10 },
  detailTitle: { fontSize: 32, fontWeight: 'bold', marginBottom: 10, color: '#111827' },
  detailDescription: { fontSize: 16, lineHeight: 24, color: '#374151' },
  section: { marginTop: 25, padding: 20, backgroundColor: '#fff', borderRadius: 16, borderWidth: 1, borderColor: '#e5e7eb' },
  sectionTitle: { fontSize: 22, fontWeight: 'bold', marginBottom: 15, color: '#111827', textAlign: 'center' },
  hypeContainer: { flexDirection: 'row', flexWrap: 'wrap', justifyContent: 'space-around' },
  meterGroup: { alignItems: 'center', width: '50%', marginBottom: 10 },
});
