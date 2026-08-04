"use client";

import { GoogleAnalytics as NextGoogleAnalytics } from "@next/third-parties/google";
import { GA_MEASUREMENT_ID, isAnalyticsEnabled } from "@/lib/analytics";
import { useConsent } from "@/components/ConsentProvider";

export {
  reportWebVitals,
  analytics,
  trackEvent,
  trackPageView,
} from "@/lib/analytics";

/**
 * GA4 via @next/third-parties. Mounts only in production after cookie consent.
 */
export default function GoogleAnalytics() {
  const { consent, ready } = useConsent();

  if (!ready || !isAnalyticsEnabled() || consent !== "granted") {
    return null;
  }

  return <NextGoogleAnalytics gaId={GA_MEASUREMENT_ID} />;
}
