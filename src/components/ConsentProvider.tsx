"use client";

import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from "react";

export type Consent = "granted" | "denied" | "unknown";

const STORAGE_KEY = "analytics-consent";

type ConsentContextValue = {
  consent: Consent;
  ready: boolean;
  setConsent: (c: Consent) => void;
  resetConsent: () => void;
};

const ConsentContext = createContext<ConsentContextValue>({
  consent: "unknown",
  ready: false,
  setConsent: () => {},
  resetConsent: () => {},
});

export function useConsent() {
  return useContext(ConsentContext);
}

function updateGtagConsent(c: Consent) {
  if (typeof window === "undefined" || typeof window.gtag !== "function") return;
  window.gtag("consent", "update", {
    ad_storage: c === "granted" ? "granted" : "denied",
    analytics_storage: c === "granted" ? "granted" : "denied",
    ad_user_data: c === "granted" ? "granted" : "denied",
    ad_personalization: c === "granted" ? "granted" : "denied",
  });
}

export function ConsentProvider({ children }: { children: ReactNode }) {
  const [consent, setConsentState] = useState<Consent>("unknown");
  const [ready, setReady] = useState(false);

  useEffect(() => {
    try {
      const saved = localStorage.getItem(STORAGE_KEY);
      if (saved === "granted" || saved === "denied") {
        setConsentState(saved);
        updateGtagConsent(saved);
      }
    } catch {
      // ignore
    }
    setReady(true);
  }, []);

  const setConsent = useCallback((c: Consent) => {
    try {
      if (c === "unknown") localStorage.removeItem(STORAGE_KEY);
      else localStorage.setItem(STORAGE_KEY, c);
    } catch {
      // ignore
    }
    setConsentState(c);
    if (c === "granted" || c === "denied") updateGtagConsent(c);
  }, []);

  const resetConsent = useCallback(() => {
    setConsent("unknown");
  }, [setConsent]);

  const value = useMemo(
    () => ({ consent, ready, setConsent, resetConsent }),
    [consent, ready, setConsent, resetConsent]
  );

  return (
    <ConsentContext.Provider value={value}>{children}</ConsentContext.Provider>
  );
}
