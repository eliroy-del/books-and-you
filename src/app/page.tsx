import { HeroSection } from "@/components/home/hero-section";
import {
  BestsellersShelf,
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
      <BestsellersShelf />
      <SmartRecommendations />
      <WhyBooksAndYou />
      <TestimonialsSection />
      <ReferralSection />
      <NewsletterSection />
    </>
  );
}
