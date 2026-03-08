# Consent and trackers

## Current state

The current `flutter/web/index.html` does not intentionally include third-party analytics or tracking scripts.

## Engineering rule

Do not add trackers, session replay tools, ad tech, or behavioural analytics without:
- documenting the tool here
- documenting legal basis and consent behaviour
- implementing appropriate opt-in where required
- updating the privacy notice and relevant platform disclosures

## Examples of tools that must trigger review

- Google Analytics / GTM
- Microsoft Clarity
- Hotjar / FullStory / LogRocket session replay
- marketing pixels
- crash/telemetry tools that collect personal data or identifiers
