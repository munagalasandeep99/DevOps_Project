
# `Ericsson Task



### Task 1: Build a Kubernetes Cluster.
- Open www.skyscanner.net
- Give origin as "Stockholm" and destination as "Everywhere" (Överallt in Swedish)
- Choose travel dates 22 Dec 2023 and return date 06 Jan 2024 and 1 adult as passenger.
- Search for flights
- Click on the first entry and see the lowest price shown there is same as the lowest price shown when clicked on the link.
- For ex : if it shows 500 SEK for Gothenburg as cheapest as first link, when clicked on the link it should show same 500 SEK as cheapest. If it shows different price, then the test case should be failed. Otherwise it should show as passed.

You can choose any open source testing tool of your choice. For Ex : selenium, playwright, webdriverIO etc

<p>Approach:</p>

# Tool Selection:
<p> <b>Playwright Automation Tool</b> Playwright was chosen for its cross-browser compatibility and robust automation capabilities. The test aimed to verify the end-to-end flight search functionality and price comparison on the Skyscanner website.</p>

# Logic and Test Case:
<p>Navigation and Interaction:</p>
- Opened Skyscanner website and handled the cookie consent.
- Set origin and destination locations.
- Specified travel dates and the number of adults.
- Initiated a flight search and selected the first flight option.
- Compare the initial and final ticket prices after clicking the flight option.

# Test Execution:
<p>Test Steps:</p>
- Opened the Skyscanner website.
- Handled the cookie consent.
- Set the origin and destination locations.
- Selected travel dates and the number of adults.
- Initiated a flight search and selected the first flight option.
- Compare the initial and final ticket prices after clicking the flight option.

# Test Outcome:
<p>Test Result: Passed</p>


## Installation

```Shell
# Run from your project's root directory
npm init playwright@latest

```

Add dependency and install browsers.

```Shell
npm i -D @playwright/test
# install supported browsers
npx playwright install
```
## Procedure

<p>Step1 : create a file name skyscanner.spec.js in tests folder.</p>
<p>Step 2: add the code of skyscanner.spec.js from the tests folder in the repository</p>


<p>Step 3: Now open the terminal and execute the following command to run the test case we created above.</p>

## execution
```Shell
npx playwright test ./tests/skyscanner.spec.js --project firefox --headed
```
## execution video
https://github.com/munagalasandeep99/plywrightskyscanner/assets/129391713/b232c840-dd62-470d-8647-c60bbfcb9359


<h1>Results</h1>
<img width="960" alt="myown" src="https://github.com/munagalasandeep99/plywrightskyscanner/assets/129391713/008d939e-a62d-4f60-8df8-e713c04244ef">

## Challenges:
- Locating Elements: Identifying unique selectors for dynamic elements on the Skyscanner website.
- this code will only work for firefox browser for other browsers it shows
<img width="960" alt="Screenshot 2023-12-19 002440 (1)" src="https://github.com/munagalasandeep99/plywrightskyscanner/assets/129391713/e4195a48-6c19-4868-990d-90ea138eee33">





