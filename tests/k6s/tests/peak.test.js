import { peakOptions } from '../scenarios/peak.js';
import { peakThresholds } from '../config/thresholds.js';
import {
  checkoutFlow,
  browseCourses,
  authFlow,
} from '../lib/executors.js';

export const options = {
  ...peakOptions,
  thresholds: peakThresholds,
  tags: { test_mode: 'peak' },
};

export { handleSummary } from '../lib/summary.js';
export { checkoutFlow, browseCourses, authFlow };

export default checkoutFlow;
