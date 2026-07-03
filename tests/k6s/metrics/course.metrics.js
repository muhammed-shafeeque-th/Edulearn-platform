import { Counter, Trend, Rate } from 'k6/metrics';

export const courseListDuration = new Trend('course_list_duration', true);
export const courseDetailDuration = new Trend('course_detail_duration', true);
export const courseErrors = new Rate('course_errors');
export const enrollmentAttempts = new Counter('enrollment_attempts');
export const enrollmentFailures = new Counter('enrollment_failures');
