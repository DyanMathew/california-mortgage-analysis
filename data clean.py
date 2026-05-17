import pandas as pd

df = pd.read_csv('state_CA.csv', low_memory=False)

# Keep only conventional home purchase loans
df = df[df['loan_purpose'] == 1]          # 1 = home purchase
df = df[df['loan_type'] == 1]             # 1 = conventional

# Drop rows with nulls in key columns
df = df.dropna(subset=['income', 'loan_amount', 'action_taken', 'county_code'])
df = df[df['applicant_race-1'].notna()]

# Decode action_taken into readable labels
action_map = {1:'Originated', 2:'Approved-not-accepted', 3:'Denied', 
              4:'Withdrawn', 5:'Incomplete', 7:'Purchased', 8:'Pre-approval denied'}
df['outcome'] = df['action_taken'].map(action_map)

# Add approval flag (1=approved, 0=denied)
df['approved'] = df['action_taken'].apply(lambda x: 1 if x == 1 else 0)

# Save clean file
df.to_csv('state_CA_clean.csv', index=False)
