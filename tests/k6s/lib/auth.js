import { post, get, assertResponse } from './http.js';
import { loginDuration, loginFailures, authErrors } from '../metrics/auth.metrics.js';

const tokenCache = {};

/**
 * Authenticate and return tokens. Caches per VU to avoid login on every request.
 */
export function login(email, password, tags = {}) {
  const cacheKey = `${__VU}:${email}`;
  if (tokenCache[cacheKey]) {
    return tokenCache[cacheKey];
  }

  const start = Date.now();
  const res = post(
    '/auth/login',
    { email, password },
    { tags: { endpoint: 'auth', operation: 'login', ...tags } },
  );

  loginDuration.add(Date.now() - start);

  const ok = assertResponse(res, {
    'login status 200': (r) => r.status === 200,
    'login has accessToken': (r) => {
      try {
        return r.json('accessToken') !== undefined;
      } catch {
        return false;
      }
    },
  });

  if (!ok) {
    loginFailures.add(1);
    authErrors.add(1);
    return null;
  }

  authErrors.add(0);

  const tokens = {
    accessToken: res.json('accessToken'),
    refreshToken: res.json('refreshToken'),
  };

  tokenCache[cacheKey] = tokens;
  return tokens;
}

export function refreshToken(refreshTokenValue, tags = {}) {
  const res = post(
    '/auth/refresh',
    { refreshToken: refreshTokenValue },
    { tags: { endpoint: 'auth', operation: 'refresh', ...tags } },
  );

  assertResponse(res, {
    'refresh status 200': (r) => r.status === 200,
  });

  return res.status === 200
    ? { accessToken: res.json('accessToken'), refreshToken: res.json('refreshToken') }
    : null;
}

export function getProfile(accessToken, tags = {}) {
  return get('/users/profile', {
    headers: { Authorization: `Bearer ${accessToken}` },
    tags: { endpoint: 'users', operation: 'profile', ...tags },
  });
}
