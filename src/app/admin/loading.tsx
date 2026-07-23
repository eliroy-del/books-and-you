export default function Loading() {
  return (
    <div className="space-y-4 p-2">
      <div className="bg-muted/70 h-8 w-48 animate-pulse rounded-xl" />
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        {Array.from({ length: 4 }).map((_, i) => (
          <div key={i} className="bg-muted/50 h-24 animate-pulse rounded-2xl" />
        ))}
      </div>
      <div className="bg-muted/40 h-64 animate-pulse rounded-3xl" />
    </div>
  );
}
