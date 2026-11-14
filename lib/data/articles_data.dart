import '../models/article.dart';

// STARTER DRAFTS: have a qualified lawyer review each article before launch.
// Set `published: false` to hide an article. The slug becomes the web address:
// /#/insights/<slug>
const articles = <Article>[
  Article(
    slug: "business-registration-in-nigeria",
    title: "Business Registration in Nigeria",
    summary: "The main business structures in Nigeria and the steps to register one with the Corporate Affairs Commission.",
    readMinutes: 3,
    sections: [
      ArticleSection(
        heading: "Choosing a structure",
        paragraphs: ["Registration with the Corporate Affairs Commission (CAC) is the first legal step for most businesses. The right structure depends on how you want to run, fund and protect the business."],
        bullets: [
          "Business name: simple and low-cost, suited to sole proprietors and small partnerships, but the owner is personally liable for the business.",
          "Private limited company: a separate legal entity with limited liability for its shareholders, and the usual choice for growing businesses and those seeking investors.",
          "Public limited company: for businesses that plan to raise capital from the public.",
          "Incorporated trustees: for non-profit, religious, social and charitable bodies.",
        ],
      ),
      ArticleSection(
        heading: "The basic steps",
        bullets: [
          "Search for the name you want and reserve it if it is available.",
          "Prepare the incorporation documents, including the company's constitution for a company.",
          "Provide details of the directors, shareholders and registered office address.",
          "File the documents and pay the prescribed fees.",
          "Receive your certificate of registration.",
        ],
      ),
      ArticleSection(
        heading: "After registration",
        paragraphs: ["Registration is only the beginning. You will usually also need to register for tax, open a business bank account and obtain any licences required for your sector. Companies must also file annual returns and keep their records up to date to stay in good standing."],
      ),
    ],
  ),
  Article(
    slug: "property-due-diligence",
    title: "Property Due Diligence",
    summary: "The checks to complete before you pay for land or a building, so you know what you are buying and from whom.",
    readMinutes: 3,
    sections: [
      ArticleSection(
        heading: "Why it matters",
        paragraphs: ["Property disputes are among the most common and costly legal problems. Due diligence is the checking you do before you pay, so you know exactly what you are buying and from whom."],
      ),
      ArticleSection(
        heading: "What a proper check covers",
        bullets: [
          "Title: confirm the seller's root of title and that the documents, such as the Certificate of Occupancy or deed, are genuine and consistent.",
          "Official searches: search the land registry to confirm ownership and look for mortgages, caveats or other encumbrances.",
          "Survey: check the survey plan against the actual land, and confirm it is not affected by government acquisition or other claims.",
          "Litigation: find out whether the property is subject to any court case or dispute.",
          "Seller's authority: confirm the seller's identity and right to sell, especially for family or communal land.",
          "Physical inspection: visit the property and confirm who is in possession.",
        ],
      ),
      ArticleSection(
        heading: "Completing the transaction",
        paragraphs: ["Once the checks are satisfactory, the sale should be documented properly, usually by a deed of assignment, and registered. Where the law requires it, the Governor's consent should be obtained so the transfer is properly effective. Never pay in full before the checks are complete."],
      ),
    ],
  ),
  Article(
    slug: "employment-law-updates",
    title: "Employment Law Updates",
    summary: "Core points for employers and employees, and why regular reviews of your contracts and practices matter.",
    readMinutes: 2,
    sections: [
      ArticleSection(
        heading: "Why keep reviewing",
        // TODO: add specific recent employment law changes here.
        paragraphs: ["Employment rules and regulations change over time, and workplace practices can quickly fall out of step with them. Employers and employees both benefit from checking their position regularly."],
      ),
      ArticleSection(
        heading: "For employers",
        bullets: [
          "Give every employee a clear written contract that sets out role, pay, hours and notice terms.",
          "Follow a fair process for discipline and termination, and keep records.",
          "Make sure statutory contributions and benefits are paid correctly and on time.",
          "Keep workplace policies up to date and make sure staff know them.",
        ],
      ),
      ArticleSection(
        heading: "For employees",
        bullets: [
          "Read your contract before signing and keep a copy.",
          "Keep records of your pay, communications and any complaints you raise.",
          "Seek advice early if you face dismissal, unpaid wages or a disciplinary process.",
        ],
      ),
    ],
  ),
  Article(
    slug: "tax-compliance",
    title: "Tax Compliance",
    summary: "The core tax and filing duties that keep a Nigerian business in good standing.",
    readMinutes: 2,
    sections: [
      ArticleSection(
        heading: "The basics",
        paragraphs: ["Tax compliance is about registering correctly, filing on time and keeping proper records. Penalties and disputes usually come from missed deadlines and poor documentation, not from the tax itself."],
      ),
      ArticleSection(
        heading: "Core obligations",
        bullets: [
          "Register with the relevant tax authorities and keep your tax details current.",
          "File company income tax returns on time, with supporting financial statements.",
          "Account for VAT and withholding tax where they apply to your transactions.",
          "File annual returns with the Corporate Affairs Commission.",
          "Keep invoices, receipts and accounting records in an organised way.",
        ],
      ),
      ArticleSection(
        heading: "Good habits",
        // TODO: verify current tax rules and the names of the administering authorities.
        paragraphs: ["Keep a calendar of filing deadlines, review your obligations when your business changes, and seek advice before restructuring or entering large transactions. Tax rules and the authorities that administer them can change, so confirm current requirements before you file."],
      ),
    ],
  ),
  Article(
    slug: "commercial-contracts",
    title: "Commercial Contracts",
    summary: "The clauses to check and the mistakes to avoid before you sign a business agreement.",
    readMinutes: 3,
    sections: [
      ArticleSection(
        heading: "A good contract prevents disputes",
        paragraphs: ["A clear written contract protects both sides by recording what was agreed, so memory and goodwill are not all you have to rely on."],
      ),
      ArticleSection(
        heading: "Clauses to check",
        bullets: [
          "Parties and scope: who is involved and exactly what is to be delivered.",
          "Price and payment: amounts, dates, and what happens if payment is late.",
          "Term and termination: how long it lasts and how either side can end it.",
          "Liability and indemnity: who bears the risk if something goes wrong.",
          "Confidentiality: protection for sensitive business information.",
          "Dispute resolution and governing law: how disagreements are resolved and under which law.",
        ],
      ),
      ArticleSection(
        heading: "Common mistakes",
        bullets: [
          "Relying on verbal agreements or informal messages.",
          "Using vague language about deliverables and deadlines.",
          "Signing a standard form without reading it.",
          "Leaving out a dispute resolution clause.",
        ],
      ),
    ],
  ),
  Article(
    slug: "debt-recovery-strategies",
    title: "Debt Recovery Strategies",
    summary: "A practical path from first reminder to enforcement, and how to avoid unpaid debts in the first place.",
    readMinutes: 3,
    sections: [
      ArticleSection(
        heading: "Start with the paperwork",
        paragraphs: ["Before you take any step, gather the contract, invoices, delivery records and correspondence that prove the debt. Strong documents make every later stage faster and cheaper."],
      ),
      ArticleSection(
        heading: "A practical escalation path",
        bullets: [
          "Send a clear written demand stating the amount owed and a deadline to pay.",
          "Negotiate, and consider a written payment plan if the debtor genuinely cannot pay in full.",
          "Try mediation or another form of alternative dispute resolution to settle without court.",
          "If these fail, start legal proceedings and, after judgment, use the available enforcement options.",
        ],
      ),
      ArticleSection(
        heading: "Act early",
        paragraphs: ["Claims are subject to time limits, and a debtor's finances can deteriorate the longer you wait. Prevention also helps: check customers before extending credit, put payment terms in writing and follow up late invoices promptly."],
      ),
    ],
  ),
  Article(
    slug: "immigration-law",
    title: "Immigration Law",
    summary: "How to prepare a stronger visa application, and what to do if it is refused.",
    readMinutes: 3,
    sections: [
      ArticleSection(
        heading: "Preparing your application",
        paragraphs: ["Requirements differ by country and visa type, so start by confirming the right category and the current official checklist."],
        bullets: [
          "Check that your passport has enough validity.",
          "Gather proof of your purpose of travel, finances and ties to your home country.",
          "Where needed, obtain a proper invitation letter and have documents notarised or translated.",
          "Make sure every detail is accurate and consistent across all documents.",
        ],
      ),
      ArticleSection(
        heading: "If your application is refused",
        paragraphs: ["A refusal is not always the end. Read the reasons carefully. Depending on the country and visa, you may be able to request an administrative review, appeal, or submit a fresh application that addresses the reasons given. Avoid reapplying unchanged, as repeating the same weaknesses usually leads to the same result."],
      ),
    ],
  ),
  Article(
    slug: "real-estate-investment",
    title: "Real Estate Investment",
    summary: "The legal foundations to put in place before you invest in property.",
    readMinutes: 3,
    sections: [
      ArticleSection(
        heading: "Know what you are buying",
        paragraphs: ["Real estate can be a strong investment, but returns depend on getting the legal foundations right before money changes hands."],
      ),
      ArticleSection(
        heading: "Legal points to cover",
        bullets: [
          "Complete title due diligence on the property and on the seller or developer.",
          "Choose the right structure, such as outright purchase, lease or joint venture, and document it properly.",
          "For off-plan or developer projects, verify approvals and tie payments to agreed stages.",
          "Register the transaction and obtain the proper documents, including any required consent.",
          "Understand the tax and cost implications before you commit.",
        ],
      ),
      ArticleSection(
        heading: "Protect your position",
        paragraphs: ["Put every term in a written agreement, keep proof of all payments, and have a lawyer review the documents before you sign."],
      ),
    ],
  ),
];

List<Article> get publishedArticles => articles.where((a) => a.published).toList();

Article? findArticle(String slug) {
  for (final a in articles) {
    if (a.slug == slug && a.published) return a;
  }
  return null;
}
