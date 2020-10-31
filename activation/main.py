import os
from time import sleep

from selenium.webdriver import FirefoxProfile
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox import webdriver
from selenium.webdriver.support import expected_conditions
from selenium.webdriver.support.expected_conditions import presence_of_element_located, element_to_be_clickable
from selenium.webdriver.support.wait import WebDriverWait

email = os.environ['UNITY_EMAIL']
password = os.environ['UNITY_PASSWORD']

profile = FirefoxProfile()

profile.set_preference("browser.download.folderList", 2)
profile.set_preference("browser.download.manager.showWhenStarting", False)
profile.set_preference("browser.download.dir", os.path.abspath("."))
profile.set_preference("browser.helperApps.neverAsk.saveToDisk", "text/plain, application/octet-stream, application/binary, text/csv, application/csv, application/excel, text/comma-separated-values, text/xml, application/xml")

with webdriver.WebDriver(profile) as ff:
    ff.get("https://id.unity.com")
    emailField = ff.find_element_by_id("conversations_create_session_form_email")
    emailField.send_keys(email)
    passwordField = ff.find_element_by_id("conversations_create_session_form_password")
    passwordField.send_keys(password)
    ff.find_element_by_css_selector("input[type=submit]").click()

    ff.get("https://license.unity3d.com/manual")
    WebDriverWait(ff, 5).until(expected_conditions.url_contains("oauth"))
    WebDriverWait(ff, 5).until(expected_conditions.url_to_be("https://license.unity3d.com/manual"))

    licenseFilePath = os.path.abspath("UnityRequestFile.alf")
    print("License file path: " + licenseFilePath)

    licenseFileField = WebDriverWait(ff, 5).until(presence_of_element_located((By.ID, "licenseFile")))
    licenseFileField.send_keys(licenseFilePath)
    ff.find_element_by_css_selector("input[type=submit]").click()

    WebDriverWait(ff, 5).until(presence_of_element_located((By.CSS_SELECTOR, "label[for=type_personal]"))).click()
    ff.find_element_by_css_selector("label[for=option3]").click()
    ff.find_element_by_css_selector(".option-personal input[type=submit]").click()

    ff.find_element_by_css_selector("input[type=submit]").click()

    sleep(5)
