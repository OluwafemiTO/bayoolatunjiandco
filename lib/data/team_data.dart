import '../models/member.dart';

const _placeholderBio =
    "Placeholder biography. Replace with the associate's real background and practice focus.";

// TODO: Bayo's entry uses your supplied content. The other three are PLACEHOLDERS.
const team = <Member>[
  Member('Bayo Olatunji, Esq.', 'Lead Counsel', '', 'BO',
      "Bayo Olatunji, Esq. is the Lead Counsel of BAYO OLATUNJI & CO. He is an experienced legal practitioner with expertise in litigation, corporate and commercial law, property transactions, regulatory compliance, debt recovery, and dispute resolution.\n\nHe has successfully advised and represented individuals, startups, SMEs, corporate organisations, investors, and institutions on diverse legal matters.\n\nHis practice is built on professionalism, strategic thinking, integrity, and an unwavering commitment to protecting clients' interests.",
      highlights: [
        'Litigation and dispute resolution',
        'Corporate and commercial law',
        'Property transactions',
        'Regulatory compliance and debt recovery',
      ]),
  Member('Associate Name', 'Senior Associate', 'LL.B, BL', 'AN', _placeholderBio,
      admissions: ['Nigerian Bar (placeholder)'], highlights: ['Placeholder highlight']),
  Member('Associate Name', 'Associate', 'LL.B, BL', 'AN', _placeholderBio,
      admissions: ['Nigerian Bar (placeholder)'], highlights: ['Placeholder highlight']),
  Member('Associate Name', 'Associate', 'LL.B, BL', 'AN', _placeholderBio,
      admissions: ['Nigerian Bar (placeholder)'], highlights: ['Placeholder highlight']),
];
