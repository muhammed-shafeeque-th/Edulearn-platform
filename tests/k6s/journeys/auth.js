import { post, assertResponse, thinkTime } from '../lib/http.js';
import { registrationPayload } from '../lib/data.js';
import {
  registrationDuration,
  registrationFailures,
  authErrors,
} from '../metrics/auth.metrics.js';
import { login, refreshToken, getProfile } from '../lib/auth.js';
import { TEST_USERS } from '../config/env.js';

/**
 * Full authentication journey: login → profile → token refresh.
 * Models a returning user session.
 */
export function authJourney() {
  const user = TEST_USERS.student;
  const tokens = login(user.email, user.password);

  if (!tokens) {
    authErrors.add(1);
    return;
  }

  const profileRes = getProfile(tokens.accessToken);
  assertResponse(profileRes, {
    'profile status 200': (r) => r.status === 200,
  });

  thinkTime();

  refreshToken(tokens.refreshToken);
}

/**
 * Registration journey — use sparingly (creates DB records).
 * Best suited for stress/breakpoint tests with unique emails.
 */
export function registrationJourney() {
  const start = Date.now();
  const payload = registrationPayload('STUDENT');

  const res = post('/auth/register', payload, {
    tags: { endpoint: 'auth', operation: 'register' },
  });

  registrationDuration.add(Date.now() - start);

  const ok = assertResponse(res, {
    'register status 201 or 200': (r) => r.status === 201 || r.status === 200,
  });

  if (!ok) {
    registrationFailures.add(1);
    authErrors.add(1);
  } else {
    authErrors.add(0);
  }
}

/**
 * Login storm — single iteration per VU, no think time.
 * Simulates mass simultaneous logins (e.g. class start time).
 */
export function loginStormJourney() {
  const user = TEST_USERS.student;
  login(user.email, user.password, { scenario: 'login_storm' });
}
