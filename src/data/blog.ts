export type BlogPost = {
  slug: string;
  title: string;
  excerpt: string;
  content: string[];
  author: string;
  publishedAt: string;
  readingMinutes: number;
  category: string;
  coverGradient: string;
  coverAccent: string;
  tags: string[];
};

export const blogPosts: BlogPost[] = [
  {
    slug: "how-to-build-a-reading-habit-that-sticks",
    title: "How to Build a Reading Habit That Actually Sticks",
    excerpt:
      "Skip the guilt. A practical, low-pressure routine for busy people who want books back in their week, without finishing a novel overnight.",
    author: "Ama Mensah",
    publishedAt: "2026-07-12",
    readingMinutes: 6,
    category: "Reading life",
    coverGradient: "from-[#0F766E] via-[#0D9488] to-[#134E4A]",
    coverAccent: "#D4A017",
    tags: ["habits", "productivity", "beginners"],
    content: [
      "Most people do not fail at reading because they lack taste. They fail because life is noisy, phones are sticky, and “I’ll read later” quietly becomes never.",
      "Start smaller than you think. Ten pages before bed beats a heroic plan to finish three books this month. Consistency compounds; intensity burns out.",
      "Keep one book in three places: your bag, your bedside, and your phone (for digital editions). Friction is the enemy. If the book is already open, you will read.",
      "Pair reading with an existing cue. Morning tea. The commute. The first fifteen minutes after lunch. Habit stacking works because your brain already knows the trigger.",
      "Track streaks lightly, not obsessively. A simple note of “pages today” is enough. If you miss a day, restart the next morning without apology.",
      "Finally, choose books you actually want. Discipline gets you started; delight keeps you going. Your shelf should feel like invitation, not homework.",
    ],
  },
  {
    slug: "african-literature-starter-shelf",
    title: "An African Literature Starter Shelf for New Readers",
    excerpt:
      "Five entry points into African storytelling, from classic novels to contemporary voices, chosen for readability, range, and lasting conversation.",
    author: "Kwesi Boateng",
    publishedAt: "2026-07-08",
    readingMinutes: 8,
    category: "Guides",
    coverGradient: "from-[#7C2D12] via-[#B45309] to-[#D4A017]",
    coverAccent: "#FEF3C7",
    tags: ["african literature", "recommendations", "classics"],
    content: [
      "African literature is not a single mood. It is cities and villages, satire and sorrow, migration and homecoming. A good starter shelf should reflect that range.",
      "Begin with a novel that pulls you by character. Stories with a clear emotional through-line help new readers settle into unfamiliar settings without feeling lost.",
      "Add one classic that shaped the conversation, the kind of book people still quote at dinner tables and campus debates decades later.",
      "Then balance the shelf with a contemporary voice. Newer writers often speak to today’s cities, diasporas, and digital lives in a register that feels immediate.",
      "Include at least one title from West Africa and one from elsewhere on the continent. Geography matters; so does refusing a single story.",
      "Browse Books & You’s fiction and literary collections, save a shortlist to your wishlist, and let curiosity, not obligation, pick the first page you open.",
    ],
  },
  {
    slug: "choosing-between-print-ebook-and-audiobook",
    title: "Print, Ebook, or Audiobook? How to Choose the Right Format",
    excerpt:
      "Each format wins in different moments. Here’s a simple decision guide so you stop debating and start reading wherever you are.",
    author: "Nana Owusu",
    publishedAt: "2026-06-28",
    readingMinutes: 5,
    category: "Formats",
    coverGradient: "from-[#1E3A5F] via-[#0F766E] to-[#0B1220]",
    coverAccent: "#F5E6B8",
    tags: ["ebooks", "audiobooks", "print"],
    content: [
      "Format is not purity test. It is a tool. The best format is the one you will finish.",
      "Print still wins for deep focus, annotation, and the pleasure of turning a page. If you love underlining and rereading paragraphs, paper remains unmatched.",
      "Ebooks shine when you travel light, switch devices, or want instant delivery. Adjustable type size also makes long sessions kinder on the eyes.",
      "Audiobooks turn errands into chapters: walks, cooking, traffic. They are especially strong for memoir, narrative nonfiction, and dialogue-rich fiction.",
      "Many readers mix formats for the same title: print at home, audio on the road. Ownership in your Books & You library means the story travels with you.",
      "When you are unsure, ask one question: where will I actually open this book this week? Buy for that moment.",
    ],
  },
  {
    slug: "gifts-for-readers-who-already-have-everything",
    title: "Gift Ideas for Readers Who Already Own Too Many Books",
    excerpt:
      "Skip the generic bookmark. Thoughtful gifts for the friend whose shelves are full, from curated picks to experiences that feel personal.",
    author: "Efua Addo",
    publishedAt: "2026-06-18",
    readingMinutes: 7,
    category: "Gifting",
    coverGradient: "from-[#312E81] via-[#4338CA] to-[#0F766E]",
    coverAccent: "#C7D2FE",
    tags: ["gifts", "wishlist", "holidays"],
    content: [
      "Hardcore readers are both easy and impossible to shop for. They love books, and they already have a towering unread pile.",
      "Start with their wishlist. If they share a Books & You wishlist, you are not guessing; you are delivering desire with precision.",
      "When shelves are full, give something complementary: a beautiful edition of a favorite, a genre they never buy for themselves, or a debut they have not discovered yet.",
      "Experiences count. A gift card with a handwritten note naming three titles you think they will love beats another random bestseller.",
      "For students and parents, curriculum-aligned textbooks and exam companions can be the most practical and most appreciated literary gift of the year.",
      "Wrap the story, not just the object. Tell them why you chose this book. The recommendation is half the present.",
    ],
  },
  {
    slug: "inside-ghana-school-textbooks-parents-should-know",
    title: "Inside Ghana School Textbooks: What Parents Should Know",
    excerpt:
      "A clear look at curriculum-aligned English and Mathematics titles, and how to choose materials that support Basic and Junior High learners at home.",
    author: "Dr. Akosua Frimpong",
    publishedAt: "2026-06-05",
    readingMinutes: 9,
    category: "Education",
    coverGradient: "from-[#14532D] via-[#166534] to-[#0F766E]",
    coverAccent: "#BBF7D0",
    tags: ["textbooks", "ghana", "parents", "education"],
    content: [
      "Parents often stand in bookshops staring at covers that all claim to be “curriculum approved.” The real question is fit: level, subject goals, and how your child learns.",
      "Look for alignment with the current standard-based curriculum and clear grade labeling. Basic 6 is not the same journey as JHS Forms 1–3.",
      "English workbooks should balance comprehension, grammar, and writing practice. Mathematics titles are strongest when they mix explanation, worked examples, and past-style questions.",
      "BECE-focused companions help older learners rehearse exam formats without turning every evening into panic. Use them as timed practice, not the only source of understanding.",
      "At home, pair the textbook with short, consistent sessions. Twenty focused minutes beats a weekend cram that everyone dreads.",
      "Browse Books & You’s education and textbook picks, compare formats, and build a small home shelf that matches your child’s actual term, not every title on the market.",
    ],
  },
];

export function getAllBlogPosts() {
  return [..blogPosts].sort(
    (a, b) => new Date(b.publishedAt).getTime() - new Date(a.publishedAt).getTime()
  );
}

export function getBlogPostBySlug(slug: string) {
  return blogPosts.find((p) => p.slug === slug) ?? null;
}

export function formatBlogDate(iso: string) {
  return new Date(iso).toLocaleDateString("en-GB", {
    day: "numeric",
    month: "long",
    year: "numeric",
  });
}
