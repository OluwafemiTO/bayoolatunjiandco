import 'package:flutter/material.dart';
import '../models/service.dart';

const services = <Service>[
  Service('Litigation & Dispute Resolution', 'litigation', Icons.gavel,
      blurb: 'Representation before all courts and tribunals in Nigeria, including civil, commercial, criminal, employment, and constitutional matters.'),
  Service('Corporate & Commercial Law', 'corporate-law', Icons.business_center, items: [
    'Company Incorporation', 'Corporate Governance', 'Regulatory Compliance',
    'Shareholder Agreements', 'Business Restructuring', 'Corporate Secretarial Services'
  ]),
  Service('Property & Real Estate', 'real-estate', Icons.apartment, items: [
    'Property Documentation', 'Land Verification', 'Due Diligence',
    'Deeds of Assignment', "Governor's Consent", 'Leases', 'Mortgages',
    'Joint Venture Agreements'
  ]),
  Service('Debt Recovery', 'debt-recovery', Icons.account_balance_wallet,
      blurb: 'Efficient recovery of commercial debts through negotiation, mediation, and litigation.'),
  Service('Tax & Regulatory Advisory', 'tax-regulatory', Icons.receipt_long,
      blurb: 'Professional guidance on corporate compliance, CAC filings, FIRS matters, annual returns, and regulatory obligations.'),
  Service('Employment & Labour Law', 'employment', Icons.groups,
      blurb: 'Advising employers and employees on contracts, workplace disputes, disciplinary matters, and compliance.'),
  Service('Immigration & Consular Services', 'immigration', Icons.flight_takeoff, items: [
    'Visa Applications', 'Administrative Reviews', 'Appeals',
    'Invitation Letters', 'Legal Documentation', 'Notarisation'
  ]),
  Service('Family & Probate', 'family-probate', Icons.family_restroom, items: [
    'Wills', 'Probate', 'Letters of Administration', 'Estate Planning', 'Family Settlements'
  ]),
  Service('Intellectual Property', 'intellectual-property', Icons.copyright,
      blurb: 'Protection and registration of trademarks, copyrights, and related intellectual property rights.'),
];
