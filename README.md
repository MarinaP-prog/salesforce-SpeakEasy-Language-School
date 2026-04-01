# Salesforce Project – ARES Integration for Account Management

## 📌 Overview
This Salesforce project demonstrates a hybrid data validation and enrichment solution combining Apex, Triggers, and Screen Flows.

The system handles two main scenarios:

### 👤 Person Accounts validation
A trigger validates Czech personal identification numbers (RČ).  
If the format is invalid, an error is logged.

### 🏢 Company Accounts enrichment (ARES integration)
For business accounts, the system integrates with the Czech ARES registry:
- User enters company ICO via Screen Flow
- Apex callout retrieves company data from ARES API
- Data is displayed for user review and correction
- Account is created or updated based on existence check

---

## ⚙️ Key Components
- Apex callout integration (ARES API)
- Screen Flow for user interaction and data review
- Apex Trigger for Person Account validation (RČ format check)
- Account create/update logic based on ICO
- Custom object and field configuration
- Profiles, Permission Sets, and sharing settings setup
- Field-Level Security (FLS) configuration
- Lightning Pages customization

---

## 🔄 Business Flow (Company Accounts)
1. User enters ICO in Screen Flow
2. System checks if Account already exists
3. Apex callout retrieves company data from ARES API
4. User reviews and optionally edits data
5. Decision:
   - If Account exists → update record
   - If not → create new Account
6. Record is saved to Salesforce

---

## 🧠 Technical Highlights
- Apex REST callout with JSON parsing
- Invocable Apex for Flow integration
- Structured error handling (HTTP 400–500 responses)
- Modular separation of response handling logic
- Use of Screen Flow as UI layer
- Trigger-based validation for Person Accounts (RČ format)

---

## 🧪 Testing
- Mocked callouts using StaticResourceCalloutMock
- Unit tests for success and error scenarios
- Coverage of HTTP status handling

---

## 🚀 Future Improvements
- Custom LWC wrapper for Flow UI (improved user experience)
- Enhanced duplicate detection logic
- Better UX for Flow screens

---


## 👩‍💻 Author
Marina Pavolová  
Salesforce Developer (learning project)