import { Platform, View } from 'react-native';
import Svg, { Circle, Text as SvgText } from 'react-native-svg';
import { styles } from '../styles/globalStyles';

const HypeMeter = ({ efficacy, risk, hype, value }) => {
  const size = Platform.OS === 'ios' ? 100 : 110;
  const strokeWidth = 10;
  const center = size / 2;
  const radius = (size - strokeWidth) / 2;
  const circumference = 2 * Math.PI * radius;

  const getStrokeDashoffset = (score) => circumference - (circumference * score) / 100;
  const getRiskColor = (score) => (score > 50 ? '#ef4444' : '#f97316');
  const getEfficacyColor = (score) => (score > 70 ? '#22c55e' : '#84cc16');
  const getHypeColor = (score) => (score > 80 ? '#3b82f6' : '#60a5fa');
  const getValueColor = (score) => (score > 70 ? '#8b5cf6' : '#a78bfa');

  const MeterCircle = ({ label, score, color }) => (
    <View style={styles.meterGroup}>
      <Svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
        <Circle stroke="#e5e7eb" fill="none" cx={center} cy={center} r={radius} strokeWidth={strokeWidth} />
        <Circle
          stroke={color}
          fill="none"
          cx={center}
          cy={center}
          r={radius}
          strokeWidth={strokeWidth}
          strokeDasharray={circumference}
          strokeDashoffset={getStrokeDashoffset(score)}
          strokeLinecap="round"
          transform={`rotate(-90 ${center} ${center})`}
        />
        <SvgText x={center} y={center - 5} textAnchor="middle" fontSize="12" fill="#6b7280" fontWeight="600">
          {label}
        </SvgText>
        <SvgText x={center} y={center + 15} textAnchor="middle" fontSize="18" fill="#111827" fontWeight="600">
          {score}%
        </SvgText>
      </Svg>
    </View>
  );

  return (
    <View style={styles.hypeContainer}>
      <MeterCircle label="Efficacy" score={efficacy} color={getEfficacyColor(efficacy)} />
      <MeterCircle label="Risk" score={risk} color={getRiskColor(risk)} />
      <MeterCircle label="Hype" score={hype} color={getHypeColor(hype)} />
      <MeterCircle label="Value" score={value} color={getValueColor(value)} />
    </View>
  );
};

export default HypeMeter;
