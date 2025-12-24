# Investigating a Drop in User Engagement  
**SQL Case Study | Root Cause Analysis**

This repository contains a complete SQL-based analysis that reproduces **all key findings** from  
**“Investigating a Drop in User Engagement: Answers” (ThoughtSpot SQL Analytics tutorial)**.

The goal of this project is not just to compute metrics, but to demonstrate a **structured analytical workflow**:
> **Problem Definition → Hypothesis & Metrics → Analysis → Actionable Improvements → Impact**

---

## 1. Problem Definition

In early September 2014, a sharp decline was observed in **weekly engaged users** on the Yammer engagement dashboard.

- **Engaged user** is defined as a user who generated **at least one `engagement` event during a given week**
- The decline appears sudden and significant, raising concerns about product health

**Objective:**  
Identify *where* and *why* engagement dropped, and narrow the investigation scope so that product and engineering teams can take targeted action.

---

## 2. Hypotheses & Metrics

### 2.1 Initial Hypotheses

To systematically diagnose the issue, the following hypotheses were prioritized:

1. **Growth Issue**  
   Has new user signup or activation declined?

2. **Retention Issue**  
   Is engagement dropping primarily among existing (long-tenured) users rather than new users?

3. **Platform / Device-Specific Issue**  
   Is the decline isolated to a specific device (e.g., mobile)?

4. **Re-engagement Channel Issue**  
   Has the performance of digest emails (open / clickthrough) degraded?

---

### 2.2 Key Metrics

| Category | Metric |
|-------|------|
| Engagement | Weekly Engaged Users |
| Growth | New users / activations by date |
| Retention | Engagement by signup cohort (weeks since signup) |
| Platform | Engagement by device type |
| Re-engagement | Digest email open rate & clickthrough rate |

---

## 3. Analysis (SQL-Driven)

Each hypothesis is validated using a dedicated SQL query.  
All queries are written to be **fully reproducible** and aligned with the official Answer walkthrough.

---

### 3.1 Growth Check — *Is this a growth problem?*

**Finding**
- User growth remains stable
- Normal weekday/weekend patterns persist
- No evidence of a sudden acquisition or activation drop

**Conclusion**
> Engagement decline is **not driven by reduced user growth**

**Query**
- `mysql_src/02_Check_Growth/01_Daily_Signups_All_Users.sql`
- `mysql_src/02_Check_Growth/02_Daily_Signups_Active_Users.sql`

---

### 3.2 Cohort Analysis — *Are existing users disengaging?*

**Finding**
- Engagement drops are concentrated among **older user cohorts**
- Users who signed up **10+ weeks earlier** show the steepest decline

**Conclusion**
> This is primarily a **retention issue**, not a new-user issue

**Query**
- `mysql_src/03_Check_Retention/01_Engagement_by_User_Age_Cohort.sql`

---

### 3.3 Device Breakdown — *Is the issue platform-specific?*

**Finding**
- When segmented by device, engagement on **phone (mobile)** declines sharply
- Other platforms show relatively stable behavior

**Conclusion**
> The issue is **strongly correlated with mobile usage**, suggesting a mobile app or tracking problem

**Query**
- `mysql_src/03_Check_Retention/02_WAU_Increase_Rate_by_Device.sql`

---

### 3.4 Digest Email Funnel — *Is re-engagement failing?*

Digest emails are intended to bring inactive users back into the product.

**Findings**
- Email open rates decline
- **Clickthrough rate drops even more sharply**
- Suggests users either:
  - Do not interact with email content, or
  - Clicks fail to successfully bring users back into the product

**Conclusion**
> Digest email performance degradation likely contributes directly to reduced engagement

**Queries**
- `mysql_src/03_Check_Retention/03_Email_Actions.sql`
- `mysql_src/03_Check_Retention/04_Open_and_Clickthrough_Rates(CTR).sql`

---

## 4. Improvements & Action Items

Based on the analysis, the most efficient next steps are clear.

### 4.1 Engineering / Product Checks (High Priority)

1. **Mobile App Investigation**
   - Review recent mobile releases around the drop
   - Check for session, login, or event-tracking regressions

2. **Digest Email Pipeline Review**
   - Validate email send logic and audience targeting
   - Check for broken links or deep-link failures
   - Verify that email clicks correctly route users into active sessions

---

### 4.2 Follow-Up Analyses (Optional but Recommended)

- Event-level comparison on mobile before vs after the drop
- Click → session → engagement conversion after digest emails
- Separation of email volume vs CTR decline

---

## 5. Impact

This analysis does not attempt to guess the root cause blindly.  
Instead, it **reduces a broad product concern into a focused investigation path**.

### Key Outcomes

- Eliminated growth as the primary cause
- Identified **long-tenured users** as the affected group
- Isolated the issue to **mobile usage**
- Linked engagement loss to **digest email clickthrough degradation**

**Result:**  
Product and engineering teams can move from *“something is wrong”* to  
*“these specific systems should be checked first.”*

