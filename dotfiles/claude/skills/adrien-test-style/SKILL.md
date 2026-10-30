---
name: adrien-test-style
description: >
  Adrien's rules for tests: few high level tests over many unit tests,
  in-memory implementations and simulators instead of mocks, expressive
  factories, assert the outcome the business cares about. Load before
  writing or reviewing tests in any session.
---

# Bad tests are much worse than no tests

Tests are code: the `adrien-coding-style` skill applies to them too.

What objectively makes a test good:
- the same rules as good code apply: expressiveness, show intent, clear flow of data, clear flow of reading
- it runs fast: no undue dependency on the database, network
- it tests something that could actually fail
- it documents load-bearing expectations

What objectively makes a test bad:
- undue mocking
- tests implementation details rather than expected behavior
- high bloat-to-relevance ratio

Hence my preferences are:
- avoid writing any test that you could not survive without
- write 1 very high level test for the happy path
- write 1 or 2 tests for the dominant edge-cases
- provide simulators and in-memory implementation of your largest dependencies
    - in-memory repo instead of sql repo
    - simulator instead of Stripe
    - write to txt file instead of generating PDF
    - etc....
- use expressive factories to generate your test data
- every test explains its scenario and why it matters
    - with a behavior driven framework (Behave, etc...), the scenario is the test
    - otherwise it goes in a docstring, written as the `adrien-docstrings` skill says
    - the test name, the factories and the asserts make the scenario obvious even before the docstring is written
- avoid unit tests and prefer testing a feature or a behavior as a whole

The following is bad:

```python
@patch("claims.duplicates.fraud_alerts")
@patch("claims.duplicates.claim_repository")
def test_flag_duplicate_claims(mock_repo, mock_alerts):
    claim_1 = Claim(id=1, member_id=42, provider_id=7, amount=Decimal("25.00"), care_date=date(2026, 3, 10), status="pending", created_at=datetime(2026, 3, 11), source="pharmacy", currency="EUR")
    claim_2 = Claim(id=2, member_id=42, provider_id=7, amount=Decimal("25.00"), care_date=date(2026, 3, 10), status="pending", created_at=datetime(2026, 3, 12), source="upload", currency="EUR")
    mock_repo.get_by_ids.return_value = [claim_2]
    mock_repo.get_for_member.return_value = [claim_1, claim_2]
    flag_duplicate_claims([2])
    mock_repo.get_by_ids.assert_called_once_with([2])
    mock_repo.get_for_member.assert_called_once_with(member_id=42, care_date_after=date(2026, 2, 8))
    mock_alerts.report_duplicate_claim.assert_called_once_with(claim=claim_2, duplicates=[claim_1])
```

What makes it bad:
- the repository is mocked: the test passes even if the real query is wrong
- it asserts how the code calls its dependencies, not what the feature does: rename an argument and it breaks, with no bug
- 9 fields per claim when only 3 matter to the scenario (member, provider, amount), the reader has to dig for them
- `claim_1`, `claim_2`, `42`, `7` say nothing about the role each one plays
- wall of text, no way to see where setup ends and checks begin

The following is good, same scenario:

```python
def test_same_claim_sent_twice_alerts_fraud_team(
    claim_repository: InMemoryClaimRepository,
    fraud_alerts: FraudAlertsSimulator,
):
    member = MemberFactory()
    pharmacy = ProviderFactory()

    claim_from_pharmacy = ClaimFactory(member=member, provider=pharmacy, amount=25)
    same_claim_uploaded_by_member = ClaimFactory(member=member, provider=pharmacy, amount=25)
    claim_repository.add(claim_from_pharmacy, same_claim_uploaded_by_member)

    flag_duplicate_claims([same_claim_uploaded_by_member.id])

    assert fraud_alerts.reported == [
        DuplicateClaimAlert(claim=same_claim_uploaded_by_member, duplicates=[claim_from_pharmacy]),
    ]
```

What makes it good:
- in-memory repository and alert simulator: the real logic runs, fast, without a database
- it asserts the outcome the business cares about: the fraud team got one alert, for the right claim
- factories only set what the scenario is about (same member, same provider, same amount), everything else is a default
- names tell the story: `claim_from_pharmacy`, `same_claim_uploaded_by_member`, so a reader understands the scenario without guessing
- empty lines split setup, action and check
