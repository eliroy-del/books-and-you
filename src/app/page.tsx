import { HeroSection } from "@/components/home/hero-section";
import {
  BestsellersShelf,
  FeaturedCollections,
  NewsletterSection,
  ReferralSection,
  SmartRecommendations,
  TestimonialsSection,
  WhyBooksAndYou,
} from "@/components/home/home-sections";

export default function HomePage() {
  return (
    <>
      <HeroSection />
      <FeaturedCollections />
      <BestsellersShelf />
      <SmartRecommendations />
      <WhyBooksAndYou />
      <TestimonialsSection />
      <ReferralSection />
      <NewsletterSection />
    </>
  );
}
