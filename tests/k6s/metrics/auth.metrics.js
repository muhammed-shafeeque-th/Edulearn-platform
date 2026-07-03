import { Counter, Trend, Rate } from 'k6/metrics';

export const loginFailures = new Counter('login_failures');
export const loginDuration = new Trend('login_duration', true);
export const authErrors = new Rate('auth_errors');
export const registrationDuration = new Trend('registration_duration', true);
export const registrationFailures = new Counter('registration_failures');
