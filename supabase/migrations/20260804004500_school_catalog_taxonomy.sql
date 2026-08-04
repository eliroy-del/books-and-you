-- School & stationery catalog taxonomy
ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS parent_id uuid REFERENCES public.categories(id) ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS categories_parent_id_idx ON public.categories(parent_id);
ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS depth integer NOT NULL DEFAULT 0;

-- Clear old taxonomy links and rows (preserve books)
DELETE FROM public.book_categories;
DELETE FROM public.collection_books;
DELETE FROM public.collections;
DELETE FROM public.categories;

CREATE TEMP TABLE nodes (
  slug text,
  name text,
  description text,
  accent text,
  sort_order integer,
  parent_slug text,
  depth integer
);

INSERT INTO nodes (slug, name, description, accent, sort_order, parent_slug, depth) VALUES
  ('books', 'Books', 'Textbooks and readers for every Ghana school level.', 'from-teal-700 to-emerald-500', 0, NULL, 0),
  ('nursery-kindergarten', 'Nursery & Kindergarten', 'Early learning books for nursery and KG.', 'from-indigo-700 to-violet-500', 1, 'books', 1),
  ('nursery-textbooks', 'Nursery Textbooks', 'Core nursery textbooks.', 'from-indigo-700 to-violet-500', 2, 'nursery-kindergarten', 2),
  ('nursery-alphabet-books', 'Alphabet Books', 'Alphabet Books for nursery', 'from-fuchsia-700 to-purple-500', 3, 'nursery-kindergarten', 2),
  ('nursery-numbers-and-counting', 'Numbers & Counting', 'Numbers & Counting for nursery', 'from-indigo-700 to-violet-500', 4, 'nursery-kindergarten', 2),
  ('nursery-picture-books', 'Picture Books', 'Picture Books for nursery', 'from-amber-600 to-orange-400', 5, 'nursery-kindergarten', 2),
  ('nursery-phonics-books', 'Phonics Books', 'Phonics Books for nursery', 'from-stone-700 to-amber-500', 6, 'nursery-kindergarten', 2),
  ('nursery-handwriting-books', 'Handwriting Books', 'Handwriting Books for nursery', 'from-fuchsia-700 to-purple-500', 7, 'nursery-kindergarten', 2),
  ('nursery-coloring-and-activity-books', 'Coloring & Activity Books', 'Coloring & Activity Books for nursery', 'from-lime-700 to-green-500', 8, 'nursery-kindergarten', 2),
  ('nursery-storybooks', 'Storybooks', 'Storybooks for nursery', 'from-amber-600 to-orange-400', 9, 'nursery-kindergarten', 2),
  ('primary-school', 'Primary School (Class 1–6)', 'Primary textbooks, workbooks, and past questions.', 'from-rose-700 to-pink-500', 10, 'books', 1),
  ('primary-english-language', 'English Language', 'English Language for primary', 'from-indigo-700 to-violet-500', 11, 'primary-school', 2),
  ('primary-mathematics', 'Mathematics', 'Mathematics for primary', 'from-indigo-700 to-violet-500', 12, 'primary-school', 2),
  ('primary-science', 'Science', 'Science for primary', 'from-fuchsia-700 to-purple-500', 13, 'primary-school', 2),
  ('primary-our-world-our-people-owop', 'Our World Our People (OWOP)', 'Our World Our People (OWOP) for primary', 'from-rose-700 to-pink-500', 14, 'primary-school', 2),
  ('primary-creative-arts', 'Creative Arts', 'Creative Arts for primary', 'from-lime-700 to-green-500', 15, 'primary-school', 2),
  ('primary-computing-ict', 'Computing / ICT', 'Computing / ICT for primary', 'from-stone-700 to-amber-500', 16, 'primary-school', 2),
  ('primary-ghanaian-language', 'Ghanaian Language', 'Ghanaian Language for primary', 'from-indigo-700 to-violet-500', 17, 'primary-school', 2),
  ('primary-religious-and-moral-education-rme', 'Religious & Moral Education (RME)', 'Religious & Moral Education (RME) for primary', 'from-lime-700 to-green-500', 18, 'primary-school', 2),
  ('primary-french', 'French', 'French for primary', 'from-rose-700 to-pink-500', 19, 'primary-school', 2),
  ('primary-history', 'History', 'History for primary', 'from-indigo-700 to-violet-500', 20, 'primary-school', 2),
  ('primary-career-technology', 'Career Technology', 'Career Technology for primary', 'from-sky-700 to-cyan-500', 21, 'primary-school', 2),
  ('primary-workbooks', 'Workbooks', 'Workbooks for primary', 'from-sky-700 to-cyan-500', 22, 'primary-school', 2),
  ('primary-past-questions', 'Past Questions', 'Past Questions for primary', 'from-sky-700 to-cyan-500', 23, 'primary-school', 2),
  ('junior-high-school', 'Junior High School (JHS 1–3)', 'JHS course books, literature, and BECE prep.', 'from-stone-700 to-amber-500', 24, 'books', 1),
  ('jhs-english-language', 'English Language', 'English Language for jhs', 'from-indigo-700 to-violet-500', 25, 'junior-high-school', 2),
  ('jhs-mathematics', 'Mathematics', 'Mathematics for jhs', 'from-teal-700 to-emerald-500', 26, 'junior-high-school', 2),
  ('jhs-science', 'Science', 'Science for jhs', 'from-sky-700 to-cyan-500', 27, 'junior-high-school', 2),
  ('jhs-social-studies', 'Social Studies', 'Social Studies for jhs', 'from-sky-700 to-cyan-500', 28, 'junior-high-school', 2),
  ('jhs-computing', 'Computing', 'Computing for jhs', 'from-fuchsia-700 to-purple-500', 29, 'junior-high-school', 2),
  ('jhs-creative-arts-and-design', 'Creative Arts & Design', 'Creative Arts & Design for jhs', 'from-fuchsia-700 to-purple-500', 30, 'junior-high-school', 2),
  ('jhs-career-technology', 'Career Technology', 'Career Technology for jhs', 'from-sky-700 to-cyan-500', 31, 'junior-high-school', 2),
  ('jhs-rme', 'RME', 'RME for jhs', 'from-sky-700 to-cyan-500', 32, 'junior-high-school', 2),
  ('jhs-french', 'French', 'French for jhs', 'from-stone-700 to-amber-500', 33, 'junior-high-school', 2),
  ('jhs-ghanaian-language', 'Ghanaian Language', 'Ghanaian Language for jhs', 'from-teal-700 to-emerald-500', 34, 'junior-high-school', 2),
  ('jhs-literature', 'Literature', 'Literature for jhs', 'from-amber-600 to-orange-400', 35, 'junior-high-school', 2),
  ('jhs-exam-practice-books', 'Exam Practice Books', 'Exam Practice Books for jhs', 'from-stone-700 to-amber-500', 36, 'junior-high-school', 2),
  ('jhs-bece-preparation-books', 'BECE Preparation Books', 'BECE Preparation Books for jhs', 'from-amber-600 to-orange-400', 37, 'junior-high-school', 2),
  ('jhs-past-questions', 'Past Questions', 'Past Questions for jhs', 'from-fuchsia-700 to-purple-500', 38, 'junior-high-school', 2),
  ('senior-high-school', 'Senior High School (SHS 1–3)', 'SHS core & elective texts plus WASSCE prep.', 'from-teal-700 to-emerald-500', 39, 'books', 1),
  ('shs-core-mathematics', 'Core Mathematics', 'Core Mathematics for shs', 'from-lime-700 to-green-500', 40, 'senior-high-school', 2),
  ('shs-english-language', 'English Language', 'English Language for shs', 'from-lime-700 to-green-500', 41, 'senior-high-school', 2),
  ('shs-integrated-science', 'Integrated Science', 'Integrated Science for shs', 'from-teal-700 to-emerald-500', 42, 'senior-high-school', 2),
  ('shs-social-studies', 'Social Studies', 'Social Studies for shs', 'from-rose-700 to-pink-500', 43, 'senior-high-school', 2),
  ('shs-elective-mathematics', 'Elective Mathematics', 'Elective Mathematics for shs', 'from-sky-700 to-cyan-500', 44, 'senior-high-school', 2),
  ('shs-physics', 'Physics', 'Physics for shs', 'from-stone-700 to-amber-500', 45, 'senior-high-school', 2),
  ('shs-chemistry', 'Chemistry', 'Chemistry for shs', 'from-sky-700 to-cyan-500', 46, 'senior-high-school', 2),
  ('shs-biology', 'Biology', 'Biology for shs', 'from-amber-600 to-orange-400', 47, 'senior-high-school', 2),
  ('shs-economics', 'Economics', 'Economics for shs', 'from-rose-700 to-pink-500', 48, 'senior-high-school', 2),
  ('shs-geography', 'Geography', 'Geography for shs', 'from-rose-700 to-pink-500', 49, 'senior-high-school', 2),
  ('shs-government', 'Government', 'Government for shs', 'from-fuchsia-700 to-purple-500', 50, 'senior-high-school', 2),
  ('shs-history', 'History', 'History for shs', 'from-amber-600 to-orange-400', 51, 'senior-high-school', 2),
  ('shs-literature-in-english', 'Literature in English', 'Literature in English for shs', 'from-fuchsia-700 to-purple-500', 52, 'senior-high-school', 2),
  ('shs-financial-accounting', 'Financial Accounting', 'Financial Accounting for shs', 'from-fuchsia-700 to-purple-500', 53, 'senior-high-school', 2),
  ('shs-cost-accounting', 'Cost Accounting', 'Cost Accounting for shs', 'from-stone-700 to-amber-500', 54, 'senior-high-school', 2),
  ('shs-business-management', 'Business Management', 'Business Management for shs', 'from-rose-700 to-pink-500', 55, 'senior-high-school', 2),
  ('shs-principles-of-costing', 'Principles of Costing', 'Principles of Costing for shs', 'from-teal-700 to-emerald-500', 56, 'senior-high-school', 2),
  ('shs-food-and-nutrition', 'Food & Nutrition', 'Food & Nutrition for shs', 'from-lime-700 to-green-500', 57, 'senior-high-school', 2),
  ('shs-management-in-living', 'Management in Living', 'Management in Living for shs', 'from-indigo-700 to-violet-500', 58, 'senior-high-school', 2),
  ('shs-general-agriculture', 'General Agriculture', 'General Agriculture for shs', 'from-lime-700 to-green-500', 59, 'senior-high-school', 2),
  ('shs-animal-husbandry', 'Animal Husbandry', 'Animal Husbandry for shs', 'from-amber-600 to-orange-400', 60, 'senior-high-school', 2),
  ('shs-technical-drawing', 'Technical Drawing', 'Technical Drawing for shs', 'from-stone-700 to-amber-500', 61, 'senior-high-school', 2),
  ('shs-ict', 'ICT', 'ICT for shs', 'from-rose-700 to-pink-500', 62, 'senior-high-school', 2),
  ('shs-french', 'French', 'French for shs', 'from-teal-700 to-emerald-500', 63, 'senior-high-school', 2),
  ('shs-christian-religious-studies', 'Christian Religious Studies', 'Christian Religious Studies for shs', 'from-teal-700 to-emerald-500', 64, 'senior-high-school', 2),
  ('shs-islamic-religious-studies', 'Islamic Religious Studies', 'Islamic Religious Studies for shs', 'from-sky-700 to-cyan-500', 65, 'senior-high-school', 2),
  ('shs-wassce-preparation', 'WASSCE Preparation', 'WASSCE Preparation for shs', 'from-lime-700 to-green-500', 66, 'senior-high-school', 2),
  ('shs-past-questions', 'Past Questions', 'Past Questions for shs', 'from-stone-700 to-amber-500', 67, 'senior-high-school', 2),
  ('stationery', 'Stationery', 'Writing, notebooks, art, geometry, and office supplies.', 'from-rose-700 to-pink-500', 68, NULL, 0),
  ('writing-supplies', 'Writing Supplies', 'Writing Supplies', 'from-sky-700 to-cyan-500', 69, 'stationery', 1),
  ('writing-pens', 'Pens', 'Pens for writing', 'from-teal-700 to-emerald-500', 70, 'writing-supplies', 2),
  ('writing-pencils', 'Pencils', 'Pencils for writing', 'from-sky-700 to-cyan-500', 71, 'writing-supplies', 2),
  ('writing-mechanical-pencils', 'Mechanical Pencils', 'Mechanical Pencils for writing', 'from-indigo-700 to-violet-500', 72, 'writing-supplies', 2),
  ('writing-erasers', 'Erasers', 'Erasers for writing', 'from-sky-700 to-cyan-500', 73, 'writing-supplies', 2),
  ('writing-sharpeners', 'Sharpeners', 'Sharpeners for writing', 'from-fuchsia-700 to-purple-500', 74, 'writing-supplies', 2),
  ('writing-correction-pens', 'Correction Pens', 'Correction Pens for writing', 'from-sky-700 to-cyan-500', 75, 'writing-supplies', 2),
  ('writing-markers', 'Markers', 'Markers for writing', 'from-rose-700 to-pink-500', 76, 'writing-supplies', 2),
  ('writing-highlighters', 'Highlighters', 'Highlighters for writing', 'from-sky-700 to-cyan-500', 77, 'writing-supplies', 2),
  ('writing-whiteboard-markers', 'Whiteboard Markers', 'Whiteboard Markers for writing', 'from-rose-700 to-pink-500', 78, 'writing-supplies', 2),
  ('writing-chalk', 'Chalk', 'Chalk for writing', 'from-lime-700 to-green-500', 79, 'writing-supplies', 2),
  ('exercise-note-books', 'Exercise & Note Books', 'Exercise & Note Books', 'from-stone-700 to-amber-500', 80, 'stationery', 1),
  ('notebooks-exercise-books', 'Exercise Books', 'Exercise Books for notebooks', 'from-lime-700 to-green-500', 81, 'exercise-note-books', 2),
  ('notebooks-notebooks', 'Notebooks', 'Notebooks for notebooks', 'from-sky-700 to-cyan-500', 82, 'exercise-note-books', 2),
  ('notebooks-composition-books', 'Composition Books', 'Composition Books for notebooks', 'from-lime-700 to-green-500', 83, 'exercise-note-books', 2),
  ('notebooks-practical-books', 'Practical Books', 'Practical Books for notebooks', 'from-fuchsia-700 to-purple-500', 84, 'exercise-note-books', 2),
  ('notebooks-graph-books', 'Graph Books', 'Graph Books for notebooks', 'from-teal-700 to-emerald-500', 85, 'exercise-note-books', 2),
  ('notebooks-drawing-books', 'Drawing Books', 'Drawing Books for notebooks', 'from-lime-700 to-green-500', 86, 'exercise-note-books', 2),
  ('notebooks-manuscript-books', 'Manuscript Books', 'Manuscript Books for notebooks', 'from-lime-700 to-green-500', 87, 'exercise-note-books', 2),
  ('notebooks-music-books', 'Music Books', 'Music Books for notebooks', 'from-rose-700 to-pink-500', 88, 'exercise-note-books', 2),
  ('art-craft', 'Art & Craft', 'Art & Craft', 'from-rose-700 to-pink-500', 89, 'stationery', 1),
  ('art-crayons', 'Crayons', 'Crayons for art', 'from-rose-700 to-pink-500', 90, 'art-craft', 2),
  ('art-colour-pencils', 'Colour Pencils', 'Colour Pencils for art', 'from-fuchsia-700 to-purple-500', 91, 'art-craft', 2),
  ('art-water-colours', 'Water Colours', 'Water Colours for art', 'from-stone-700 to-amber-500', 92, 'art-craft', 2),
  ('art-poster-colours', 'Poster Colours', 'Poster Colours for art', 'from-indigo-700 to-violet-500', 93, 'art-craft', 2),
  ('art-paint-brushes', 'Paint Brushes', 'Paint Brushes for art', 'from-indigo-700 to-violet-500', 94, 'art-craft', 2),
  ('art-sketch-pads', 'Sketch Pads', 'Sketch Pads for art', 'from-lime-700 to-green-500', 95, 'art-craft', 2),
  ('art-craft-paper', 'Craft Paper', 'Craft Paper for art', 'from-lime-700 to-green-500', 96, 'art-craft', 2),
  ('art-cardboard', 'Cardboard', 'Cardboard for art', 'from-stone-700 to-amber-500', 97, 'art-craft', 2),
  ('art-glitter', 'Glitter', 'Glitter for art', 'from-rose-700 to-pink-500', 98, 'art-craft', 2),
  ('art-modelling-clay', 'Modelling Clay', 'Modelling Clay for art', 'from-indigo-700 to-violet-500', 99, 'art-craft', 2),
  ('art-glue', 'Glue', 'Glue for art', 'from-rose-700 to-pink-500', 100, 'art-craft', 2),
  ('art-scissors', 'Scissors', 'Scissors for art', 'from-teal-700 to-emerald-500', 101, 'art-craft', 2),
  ('geometry-instruments', 'Geometry & Mathematical Instruments', 'Geometry & Mathematical Instruments', 'from-sky-700 to-cyan-500', 102, 'stationery', 1),
  ('geometry-mathematical-sets', 'Mathematical Sets', 'Mathematical Sets for geometry', 'from-teal-700 to-emerald-500', 103, 'geometry-instruments', 2),
  ('geometry-rulers', 'Rulers', 'Rulers for geometry', 'from-rose-700 to-pink-500', 104, 'geometry-instruments', 2),
  ('geometry-protractors', 'Protractors', 'Protractors for geometry', 'from-rose-700 to-pink-500', 105, 'geometry-instruments', 2),
  ('geometry-compasses', 'Compasses', 'Compasses for geometry', 'from-rose-700 to-pink-500', 106, 'geometry-instruments', 2),
  ('geometry-dividers', 'Dividers', 'Dividers for geometry', 'from-indigo-700 to-violet-500', 107, 'geometry-instruments', 2),
  ('geometry-calculators', 'Calculators', 'Calculators for geometry', 'from-indigo-700 to-violet-500', 108, 'geometry-instruments', 2),
  ('geometry-geometry-boxes', 'Geometry Boxes', 'Geometry Boxes for geometry', 'from-sky-700 to-cyan-500', 109, 'geometry-instruments', 2),
  ('office-school-supplies', 'Office & School Supplies', 'Office & School Supplies', 'from-stone-700 to-amber-500', 110, 'stationery', 1),
  ('office-files-and-folders', 'Files & Folders', 'Files & Folders for office', 'from-indigo-700 to-violet-500', 111, 'office-school-supplies', 2),
  ('office-lever-arch-files', 'Lever Arch Files', 'Lever Arch Files for office', 'from-lime-700 to-green-500', 112, 'office-school-supplies', 2),
  ('office-clipboards', 'Clipboards', 'Clipboards for office', 'from-amber-600 to-orange-400', 113, 'office-school-supplies', 2),
  ('office-staplers', 'Staplers', 'Staplers for office', 'from-amber-600 to-orange-400', 114, 'office-school-supplies', 2),
  ('office-staples', 'Staples', 'Staples for office', 'from-sky-700 to-cyan-500', 115, 'office-school-supplies', 2),
  ('office-hole-punches', 'Hole Punches', 'Hole Punches for office', 'from-fuchsia-700 to-purple-500', 116, 'office-school-supplies', 2),
  ('office-paper-clips', 'Paper Clips', 'Paper Clips for office', 'from-fuchsia-700 to-purple-500', 117, 'office-school-supplies', 2),
  ('office-sticky-notes', 'Sticky Notes', 'Sticky Notes for office', 'from-teal-700 to-emerald-500', 118, 'office-school-supplies', 2),
  ('office-envelopes', 'Envelopes', 'Envelopes for office', 'from-teal-700 to-emerald-500', 119, 'office-school-supplies', 2),
  ('office-printing-paper', 'Printing Paper', 'Printing Paper for office', 'from-amber-600 to-orange-400', 120, 'office-school-supplies', 2),
  ('office-laminating-pouches', 'Laminating Pouches', 'Laminating Pouches for office', 'from-fuchsia-700 to-purple-500', 121, 'office-school-supplies', 2),
  ('school-essentials', 'School Essentials', 'Everyday bags and cases for school.', 'from-stone-700 to-amber-500', 122, NULL, 0),
  ('essentials-clear-bags', 'Clear bags', 'Clear bags for essentials', 'from-sky-700 to-cyan-500', 123, 'school-essentials', 1),
  ('essentials-pencil-cases', 'Pencil Cases', 'Pencil Cases for essentials', 'from-lime-700 to-green-500', 124, 'school-essentials', 1),
  ('technology', 'Technology', 'Calculators for class and exams.', 'from-indigo-700 to-violet-500', 125, NULL, 0),
  ('tech-scientific-calculators', 'Scientific Calculators', 'Scientific Calculators for tech', 'from-sky-700 to-cyan-500', 126, 'technology', 1),
  ('tech-basic-calculators', 'Basic Calculators', 'Basic Calculators for tech', 'from-amber-600 to-orange-400', 127, 'technology', 1),
  ('school-accessories', 'School Accessories', 'Uniform accessories and extras.', 'from-amber-600 to-orange-400', 128, NULL, 0),
  ('accessories-socks', 'Socks', 'Socks for accessories', 'from-stone-700 to-amber-500', 129, 'school-accessories', 1),
  ('accessories-belts', 'Belts', 'Belts for accessories', 'from-lime-700 to-green-500', 130, 'school-accessories', 1),
  ('educational-resources', 'Educational Resources', 'Reference materials for home and classroom.', 'from-fuchsia-700 to-purple-500', 131, NULL, 0),
  ('resources-wall-charts', 'Wall Charts', 'Wall Charts for resources', 'from-stone-700 to-amber-500', 132, 'educational-resources', 1),
  ('resources-dictionaries', 'Dictionaries', 'Dictionaries for resources', 'from-rose-700 to-pink-500', 133, 'educational-resources', 1),
  ('resources-atlases', 'Atlases', 'Atlases for resources', 'from-lime-700 to-green-500', 134, 'educational-resources', 1),
  ('resources-encyclopedias', 'Encyclopedias', 'Encyclopedias for resources', 'from-stone-700 to-amber-500', 135, 'educational-resources', 1),
  ('by-school-level', 'By School Level', 'Shop by class from Nursery through SHS 3.', 'from-lime-700 to-green-500', 136, NULL, 0),
  ('level-nursery', 'Nursery', 'Nursery class essentials.', 'from-indigo-700 to-violet-500', 137, 'by-school-level', 1),
  ('level-kindergarten', 'Kindergarten', 'Kindergarten essentials.', 'from-teal-700 to-emerald-500', 138, 'by-school-level', 1),
  ('level-primary-1', 'Primary 1', 'Primary 1 books & supplies.', 'from-fuchsia-700 to-purple-500', 139, 'by-school-level', 1),
  ('level-primary-2', 'Primary 2', 'Primary 2 books & supplies.', 'from-lime-700 to-green-500', 140, 'by-school-level', 1),
  ('level-primary-3', 'Primary 3', 'Primary 3 books & supplies.', 'from-indigo-700 to-violet-500', 141, 'by-school-level', 1),
  ('level-primary-4', 'Primary 4', 'Primary 4 books & supplies.', 'from-rose-700 to-pink-500', 142, 'by-school-level', 1),
  ('level-primary-5', 'Primary 5', 'Primary 5 books & supplies.', 'from-sky-700 to-cyan-500', 143, 'by-school-level', 1),
  ('level-primary-6', 'Primary 6', 'Primary 6 books & supplies.', 'from-amber-600 to-orange-400', 144, 'by-school-level', 1),
  ('level-jhs-1', 'JHS 1', 'JHS 1 books & supplies.', 'from-indigo-700 to-violet-500', 145, 'by-school-level', 1),
  ('level-jhs-2', 'JHS 2', 'JHS 2 books & supplies.', 'from-stone-700 to-amber-500', 146, 'by-school-level', 1),
  ('level-jhs-3', 'JHS 3', 'JHS 3 books & supplies.', 'from-sky-700 to-cyan-500', 147, 'by-school-level', 1),
  ('level-shs-1', 'SHS 1', 'SHS 1 books & supplies.', 'from-rose-700 to-pink-500', 148, 'by-school-level', 1),
  ('level-shs-2', 'SHS 2', 'SHS 2 books & supplies.', 'from-fuchsia-700 to-purple-500', 149, 'by-school-level', 1),
  ('level-shs-3', 'SHS 3', 'SHS 3 books & supplies.', 'from-amber-600 to-orange-400', 150, 'by-school-level', 1);

INSERT INTO public.categories (slug, name, description, accent, sort_order, depth, is_featured)
SELECT slug, name, description, accent, sort_order, depth, depth = 0
FROM nodes;

UPDATE public.categories c
SET parent_id = p.id
FROM nodes n
JOIN public.categories p ON p.slug = n.parent_slug
WHERE c.slug = n.slug AND n.parent_slug IS NOT NULL;

INSERT INTO public.collections (slug, title, description, is_featured, sort_order) VALUES
  ('new-arrivals', 'New Arrivals', 'Fresh titles and supplies just in.', true, 0),
  ('best-sellers', 'Best Sellers', 'What Ghana parents and students buy most.', true, 1),
  ('recommended-by-teachers', 'Recommended by Teachers', 'Classroom-trusted picks from educators.', true, 2),
  ('back-to-school', 'Back to School', 'Everything for a strong school year start.', true, 3),
  ('exam-preparation', 'Exam Preparation', 'BECE, WASSCE, and past-question packs.', true, 4),
  ('childrens-storybooks', 'Children''s Storybooks', 'Stories that build a love of reading.', true, 5)
;

-- Soft-assign existing books into nearest new categories
INSERT INTO public.book_categories (book_id, category_id)
SELECT b.id, c.id
FROM public.books b
CROSS JOIN LATERAL (
  SELECT id FROM public.categories
  WHERE slug = CASE
    WHEN b.title ILIKE '%math%' OR b.title ILIKE '%algebra%' THEN 'primary-mathematics'
    WHEN b.title ILIKE '%science%' THEN 'primary-science'
    WHEN b.title ILIKE '%english%' OR b.title ILIKE '%grammar%' THEN 'primary-english-language'
    WHEN lower(array_to_string(b.genres, ' ')) LIKE '%child%' THEN 'nursery-storybooks'
    WHEN lower(array_to_string(b.genres, ' ')) LIKE '%academic%' OR lower(array_to_string(b.genres, ' ')) LIKE '%education%' THEN 'primary-workbooks'
    ELSE 'nursery-storybooks'
  END
  LIMIT 1
) c
WHERE c.id IS NOT NULL
ON CONFLICT DO NOTHING;

-- Fallback: any uncategorized book → nursery storybooks
INSERT INTO public.book_categories (book_id, category_id)
SELECT b.id, c.id FROM public.books b
JOIN public.categories c ON c.slug = 'nursery-storybooks'
WHERE NOT EXISTS (SELECT 1 FROM public.book_categories bc WHERE bc.book_id = b.id)
ON CONFLICT DO NOTHING;

-- Seed featured collections with sample books
INSERT INTO public.collection_books (collection_id, book_id, sort_order)
SELECT col.id, b.id, (row_number() OVER (PARTITION BY col.id ORDER BY b.created_at DESC) - 1)::int
FROM public.collections col
CROSS JOIN LATERAL (
  SELECT id, created_at FROM public.books ORDER BY created_at DESC LIMIT 12
) b
ON CONFLICT DO NOTHING;
