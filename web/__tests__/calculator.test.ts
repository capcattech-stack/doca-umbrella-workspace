import { describe, it, expect } from 'vitest';
import { calculatePnL, calculateRICEScore, parseConfidenceFromMessage } from '../src/lib/calculator';

describe('QA Validation: calculatePnL', () => {
  it('should calculate standard positive PnL correctly', () => {
    // Revenue = 20M, Dev Cost = 15 * 1M = 15M -> PnL = 5M
    expect(calculatePnL(20000000)).toBe(5000000);
  });

  it('should calculate standard negative PnL correctly', () => {
    expect(calculatePnL(10000000)).toBe(-5000000);
  });

  // Boundary Tests (Eve QA Standard)
  it('should handle 0 revenue', () => {
    expect(calculatePnL(0)).toBe(-15000000);
  });

  it('should handle negative revenue as 0', () => {
    expect(calculatePnL(-500)).toBe(-15000000);
  });

  it('should handle Null/Undefined revenue gracefully', () => {
    expect(calculatePnL(null as any)).toBe(-15000000);
    expect(calculatePnL(undefined as any)).toBe(-15000000);
  });

  it('should handle MAX_INT', () => {
    expect(calculatePnL(Number.MAX_SAFE_INTEGER)).toBe(Number.MAX_SAFE_INTEGER - 15000000);
  });
});

describe('QA Validation: calculateRICEScore', () => {
  it('should calculate standard RICE correctly', () => {
    // Reach = 10000, Impact = 2, Confidence = 80%, Effort = 2
    // Score = (10000 * 2 * 0.8) / 2 = 8000
    expect(calculateRICEScore(10000, 2, 80, 2)).toBe(8000);
  });

  // Boundary Tests (Eve QA Standard)
  it('should handle effort = 0 without division by zero errors', () => {
    expect(calculateRICEScore(10000, 2, 80, 0)).toBe(0); // Should return 0 fallback
  });

  it('should handle negative confidence', () => {
    expect(calculateRICEScore(10000, 2, -10, 2)).toBe(0);
  });

  it('should handle Null/Undefined values gracefully', () => {
    expect(calculateRICEScore(null as any, undefined as any, null as any, undefined as any)).toBe(0);
  });

  it('should handle MAX_INT limits', () => {
    // To avoid infinity, just test large numbers
    expect(calculateRICEScore(Number.MAX_SAFE_INTEGER, 1, 100, 1)).toBe(Number.MAX_SAFE_INTEGER);
  });
});

describe('QA Validation: parseConfidenceFromMessage', () => {
  it('should detect data-driven evidence', () => {
    expect(parseConfidenceFromMessage("Tôi có báo cáo từ mixpanel")).toBe(80);
    expect(parseConfidenceFromMessage("Dựa vào data khảo sát")).toBe(80);
  });

  it('should assign 10% for vague evidence', () => {
    expect(parseConfidenceFromMessage("Tôi nghĩ user sẽ thích")).toBe(10);
    expect(parseConfidenceFromMessage("Sếp bảo làm")).toBe(10);
  });

  it('should handle empty/Null/Undefined', () => {
    expect(parseConfidenceFromMessage("")).toBe(10);
    expect(parseConfidenceFromMessage(null as any)).toBe(10);
    expect(parseConfidenceFromMessage(undefined as any)).toBe(10);
  });
});
