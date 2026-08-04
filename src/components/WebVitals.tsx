"use client";

import { useReportWebVitals } from "next/web-vitals";
import { reportWebVitals } from "@/lib/analytics";
import { useConsent } from "@/components/ConsentProvider";

/** Reports Core Web Vitals to GA4 only when analytics consent is granted. */
export function WebVitals() {
  const { consent } = useConsent();

  useReportWebVitals((metric) => {
    if (consent !== "granted") return;
    reportWebVitals(metric);
  });

  return null;
}
