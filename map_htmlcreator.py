# -*- coding: utf-8 -*-
"""
Created on Mon Jun 10 08:47:47 2019

@author: aritra.chatterjee
"""

import os 
import json
os.chdir(r'C:\Users\aritra.chatterjee\Desktop\Trek_Maps')
import subprocess

""" Run the Documentation file with R"""
r_home = "C:/PROGRA~1/R/R-35~1.2/bin/x64/Rscript"
arg = '--vanilla'
path2script = r'C:\Users\aritra.chatterjee\Desktop\Trek_Maps\sandakpu.R'
retcode = subprocess.call([r_home, arg, path2script], shell=True)


""" Add the code for mobile view comaptibility below the html head tag"""

with open('sandakpup_trek_map.html','r') as  file:
    html = file.readlines()

html[3] = '<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no", charset="utf-8" />\n'
html[2]='<head>\n' + '''body {
    padding: 0;
    margin: 0;
}
html, body, #map {
    height: 50vh;
    width: 100vw;
}\n'''


html_file = ''.join(html)

with open('sandakpup_trek_map.html','w') as  file_write:
    file_write.write(''.join(html_file))
    
""" Read the auth file"""
with open('auth.txt','r') as file:
    oauth = json.load(file)
    
import os, smtplib, ssl, getpass
from datetime import datetime
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
from email.mime.base import MIMEBase
from email import encoders as Encoders
import getpass

port = 465

def send_mail(username, password, from_addr, to_addrs, msg):
    context = ssl.create_default_context()
    with smtplib.SMTP_SSL("smtp.gmail.com", port,context=context) as server:
        server.login(username, password)
        server.sendmail(from_addr, to_addrs, msg.as_string())



def mailto(email_list):
    username=oauth['username']
    password  = oauth['password']
    fromaddr = username
    file_to_attach = r"C:\Users\aritra.chatterjee\Desktop\Trek_Maps\sandakpup_trek_map.html" 
    Body =   """<!DOCTYPE html>
                <html>
                <head>
                <style>
                body {
                        color: red;
                }
                h4 {
                        color: #1E162F;
                        font-size: 20px;
                }
                h5 {
                        color: rgb(0,0,255);
                        font-size: 15px;
                }
                
                p {
                        color: rgb(0,0,255)
                }
                </style>
                </head>
                <body>
                 
                <h4>Sandakpu Trek Map Details</h4>
                 
                </body>
                </html>
                """
    Body += u'<h5> Hi Richie,</h5>'            
    Body += u'''<p>Please find the attached html map file.
                   Mobile: Open it with Firefox browser.
                   Laptop: Open it with any browser, recommended.                      
    </p>'''
    
    for i in range(len(email_list)):
        msg = MIMEMultipart()
        Mail_Body=MIMEText(Body, 'html')
        msg.attach(Mail_Body)
        msg['From'] = username
        msg['To'] = email_list[i]
        msg['Subject'] = "Sandakpu Trek Map Details"
        """Attach the file"""
    
        part = MIMEBase('application', 'octet-stream')
        part.set_payload(open(file_to_attach, 'rb').read())
        Encoders.encode_base64(part)
                
        part.add_header('Content-Disposition', 'attachment; filename="%s"' % file_to_attach)    
        msg.attach(part)
            
        send_mail(username=username, password=password, from_addr=fromaddr, to_addrs=email_list[i], msg=msg)

email_list = ['richie.chatterjee31@gmail.com']
#'arindamsaccount@gmail.com','Pratyush.biswas@gmail.com'
mailto(email_list)
