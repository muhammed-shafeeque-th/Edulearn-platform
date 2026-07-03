import { Counter, Trend, Rate } from 'k6/metrics';

export const healthCheckDuration = new Trend('health_check_duration', true);
export const healthCheckFailures = new Counter('health_check_failures');
export const journeyErrors = new Rate('journey_errors');
export const journeyDuration = new Trend('journey_duration', true);
