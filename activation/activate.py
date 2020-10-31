import os
import sys
from time import sleep

from selenium import webdriver
from selenium.webdriver import ChromeOptions
from selenium.webdriver.chrome.webdriver import WebDriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions
from selenium.webdriver.support.expected_conditions import presence_of_element_located
from selenium.webdriver.support.wait import WebDriverWait

email = os.environ['UNITY_EMAIL']
password = os.environ['UNITY_PASSWORD']

options = ChromeOptions()


def _create_web_driver():
    if "selenium" in sys.argv:
        return webdriver.Remote(command_executor="http://localhost:4444/wd/hub", options=options)
    else:
        return WebDriver(options=options)


with _create_web_driver() as ff:
    ff.get("https://id.unity.com")
    print("Page opened")
    emailField = WebDriverWait(ff, 10).until(presence_of_element_located((By.ID, "conversations_create_session_form_email")))
    emailField.send_keys(email)
    print("Email filled " + email[-2:])
    passwordField = WebDriverWait(ff, 10).until(presence_of_element_located((By.ID, "conversations_create_session_form_password")))
    passwordField.send_keys(password)
    print("Password filled " + password[-2:])
    WebDriverWait(ff, 10).until(expected_conditions.element_to_be_clickable((By.CSS_SELECTOR, "input[type=submit]"))).click()
    print("Submit clicked")

    WebDriverWait(ff, 10).until(expected_conditions.url_to_be("https://id.unity.com/en/account/edit"))

    ff.get("https://license.unity3d.com/manual")
    sleep(10)  # reload the manual page after credentials check, chrome doesn't allow to check the URL
    print("Activation page reloaded")

    licenseFilePath = os.path.abspath("UnityRequestFile.alf")
    print("License file path: " + licenseFilePath)

    licenseFileField = WebDriverWait(ff, 10).until(presence_of_element_located((By.ID, "licenseFile")))
    licenseFileField.send_keys(licenseFilePath)
    ff.find_element_by_css_selector("input[type=submit]").click()

    WebDriverWait(ff, 10).until(presence_of_element_located((By.CSS_SELECTOR, "label[for=type_personal]"))).click()
    ff.find_element_by_css_selector("label[for=option3]").click()
    WebDriverWait(ff, 10).until(expected_conditions.element_to_be_clickable((By.CSS_SELECTOR, ".option-personal input[type=submit]"))).click()

    WebDriverWait(ff, 10).until(expected_conditions.element_to_be_clickable((By.CSS_SELECTOR, "input[type=submit]"))).click()

    sleep(10)  # let the download finish
