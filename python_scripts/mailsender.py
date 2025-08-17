import smtplib
import argparse
import os
from email.message import EmailMessage
import mimetypes

# --- Parse command-line arguments ---
parser = argparse.ArgumentParser(description='Send email via Gmail SMTP.')
parser.add_argument('-t', '--to', dest='to_addr', required=True, help='Recipient email address')
parser.add_argument('-s', '--subject', required=True, help='Email subject')
parser.add_argument('-b', '--body', help='Email body text')
parser.add_argument('-a', '--attachments', nargs='*', help='List of file paths to attach')
parser.add_argument('-c', '--cc', nargs='*', default=[], help='CC recipients (optional)')

args = parser.parse_args()

user     = os.getenv("mail_user")
password = os.getenv("mail_pass")

msg             = EmailMessage()
msg['Subject']  = args.subject
msg['From']     = user
msg['To']       = args.to_addr
msg['Cc']       = args.cc

msg.set_content("This is a fallback plain-text version.")
msg.add_alternative(args.body, subtype='html')


with smtplib.SMTP('smtp.gmail.com', 587) as server:
    server.starttls()  # Secure the connection
    server.login(user, password)
    server.send_message(msg)

print("Email sent!")
