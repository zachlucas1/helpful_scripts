"""Imports OS for ENV variables, gspread to interface with Google Sheets, 
and requests to work with APIs"""

import os
import json
from dotenv import load_dotenv
import gspread
import requests

# Load environment variables from .env file
load_dotenv()

# JumpCloud API key stored in .env file
jumpcloud_api_key = os.getenv('JumpCloudAPIKey')

# Google API key parsed from .env file and stored in a variable
google_api_key = os.getenv('GoogleAPIKey')
google_credentials_json = json.loads(google_api_key)

# Authenticates with json file
client = gspread.service_account_from_dict(google_credentials_json)

# Path to GAM/GAM-ADV program
gam_path = "~/bin/gamadv-xtd3/"

#-------------------------------------------------------------------------------

def create_user(
        jumpcloud_api_key,
        url,
        firstname,
        lastname,
        username,
        email,
        displayname,
        title,
        google_groups,
        departments,
        usernames
):

    """Function that creates users in JumpCloud and Google Admin"""
    password = "Red123!@#"
    payload = {
        "activated": True,
        "displayname": displayname,
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "password": password,
        "department": departments[usernames.index(username)],
        "jobTitle": title,
        "password_never_expires": False,
        "password_expired": True,
        "state": "ACTIVATED",
        "username": username
    }

    headers = {"x-api-key": jumpcloud_api_key, "content-type": "application/json"}
    try:
        response = requests.post(url, json=payload, headers=headers, timeout=20)
        response.raise_for_status()
        user_id = response.json().get('id')  # Extract user ID from response
        print(f"JumpCloud user {username} created successfully.")

        # Expire user's password
        expire_url = f"https://console.jumpcloud.com/api/systemusers/{user_id}/expire"
        expire_response = requests.post(expire_url, headers=headers, timeout=20)
        expire_response.raise_for_status()
        print(f"JumpCloud password for user {username} expired successfully.")

        # Execute GAM command to create user
        gamcreateuser = f"{gam_path}gam create user {username} firstname {firstname} lastname {lastname}"
        os.system(gamcreateuser)

        # Execute GAM command to add users to groups
        for group in google_groups:
            gamaddtogroup = f"{gam_path}gam update group {group} add member user {username}"
            os.system(gamaddtogroup)

        # Check if department requires alias email
        department = departments[usernames.index(username)]
        print(f"User {username} department: {department}")
        if department in [
            'Collections',
            'Recovery',
            'Loss Mitigation',
            'Customer Service',
            'Customer Care',
            'Inventory/Remarketing'
        ]:

            # Generate alias email using first name and last initial
            alias_email = f"{firstname.lower()}{lastname[0].lower()}@EMAIL.com"

            # Execute GAM command to create alias email
            gamcreatealias = f"{gam_path}gam create alias {alias_email} user {email}"
            os.system(gamcreatealias)

            # If user is in a Department that requires an alias
            print(f"Alias email {alias_email} for user {username} created using GAM.")

            # If user is not a Department that requires an alias
        else:
            print(f"Department {department} does not require an alias for user {username}.")
    except requests.exceptions.RequestException as e:
        print(f"Failed to create user {username}: {e}")

def main():
    # Prompts for date of new hires, converts to a string so no data type issues
    date = str(input('Please input the date for new hires: '))

    # Opens Staff Updates workbook and points to worksheet inputted
    staff_updates = client.open('Staff Updates').worksheet(date)

    # Opens GigaMatrix workbook and points to worksheet
    giga_matrix = client.open('GigaMatrix - Main').worksheet('User1')

    # Fetch names, departments, and titles from Staff Updates
    names = staff_updates.col_values(1)[1:]
    departments = staff_updates.col_values(5)[1:]
    titles = staff_updates.col_values(6)[1:]

    # Extract first name, last name, email, and username
    first_names = [name.split(' ')[0] for name in names]
    last_names = [name.split()[-1] for name in names]
    emails = [name.lower().replace(' ', '.') + '@arivo.com' for name in names]
    usernames = [email.split('@')[0] for email in emails]

    url = "https://console.jumpcloud.com/api/systemusers"

    # Iterate over each user, update GigaMatrix cell, create user, then wait for 2 seconds
    for first_name, last_name, username, email, title in zip(first_names, last_names, usernames, emails, titles):
        print(f"Updating GigaMatrix cell (row=2, col=1) with title: {title}")
        giga_matrix.update_cell(2, 1, title)

        # Fetch Google Groups from GigaMatrix and format them
        google_groups = giga_matrix.col_values(5)[1:]
        google_groups = [group.lower().replace(' ', '') + '@arivo.com' for group in google_groups]

        # Executes the function
        create_user(
            jumpcloud_api_key,
            url,
            first_name,
            last_name,
            username,
            email,
            f"{first_name} {last_name}",
            title,
            google_groups,
            departments,
            usernames
        )

if __name__ == '__main__':
    main()
