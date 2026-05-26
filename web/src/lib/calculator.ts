export function calculatePnL(revenue: number, devCostPerDay: number = 1000000, effortDays: number = 15): number {
  if (revenue == null || isNaN(revenue) || revenue < 0) {
    revenue = 0;
  }
  const devCost = effortDays * devCostPerDay;
  return revenue - devCost;
}

export function calculateRICEScore(reach: number, impact: number, confidence: number, effort: number): number {
  if (reach == null || isNaN(reach) || reach < 0) reach = 0;
  if (impact == null || isNaN(impact) || impact < 0) impact = 0;
  if (confidence == null || isNaN(confidence) || confidence < 0) confidence = 0;
  if (effort == null || isNaN(effort) || effort <= 0) return 0; // Avoid division by zero

  // Confidence is a percentage (e.g., 80 means 80%)
  return (reach * impact * (confidence / 100)) / effort;
}

export function parseConfidenceFromMessage(message: string): number {
  if (!message) return 10;
  const lowerMsg = message.toLowerCase();
  if (lowerMsg.includes('data') || lowerMsg.includes('báo cáo') || lowerMsg.includes('mixpanel')) {
    return 80;
  }
  return 10;
}
