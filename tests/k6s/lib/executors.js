/**
 * Shared scenario executors — mapped by name in scenario configs via `exec`.
 */
import { authJourney, loginStormJourney } from '../journeys/auth.js';
import {
  browseCoursesJourney,
  studentJourney,
  searchJourney,
  healthJourney,
  instructorJourney,
} from '../journeys/courses.js';
import { checkoutJourney } from '../journeys/checkout.js';
import { pickWeightedRole } from '../lib/data.js';
import { journeyDuration, journeyErrors } from '../metrics/global.metrics.js';

function wrapJourney(fn, name) {
  return function () {
    const start = Date.now();
    try {
      fn();
      journeyErrors.add(0);
    } catch (e) {
      journeyErrors.add(1);
      throw e;
    } finally {
      journeyDuration.add(Date.now() - start, { journey: name });
    }
  };
}

export const healthCheck = wrapJourney(healthJourney, 'health');
export const browseCourses = wrapJourney(browseCoursesJourney, 'browse');
export const authFlow = wrapJourney(authJourney, 'auth');
export const studentFlow = wrapJourney(studentJourney, 'student');
export const searchFlow = wrapJourney(searchJourney, 'search');
export const checkoutFlow = wrapJourney(checkoutJourney, 'checkout');
export const instructorFlow = wrapJourney(instructorJourney, 'instructor');
export const loginStorm = wrapJourney(loginStormJourney, 'login_storm');

/** Weighted random journey for stress tests */
export function mixedFlow() {
  const roll = Math.random();
  if (roll < 0.5) browseCoursesJourney();
  else if (roll < 0.75) studentJourney();
  else if (roll < 0.90) searchJourney();
  else checkoutJourney();
}

export { pickWeightedRole };
