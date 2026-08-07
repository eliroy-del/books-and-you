/**
 * Storefront catalog taxonomy for Ghana school & stationery commerce.
 * Source of truth for mega-menu, categories browse, and DB seed.
 */

export type CatalogNavNode = {
  slug: string;
  name: string;
  description?: string;
  children?: CatalogNavNode[];
};

export type FeaturedCollectionDef = {
  slug: string;
  title: string;
  description: string;
};

const accents = [
  "from-[#001f3e] to-[#3d5a80]",
  "from-amber-600 to-orange-400",
  "from-[#0d2136] to-[#efc076]",
  "from-rose-700 to-pink-500",
  "from-indigo-700 to-violet-500",
  "from-lime-700 to-green-500",
  "from-fuchsia-700 to-purple-500",
  "from-stone-700 to-amber-500",
] as const;

export function accentForSlug(slug: string): string {
  let hash = 0;
  for (let i = 0; i < slug.length; i++) hash = (hash + slug.charCodeAt(i) * (i + 1)) % accents.length;
  return accents[hash] ?? accents[0];
}

function leaves(names: string[], prefix: string): CatalogNavNode[] {
  return names.map((name) => {
    const base = name
      .toLowerCase()
      .replace(/&/g, "and")
      .replace(/[()/]/g, "")
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/^-|-$/g, "");
    return {
      slug: `${prefix}-${base}`,
      name,
      description: `${name} for ${prefix.replace(/-/g, " ")}`,
    };
  });
}

export const catalogNav: CatalogNavNode[] = [
  {
    slug: "books",
    name: "Books",
    description: "Textbooks and readers for every Ghana school level.",
    children: [
      {
        slug: "nursery-kindergarten",
        name: "Nursery & Kindergarten",
        description: "Early learning books for nursery and KG.",
        children: [
          {
            slug: "nursery-textbooks",
            name: "Nursery Textbooks",
            description: "Core nursery textbooks.",
          },
          ...leaves(
            [
              "Alphabet Books",
              "Numbers & Counting",
              "Picture Books",
              "Phonics Books",
              "Handwriting Books",
              "Coloring & Activity Books",
              "Storybooks",
            ],
            "nursery"
          ),
        ],
      },
      {
        slug: "primary-school",
        name: "Primary School (Class 1–6)",
        description: "Primary textbooks, workbooks, and past questions.",
        children: leaves(
          [
            "English Language",
            "Mathematics",
            "Science",
            "Our World Our People (OWOP)",
            "Creative Arts",
            "Computing / ICT",
            "Ghanaian Language",
            "Religious & Moral Education (RME)",
            "French",
            "History",
            "Career Technology",
            "Workbooks",
            "Past Questions",
          ],
          "primary"
        ),
      },
      {
        slug: "junior-high-school",
        name: "Junior High School (JHS 1–3)",
        description: "JHS course books, literature, and BECE prep.",
        children: leaves(
          [
            "English Language",
            "Mathematics",
            "Science",
            "Social Studies",
            "Computing",
            "Creative Arts & Design",
            "Career Technology",
            "RME",
            "French",
            "Ghanaian Language",
            "Literature",
            "Exam Practice Books",
            "BECE Preparation Books",
            "Past Questions",
          ],
          "jhs"
        ),
      },
      {
        slug: "senior-high-school",
        name: "Senior High School (SHS 1–3)",
        description: "SHS core & elective texts plus WASSCE prep.",
        children: leaves(
          [
            "Core Mathematics",
            "English Language",
            "Integrated Science",
            "Social Studies",
            "Elective Mathematics",
            "Physics",
            "Chemistry",
            "Biology",
            "Economics",
            "Geography",
            "Government",
            "History",
            "Literature in English",
            "Financial Accounting",
            "Cost Accounting",
            "Business Management",
            "Principles of Costing",
            "Food & Nutrition",
            "Management in Living",
            "General Agriculture",
            "Animal Husbandry",
            "Technical Drawing",
            "ICT",
            "French",
            "Christian Religious Studies",
            "Islamic Religious Studies",
            "WASSCE Preparation",
            "Past Questions",
          ],
          "shs"
        ),
      },
    ],
  },
  {
    slug: "stationery",
    name: "Stationery",
    description: "Writing, notebooks, art, geometry, and office supplies.",
    children: [
      {
        slug: "writing-supplies",
        name: "Writing Supplies",
        children: leaves(
          [
            "Pens",
            "Pencils",
            "Mechanical Pencils",
            "Erasers",
            "Sharpeners",
            "Correction Pens",
            "Markers",
            "Highlighters",
            "Whiteboard Markers",
            "Chalk",
          ],
          "writing"
        ),
      },
      {
        slug: "exercise-note-books",
        name: "Exercise & Note Books",
        children: leaves(
          [
            "Exercise Books",
            "Notebooks",
            "Composition Books",
            "Practical Books",
            "Graph Books",
            "Drawing Books",
            "Manuscript Books",
            "Music Books",
          ],
          "notebooks"
        ),
      },
      {
        slug: "art-craft",
        name: "Art & Craft",
        children: leaves(
          [
            "Crayons",
            "Colour Pencils",
            "Water Colours",
            "Poster Colours",
            "Paint Brushes",
            "Sketch Pads",
            "Craft Paper",
            "Cardboard",
            "Glitter",
            "Modelling Clay",
            "Glue",
            "Scissors",
          ],
          "art"
        ),
      },
      {
        slug: "geometry-instruments",
        name: "Geometry & Mathematical Instruments",
        children: leaves(
          [
            "Mathematical Sets",
            "Rulers",
            "Protractors",
            "Compasses",
            "Dividers",
            "Calculators",
            "Geometry Boxes",
          ],
          "geometry"
        ),
      },
      {
        slug: "office-school-supplies",
        name: "Office & School Supplies",
        children: leaves(
          [
            "Files & Folders",
            "Lever Arch Files",
            "Clipboards",
            "Staplers",
            "Staples",
            "Hole Punches",
            "Paper Clips",
            "Sticky Notes",
            "Envelopes",
            "Printing Paper",
            "Laminating Pouches",
          ],
          "office"
        ),
      },
    ],
  },
  {
    slug: "school-essentials",
    name: "School Essentials",
    description: "Everyday bags and cases for school.",
    children: leaves(["Clear bags", "Pencil Cases"], "essentials"),
  },
  {
    slug: "technology",
    name: "Technology",
    description: "Calculators for class and exams.",
    children: leaves(["Scientific Calculators", "Basic Calculators"], "tech"),
  },
  {
    slug: "school-accessories",
    name: "School Accessories",
    description: "Uniform accessories and extras.",
    children: leaves(["Socks", "Belts"], "accessories"),
  },
  {
    slug: "educational-resources",
    name: "Educational Resources",
    description: "Reference materials for home and classroom.",
    children: leaves(
      ["Wall Charts", "Dictionaries", "Atlases", "Encyclopedias"],
      "resources"
    ),
  },
  {
    slug: "by-school-level",
    name: "By School Level",
    description: "Shop by class from Nursery through SHS 3.",
    children: [
      { slug: "level-nursery", name: "Nursery", description: "Nursery class essentials." },
      { slug: "level-kindergarten", name: "Kindergarten", description: "Kindergarten essentials." },
      { slug: "level-primary-1", name: "Primary 1", description: "Primary 1 books & supplies." },
      { slug: "level-primary-2", name: "Primary 2", description: "Primary 2 books & supplies." },
      { slug: "level-primary-3", name: "Primary 3", description: "Primary 3 books & supplies." },
      { slug: "level-primary-4", name: "Primary 4", description: "Primary 4 books & supplies." },
      { slug: "level-primary-5", name: "Primary 5", description: "Primary 5 books & supplies." },
      { slug: "level-primary-6", name: "Primary 6", description: "Primary 6 books & supplies." },
      { slug: "level-jhs-1", name: "JHS 1", description: "JHS 1 books & supplies." },
      { slug: "level-jhs-2", name: "JHS 2", description: "JHS 2 books & supplies." },
      { slug: "level-jhs-3", name: "JHS 3", description: "JHS 3 books & supplies." },
      { slug: "level-shs-1", name: "SHS 1", description: "SHS 1 books & supplies." },
      { slug: "level-shs-2", name: "SHS 2", description: "SHS 2 books & supplies." },
      { slug: "level-shs-3", name: "SHS 3", description: "SHS 3 books & supplies." },
    ],
  },
];

export const featuredCollectionDefs: FeaturedCollectionDef[] = [
  {
    slug: "new-arrivals",
    title: "New Arrivals",
    description: "Fresh titles and supplies just in.",
  },
  {
    slug: "best-sellers",
    title: "Best Sellers",
    description: "What Ghana parents and students buy most.",
  },
  {
    slug: "recommended-by-teachers",
    title: "Recommended by Teachers",
    description: "Classroom-trusted picks from educators.",
  },
  {
    slug: "back-to-school",
    title: "Back to School",
    description: "Everything for a strong school year start.",
  },
  {
    slug: "exam-preparation",
    title: "Exam Preparation",
    description: "BECE, WASSCE, and past-question packs.",
  },
  {
    slug: "childrens-storybooks",
    title: "Children's Storybooks",
    description: "Stories that build a love of reading.",
  },
];

export function flattenCatalogNav(
  nodes: CatalogNavNode[] = catalogNav,
  parentSlug: string | null = null,
  depth = 0
): Array<CatalogNavNode & { parentSlug: string | null; depth: number }> {
  const out: Array<CatalogNavNode & { parentSlug: string | null; depth: number }> = [];
  for (const node of nodes) {
    out.push({ ...node, parentSlug, depth });
    if (node.children?.length) {
      out.push(...flattenCatalogNav(node.children, node.slug, depth + 1));
    }
  }
  return out;
}

export function findCatalogNode(
  slug: string,
  nodes: CatalogNavNode[] = catalogNav
): CatalogNavNode | null {
  for (const node of nodes) {
    if (node.slug === slug) return node;
    if (node.children) {
      const found = findCatalogNode(slug, node.children);
      if (found) return found;
    }
  }
  return null;
}

export function collectDescendantSlugs(node: CatalogNavNode): string[] {
  const slugs = [node.slug];
  for (const child of node.children ?? []) {
    slugs.push(...collectDescendantSlugs(child));
  }
  return slugs;
}

export function catalogBrowseHref(slug: string): string {
  return `/books?category=${encodeURIComponent(slug)}`;
}

export function departmentHref(slug: string): string {
  return `/categories?dept=${encodeURIComponent(slug)}`;
}
