"use client";

import { useConsent } from "@/components/ConsentProvider";
import { Button } from "@/components/ui/button";

export function CookieConsentBanner() {
  const { consent, ready, setConsent } = useConsent();

  if (!ready || consent !== "unknown") return null;

  return (
    <div
      role="dialog"
      aria-label="Cookie consent"
      className="border-border bg-background/95 fixed inset-x-0 bottom-0 z-50 border-t p-4 shadow-elevated backdrop-blur sm:p-5"
    >
      <div className="mx-auto flex max-w-7xl flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <p className="text-muted-foreground max-w-2xl text-sm leading-relaxed">
          We use analytics cookies to understand how the store is used. They stay
          off until you accept. You can change this anytime in Cookie settings.
        </p>
        <div className="flex shrink-0 flex-wrap gap-2">
          <Button
            type="button"
            variant="outline"
            className="rounded-xl"
            onClick={() => setConsent("denied")}
          >
            Reject
          </Button>
          <Button
            type="button"
            className="rounded-xl"
            onClick={() => setConsent("granted")}
          >
            Accept
          </Button>
        </div>
      </div>
    </div>
  );
}

export function CookieSettingsButton({
  className,
}: {
  className?: string;
}) {
  const { resetConsent } = useConsent();
  return (
    <button type="button" className={className} onClick={() => resetConsent()}>
      Cookie settings
    </button>
  );
}
