/**
 * Generated-style Database types for Books & You (Phase 2).
 * Replace with `supabase gen types typescript` once a project is linked.
 */

export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

export type Database = {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string;
          email: string | null;
          full_name: string | null;
          avatar_url: string | null;
          phone: string | null;
          status: "active" | "suspended" | "deleted";
          role_id: string | null;
          referral_code: string | null;
          referred_by: string | null;
          favorite_genres: string[];
          reading_goal: number;
          reading_streak: number;
          locale: string;
          currency: string;
          metadata: Json;
          created_at: string;
          updated_at: string;
        };
        Insert: Partial<Database["public"]["Tables"]["profiles"]["Row"]> & { id: string };
        Update: Partial<Database["public"]["Tables"]["profiles"]["Row"]>;
        Relationships: [];
      };
      books: {
        Row: {
          id: string;
          slug: string;
          title: string;
          subtitle: string | null;
          description: string | null;
          synopsis: string | null;
          isbn: string | null;
          pages: number | null;
          language: string;
          published_at: string | null;
          publisher_id: string | null;
          cover_url: string | null;
          cover_gradient: string | null;
          cover_accent: string | null;
          rating_avg: number;
          review_count: number;
          is_featured: boolean;
          is_bestseller: boolean;
          is_new_arrival: boolean;
          is_staff_pick: boolean;
          is_award_winner: boolean;
          is_preorder: boolean;
          release_date: string | null;
          table_of_contents: string[];
          genres: string[];
          search_vector: unknown | null;
          metadata: Json;
          created_at: string;
          updated_at: string;
        };
        Insert: Partial<Database["public"]["Tables"]["books"]["Row"]> & {
          slug: string;
          title: string;
        };
        Update: Partial<Database["public"]["Tables"]["books"]["Row"]>;
        Relationships: [];
      };
      book_inventory: {
        Row: {
          id: string;
          book_id: string;
          format: "hardcover" | "paperback" | "ebook" | "audiobook";
          sku: string | null;
          price_cents: number;
          compare_at_cents: number | null;
          currency: string;
          quantity_on_hand: number;
          quantity_reserved: number;
          low_stock_threshold: number;
          is_active: boolean;
          digital_asset_path: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: Partial<Database["public"]["Tables"]["book_inventory"]["Row"]> & {
          book_id: string;
          format: Database["public"]["Tables"]["book_inventory"]["Row"]["format"];
          price_cents: number;
        };
        Update: Partial<Database["public"]["Tables"]["book_inventory"]["Row"]>;
        Relationships: [];
      };
      orders: {
        Row: {
          id: string;
          order_number: string;
          user_id: string;
          status:
            | "pending"
            | "ordered"
            | "packed"
            | "shipped"
            | "delivered"
            | "completed"
            | "cancelled"
            | "refunded";
          currency: string;
          subtotal_cents: number;
          shipping_cents: number;
          discount_cents: number;
          tax_cents: number;
          total_cents: number;
          coupon_code: string | null;
          shipping_address: Json | null;
          billing_address: Json | null;
          notes: string | null;
          placed_at: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: Partial<Database["public"]["Tables"]["orders"]["Row"]> & {
          user_id: string;
        };
        Update: Partial<Database["public"]["Tables"]["orders"]["Row"]>;
        Relationships: [];
      };
      wishlists: {
        Row: {
          id: string;
          user_id: string;
          name: string;
          is_default: boolean;
          is_public: boolean;
          created_at: string;
          updated_at: string;
        };
        Insert: Partial<Database["public"]["Tables"]["wishlists"]["Row"]> & {
          user_id: string;
        };
        Update: Partial<Database["public"]["Tables"]["wishlists"]["Row"]>;
        Relationships: [];
      };
      [table: string]: {
        Row: Record<string, unknown>;
        Insert: Record<string, unknown>;
        Update: Record<string, unknown>;
        Relationships: unknown[];
      };
    };
    Views: Record<string, never>;
    Functions: {
      is_superadmin: { Args: Record<string, never>; Returns: boolean };
      has_permission: { Args: { permission_key: string }; Returns: boolean };
      has_any_permission: { Args: { permission_keys: string[] }; Returns: boolean };
      is_staff: { Args: Record<string, never>; Returns: boolean };
      inventory_available: { Args: { p_inventory_id: string }; Returns: number };
    };
    Enums: {
      book_format: "hardcover" | "paperback" | "ebook" | "audiobook";
      order_status:
        | "pending"
        | "ordered"
        | "packed"
        | "shipped"
        | "delivered"
        | "completed"
        | "cancelled"
        | "refunded";
      payment_provider: "moolre" | "wallet" | "manual";
    };
    CompositeTypes: Record<string, never>;
  };
};
