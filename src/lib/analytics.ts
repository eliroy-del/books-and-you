/**
 * Google Analytics 4 utilities for Next.js
 * Uses @next/third-parties sendGAEvent (gtag dataLayer signature).
 */

import { sendGAEvent } from "@next/third-parties/google";

export const GA_MEASUREMENT_ID =
  process.env.NEXT_PUBLIC_GA_MEASUREMENT_ID || "G-XXXXXXXXXX";

const PLACEHOLDER_ID = "G-XXXXXXXXXX";

/** GA loads only in production with a real measurement ID. */
export function isAnalyticsEnabled(): boolean {
  return (
    process.env.NODE_ENV !== "development" &&
    Boolean(GA_MEASUREMENT_ID) &&
    GA_MEASUREMENT_ID !== PLACEHOLDER_ID
  );
}

export interface WebVitalsMetric {
  id: string;
  name: string;
  value: number;
  rating?: "good" | "needs-improvement" | "poor";
  delta?: number;
  navigationType?: string;
}

export interface GAEvent {
  action: string;
  category?: string;
  label?: string;
  value?: number;
  custom_parameters?: Record<string, unknown>;
}

const WEB_VITAL_NAMES = new Set(["CLS", "FCP", "FID", "INP", "LCP", "TTFB"]);

function pushEvent(name: string, params: Record<string, unknown> = {}) {
  if (!isAnalyticsEnabled()) return;
  sendGAEvent("event", name, params);
}

/** Reports Core Web Vitals to GA4. */
export function reportWebVitals(metric: WebVitalsMetric): void {
  if (!isAnalyticsEnabled()) {
    if (process.env.NODE_ENV === "development") {
      console.info("Web Vitals (dev):", metric);
    }
    return;
  }

  if (!WEB_VITAL_NAMES.has(metric.name)) return;

  const value = Math.round(
    metric.name === "CLS" ? metric.value * 1000 : metric.value
  );

  pushEvent("web_vitals", {
    event_category: "Web Vitals",
    event_label: metric.name,
    value,
    metric_id: metric.id,
    metric_name: metric.name,
    metric_rating: metric.rating,
    metric_delta: metric.delta,
  });
}

export function trackEvent(event: GAEvent): void {
  if (!isAnalyticsEnabled()) return;

  pushEvent(event.action, {
    event_category: event.category || "engagement",
    event_label: event.label,
    value: event.value,
    ...(event.custom_parameters || {}),
  });
}

export function trackPageView(url: string, title?: string): void {
  if (!isAnalyticsEnabled()) return;

  pushEvent("page_view", {
    page_location: url,
    page_title: title || (typeof document !== "undefined" ? document.title : undefined),
  });
}

export const analytics = {
  trackExternalLink: (url: string, text?: string) => {
    trackEvent({
      action: "click_external_link",
      category: "engagement",
      label: url,
      custom_parameters: { link_text: text, link_url: url },
    });
  },

  trackDownload: (filename: string, fileType?: string) => {
    trackEvent({
      action: "download",
      category: "engagement",
      label: filename,
      custom_parameters: { file_name: filename, file_type: fileType },
    });
  },

  trackFormSubmission: (formName: string, success = true) => {
    trackEvent({
      action: "form_submission",
      category: "engagement",
      label: formName,
      value: success ? 1 : 0,
      custom_parameters: {
        form_name: formName,
        submission_success: success,
      },
    });
  },

  trackSearch: (query: string, results?: number) => {
    trackEvent({
      action: "search",
      category: "engagement",
      label: query,
      value: results,
      custom_parameters: { search_term: query, search_results: results },
    });
  },

  trackSocialInteraction: (network: string, action: string, target?: string) => {
    trackEvent({
      action: "social_interaction",
      category: "social",
      label: `${network}_${action}`,
      custom_parameters: {
        social_network: network,
        social_action: action,
        social_target: target,
      },
    });
  },

  trackProductView: (productId: string, productName: string, price: number) => {
    trackEvent({
      action: "view_item",
      category: "ecommerce",
      label: productName,
      value: price,
      custom_parameters: {
        currency: "GHS",
        items: [
          {
            item_id: productId,
            item_name: productName,
            price,
            quantity: 1,
          },
        ],
      },
    });
  },

  trackAddToCart: (
    productId: string,
    productName: string,
    quantity: number,
    price: number
  ) => {
    trackEvent({
      action: "add_to_cart",
      category: "ecommerce",
      label: productName,
      value: price * quantity,
      custom_parameters: {
        currency: "GHS",
        value: price * quantity,
        items: [
          {
            item_id: productId,
            item_name: productName,
            price,
            quantity,
          },
        ],
      },
    });
  },

  trackBeginCheckout: (total: number, itemCount: number) => {
    trackEvent({
      action: "begin_checkout",
      category: "ecommerce",
      value: total,
      custom_parameters: {
        currency: "GHS",
        value: total,
        item_count: itemCount,
      },
    });
  },

  trackPurchase: (orderId: string, total: number, items: number) => {
    trackEvent({
      action: "purchase",
      category: "ecommerce",
      label: orderId,
      value: total,
      custom_parameters: {
        transaction_id: orderId,
        currency: "GHS",
        value: total,
        item_count: items,
      },
    });
  },
};

declare global {
  interface Window {
    gtag?: (...args: unknown[]) => void;
  }
}
