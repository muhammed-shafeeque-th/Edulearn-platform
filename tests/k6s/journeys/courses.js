import http from 'k6/http';
import { get, assertResponse, thinkTime } from '../lib/http.js';
import { randomCourseId, randomSearchTerm } from '../lib/data.js';
import { login, getProfile } from '../lib/auth.js';
import { TEST_USERS, HEALTH_URL, READY_URL } from '../config/env.js';
import {
  courseListDuration,
  courseDetailDuration,
  courseErrors,
} from '../metrics/course.metrics.js';
import { healthCheckDuration, healthCheckFailures } from '../metrics/global.metrics.js';

/**
 * Public course browsing — no auth required.
 * Highest-traffic read path on most e-learning platforms.
 */
export function browseCoursesJourney() {
  let start = Date.now();
  const listRes = get('/courses', {
    tags: { endpoint: 'courses', operation: 'list' },
  });
  courseListDuration.add(Date.now() - start);

  const listOk = assertResponse(listRes, {
    'course list status 200': (r) => r.status === 200,
  });

  if (!listOk) {
    courseErrors.add(1);
    return;
  }
  courseErrors.add(0);

  thinkTime();

  start = Date.now();
  const courseId = randomCourseId();
  const detailRes = get(`/courses/${courseId}`, {
    tags: { endpoint: 'courses', operation: 'detail' },
  });
  courseDetailDuration.add(Date.now() - start);

  assertResponse(detailRes, {
    'course detail status 200 or 404': (r) =>
      r.status === 200 || r.status === 404,
  });

  thinkTime();

  const featuredRes = get('/courses/featured', {
    tags: { endpoint: 'courses', operation: 'featured' },
  });
  assertResponse(featuredRes, {
    'featured status 200': (r) => r.status === 200,
  });
}

/**
 * Authenticated student journey: login → profile → browse enrolled courses.
 */
export function studentJourney() {
  const user = TEST_USERS.student;
  const tokens = login(user.email, user.password);
  if (!tokens) return;

  getProfile(tokens.accessToken);
  thinkTime();

  get('/courses', {
    headers: { Authorization: `Bearer ${tokens.accessToken}` },
    tags: { endpoint: 'courses', operation: 'list_authenticated' },
  });

  thinkTime();

  get('/enrollments', {
    headers: { Authorization: `Bearer ${tokens.accessToken}` },
    tags: { endpoint: 'enrollments', operation: 'list' },
  });
}

/**
 * Search and filter — simulates catalog discovery.
 */
export function searchJourney() {
  const term = randomSearchTerm();
  get(`/courses?search=${encodeURIComponent(term)}`, {
    tags: { endpoint: 'courses', operation: 'search' },
  });

  thinkTime();

  get('/courses/categories', {
    tags: { endpoint: 'courses', operation: 'categories' },
  });
}

/**
 * Gateway health probes — baseline availability check.
 */
export function healthJourney() {
  const start = Date.now();
  const healthRes = http.get(HEALTH_URL, {
    tags: { endpoint: 'health', operation: 'health' },
  });
  healthCheckDuration.add(Date.now() - start);

  const ok = assertResponse(healthRes, {
    'health status 200': (r) => r.status === 200,
  });

  if (!ok) healthCheckFailures.add(1);

  http.get(READY_URL, {
    tags: { endpoint: 'health', operation: 'ready' },
  });
}

/**
 * Instructor workflow: login → view instructor courses → analytics.
 */
export function instructorJourney() {
  const user = TEST_USERS.instructor;
  const tokens = login(user.email, user.password, { role: 'instructor' });
  if (!tokens) return;

  getProfile(tokens.accessToken);
  thinkTime();

  get('/courses/instructor/me', {
    headers: { Authorization: `Bearer ${tokens.accessToken}` },
    tags: { endpoint: 'courses', operation: 'instructor_list' },
  });
}
