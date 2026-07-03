/**
 * LOAD TEST
 *
 * Purpose: Validate SLAs under expected normal traffic.
 * Pattern: Ramp up → sustain at target → ramp down
 *
 * Typical use: Pre-release validation, capacity baseline, regression detection.
 * VUs: configurable via LOAD_VUS env (default 100)
 */
const loadVus = Number(__ENV.LOAD_VUS) || 100;
const loadRampUp = __ENV.LOAD_RAMP_UP || '2m';
const loadDuration = __ENV.LOAD_DURATION || '10m';
const loadRampDown = __ENV.LOAD_RAMP_DOWN || '2m';

export const loadOptions = {
  scenarios: {
    load_browse: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: loadRampUp, target: loadVus },
        { duration: loadDuration, target: loadVus },
        { duration: loadRampDown, target: 0 },
      ],
      gracefulRampDown: '30s',
      exec: 'browseCourses',
      tags: { test_type: 'load', journey: 'browse' },
    },
    load_students: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: loadRampUp, target: Math.floor(loadVus * 0.6) },
        { duration: loadDuration, target: Math.floor(loadVus * 0.6) },
        { duration: loadRampDown, target: 0 },
      ],
      gracefulRampDown: '30s',
      exec: 'studentFlow',
      tags: { test_type: 'load', journey: 'student' },
    },
    load_search: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: loadRampUp, target: Math.floor(loadVus * 0.3) },
        { duration: loadDuration, target: Math.floor(loadVus * 0.3) },
        { duration: loadRampDown, target: 0 },
      ],
      gracefulRampDown: '30s',
      exec: 'searchFlow',
      tags: { test_type: 'load', journey: 'search' },
    },
  },
};
