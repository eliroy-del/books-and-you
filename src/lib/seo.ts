/** Production canonical domain for Books & You */
export const PRODUCTION_SITE_URL = "https://booksandyou.shop";

export const siteUrl = (
  process.env.NEXT_PUBLIC_SITE_URL ||
  (process.env.NODE_ENV === "production" ? PRODUCTION_SITE_URL : "http://localhost:3000")
).replace(/\/$/, "");

export const siteName = "Books & You";

export const siteDescription =
  "A premium digital bookstore for discovering, purchasing, and managing physical and digital books, with curated picks and a personal library.";

export const siteKeywords = [
  "bookstore",
  "buy books online",
  "books Ghana",
  "booksandyou.shop",
  "ebooks",
  "audiobooks",
  "African literature",
  "Ghana textbooks",
  "bestsellers",
  "new book releases",
  "online library",
  "Books & You",
];
