import { get, post, assertResponse, thinkTime } from '../lib/http.js';
import { randomCourseId } from '../lib/data.js';
import { login } from '../lib/auth.js';
import { TEST_USERS } from '../config/env.js';
import {
  enrollmentAttempts,
  enrollmentFailures,
} from '../metrics/course.metrics.js';

/**
 * Enrollment funnel: browse course → add to cart → create order.
 * Payment is mocked/skipped to avoid hitting external providers under load.
 */
export function checkoutJourney() {
  const user = TEST_USERS.student;
  const tokens = login(user.email, user.password);
  if (!tokens) return;

  const headers = { Authorization: `Bearer ${tokens.accessToken}` };
  const courseId = randomCourseId();

  get(`/courses/${courseId}`, {
    headers,
    tags: { endpoint: 'courses', operation: 'detail' },
  });

  thinkTime();

  enrollmentAttempts.add(1);

  const cartRes = post(
    '/users/cart',
    { courseId, quantity: 1 },
    { headers, tags: { endpoint: 'cart', operation: 'add' } },
  );

  const cartOk = assertResponse(cartRes, {
    'add to cart status 200 or 201': (r) =>
      r.status === 200 || r.status === 201 || r.status === 409,
  });

  if (!cartOk) {
    enrollmentFailures.add(1);
    return;
  }

  thinkTime();

  get('/users/cart', {
    headers,
    tags: { endpoint: 'cart', operation: 'get' },
  });

  thinkTime();

  const orderRes = post(
    '/orders',
    { courseIds: [courseId] },
    { headers, tags: { endpoint: 'orders', operation: 'create' } },
  );

  assertResponse(orderRes, {
    'create order status 200 or 201 or 409': (r) =>
      r.status === 200 || r.status === 201 || r.status === 409,
  });
}

/**
 * Wishlist operations — lighter write path.
 */
export function wishlistJourney() {
  const user = TEST_USERS.student;
  const tokens = login(user.email, user.password);
  if (!tokens) return;

  const headers = { Authorization: `Bearer ${tokens.accessToken}` };
  const courseId = randomCourseId();

  post(
    '/users/wishlist',
    { courseId },
    { headers, tags: { endpoint: 'wishlist', operation: 'add' } },
  );

  thinkTime();

  get('/users/wishlist', {
    headers,
    tags: { endpoint: 'wishlist', operation: 'list' },
  });
}
