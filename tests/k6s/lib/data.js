import { SharedArray } from 'k6/data';

/**
 * Read-only shared data loaded once per VU initialization.
 * Use SharedArray for large datasets to minimize memory per VU.
 */

const courseIds = new SharedArray('course_ids', function () {
  return JSON.parse(__ENV.COURSE_IDS || '["course-1","course-2","course-3"]');
});

const searchTerms = new SharedArray('search_terms', function () {
  return ['javascript', 'python', 'react', 'machine learning', 'devops', 'aws'];
});

export function randomCourseId() {
  return courseIds[Math.floor(Math.random() * courseIds.length)];
}

export function randomSearchTerm() {
  return searchTerms[Math.floor(Math.random() * searchTerms.length)];
}

export function randomString(length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return Array.from(
    { length },
    () => chars[Math.floor(Math.random() * chars.length)],
  ).join('');
}

export function strongPassword() {
  const upper = String.fromCharCode(65 + Math.floor(Math.random() * 26));
  const lower = String.fromCharCode(97 + Math.floor(Math.random() * 26));
  const digit = Math.floor(Math.random() * 10).toString();
  const special = '!@#$%^&*'[Math.floor(Math.random() * 8)];
  return upper + lower + digit + special + randomString(8);
}

export function uniqueEmail(prefix = 'loadtest') {
  return `${prefix}_vu${__VU}_iter${__ITER}_${randomString(6)}@test.com`;
}

export function registrationPayload(role = 'STUDENT') {
  const password = strongPassword();
  return {
    firstName: randomString(6),
    lastName: randomString(6),
    email: uniqueEmail(role.toLowerCase()),
    password,
    confirmPassword: password,
    role,
    authType: 'EMAIL',
  };
}

/** Weighted random pick — e.g. 80% students, 15% instructors, 5% admins */
export function pickWeightedRole() {
  const roll = Math.random();
  if (roll < 0.80) return 'STUDENT';
  if (roll < 0.95) return 'INSTRUCTOR';
  return 'ADMIN';
}
