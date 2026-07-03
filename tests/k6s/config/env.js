/**
 * Central environment configuration for all k6 tests.
 *
 * Override at runtime:
 *   k6 run -e BASE_URL=https://staging.edulearn.com -e TEST_MODE=load tests/load.test.js
 */

export const BASE_URL = __ENV.BASE_URL || 'http://localhost:4000';
export const API_PREFIX = __ENV.API_PREFIX || '/api/v1';

/** Full API base, e.g. http://localhost:4000/api/v1 */
export const API_BASE = `${BASE_URL}${API_PREFIX}`;

/** Health endpoints (gateway monitoring routes) */
export const HEALTH_URL = __ENV.HEALTH_URL || `${BASE_URL}/health`;
export const READY_URL = __ENV.READY_URL || `${BASE_URL}/ready`;

/**
 * Pre-seeded test accounts (create these before running authenticated journeys).
 * Set via env JSON or use defaults for local dev.
 */
export const TEST_USERS = JSON.parse(
  __ENV.TEST_USERS ||
    JSON.stringify({
      student: { email: 'student@test.com', password: 'Student@123' },
      instructor: { email: 'instructor@test.com', password: 'Instructor@123' },
      admin: { email: 'admin@test.com', password: 'Admin@123' },
    }),
);

/** Think-time bounds (seconds) — simulates realistic user pauses */
export const THINK_TIME = {
  min: Number(__ENV.THINK_MIN) || 0.5,
  max: Number(__ENV.THINK_MAX) || 2.5,
};

/** Request timeout in milliseconds */
export const HTTP_TIMEOUT = __ENV.HTTP_TIMEOUT || '30s';

/** Which test profile is active (used for tagging in Grafana/Prometheus) */
export const TEST_MODE = __ENV.TEST_MODE || 'custom';

/** Enable verbose logging of failed requests */
export const DEBUG = __ENV.DEBUG === 'true';
