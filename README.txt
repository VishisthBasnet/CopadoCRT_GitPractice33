Salesforce starter
==================

Salesforce specific Accelerator/starter suite.


Overview
--------

This repository provides an example how to work with Salesforce cloud.
It's meant to be used as a template for Salesforce testing projects.

Some Salesforce specific keywords are included to make testing easier.


Usage
-----
* IMPORTANT:
  * Setup MFA with mobile app as instructed here: 
    https://help.pace.qentinel.com/qwords-reference/current/qwords/_attachments/QForce.html#mfa-setup
  * OR contact CRT support for ip's which can be whitelisted.
* Add your Salesforce instance url to CRT variable "login_url"
* Add your Salesforce user to CRT variable "username"
* Add your Salesforce user password to CRT variable "password"
* If using MFA setup, add variable "secret" with your MFA token to CRT variables
  * Note: it's best to encrypt/hide sensitive information (password)

Variables can be added by hovering on top of your test suite, selecting
"Suite details" icon and adding them using "+Variable" button.

Use these automated test cases as a basis to learn and start modifying
them to suit your specific needs.

There are example custom keywords defined in /resources/common.robot.
These are provided for reference and may require modification to work in your specific environment.


Additional information
----------------------

Directory structure:

* Tests are under "tests" folder
* Supporting files are under "resources" folder