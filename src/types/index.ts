export type BookFormat = "hardcover" | "paperback" | "ebook" | "audiobook";

export type OrderStatus =
  | "ordered"
  | "packed"
  | "shipped"
  | "delivered"
  | "completed"
  | "cancelled";

export interface Author {
  id: string;
  slug: string;
  name: string;
  bio: string;
  nationality: string;
  bookCount: number;
  followers: number;
  avatarColor: string;
}

export interface Publisher {
  id: string;
  slug: string;
  name: string;
  country: string;
}

export interface Category {
  id: string;
  slug: string;
  name: string;
  description: string;
  bookCount: number;
  accent: string;
}

export interface Review {
  id: string;
  bookId: string;
  userName: string;
  rating: number;
  title: string;
  body: string;
  date: string;
  verified: boolean;
}

export interface Book {
  id: string;
  slug: string;
  title: string;
  subtitle?: string;
  authorId: string;
  authorName: string;
  authorSlug?: string;
  publisherId: string;
  publisherName: string;
  categoryIds: string[];
  genres: string[];
  description: string;
  synopsis: string;
  isbn: string;
  pages: number;
  language: string;
  publishedAt: string;
  coverGradient: string;
  coverAccent: string;
  formats: {
    format: BookFormat;
    price: number;
    compareAt?: number;
    inStock: number;
  }[];
  rating: number;
  reviewCount: number;
  tags: string[];
  featured?: boolean;
  bestseller?: boolean;
  newArrival?: boolean;
  staffPick?: boolean;
  awardWinner?: boolean;
  preorder?: boolean;
  releaseDate?: string;
  tableOfContents?: string[];
}

export interface CartItem {
  bookId: string;
  format: BookFormat;
  quantity: number;
}

export interface Address {
  id: string;
  label: string;
  fullName: string;
  line1: string;
  line2?: string;
  city: string;
  region: string;
  postalCode: string;
  country: string;
  phone: string;
  isDefault?: boolean;
}

export interface Order {
  id: string;
  number: string;
  status: OrderStatus;
  placedAt: string;
  total: number;
  currency: string;
  items: {
    bookId: string;
    title: string;
    format: BookFormat;
    quantity: number;
    price: number;
  }[];
  shippingAddress: string;
  trackingNumber?: string;
  timeline: { status: OrderStatus | string; at: string; note?: string }[];
}

export interface SubscriptionPlan {
  id: string;
  name: string;
  interval: "monthly" | "quarterly" | "annual";
  price: number;
  booksPerPeriod: number;
  features: string[];
  popular?: boolean;
}

export interface LibraryBook {
  bookId: string;
  format: "ebook" | "audiobook";
  progress: number;
  lastOpenedAt: string;
  bookmarks: number;
  highlights: number;
}

export interface Testimonial {
  id: string;
  name: string;
  role: string;
  quote: string;
  rating: number;
}

export interface Collection {
  id: string;
  slug: string;
  title: string;
  description: string;
  bookIds: string[];
}
