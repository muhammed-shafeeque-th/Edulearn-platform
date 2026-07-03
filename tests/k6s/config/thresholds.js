/**
 * Service Level Objectives (SLOs) and pass/fail thresholds.
 *
 * k6 evaluates these after the run — failing thresholds exit with code 99,
 * which is useful for CI/CD gates (especially smoke tests).
 *
 * Adjust per environment: staging can be looser than production baselines.
 */

/** Strict thresholds for smoke / CI pipeline gates */
export const smokeThresholds = {
  http_req_failed: ['rate<0.01'],
  http_req_duration: ['p(95)<800', 'p(99)<1500'],
  checks: ['rate>0.99'],
};

/** Standard load-test SLOs — typical daily traffic */
export const loadThresholds = {
  http_req_failed: ['rate<0.02'],
  http_req_duration: ['p(90)<500', 'p(95)<1000', 'p(99)<2000'],
  checks: ['rate>0.95'],
  'http_req_duration{endpoint:auth}': ['p(95)<800'],
  'http_req_duration{endpoint:courses}': ['p(95)<600'],
};

/** Spike test — allow brief degradation during burst */
export const spikeThresholds = {
  http_req_failed: ['rate<0.10'],
  http_req_duration: ['p(95)<3000'],
  checks: ['rate>0.90'],
};

/** Stress test — system may degrade; we observe, not gate */
export const stressThresholds = {
  http_req_failed: ['rate<0.25'],
  http_req_duration: ['p(95)<5000'],
};

/** Soak test — stability over time, low error rate */
export const soakThresholds = {
  http_req_failed: ['rate<0.01'],
  http_req_duration: ['p(95)<1000', 'avg<400'],
  checks: ['rate>0.97'],
};

/** Peak traffic — enrollment deadline / flash sale simulation */
export const peakThresholds = {
  http_req_failed: ['rate<0.05'],
  http_req_duration: ['p(95)<1500', 'p(99)<3000'],
  checks: ['rate>0.93'],
};

/** Breakpoint — informational only; expect failures at high load */
export const breakpointThresholds = {
  http_req_failed: ['rate<0.50'],
};

/** Mixed multi-scenario run */
export const mixedThresholds = {
  http_req_failed: ['rate<0.05'],
  http_req_duration: ['p(95)<1500'],
  checks: ['rate>0.92'],
  auth_errors: ['rate<0.05'],
};
